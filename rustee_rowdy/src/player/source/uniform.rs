use std::cmp;
use std::time::Duration;

use super::super::conversions::{ChannelCountConverter, DataConverter, SampleRateConverter};
use super::{Sample, Source};

/// An iterator that reads from a `Source` and converts the samples to a specific rate and
/// channels count.
///
/// It implements `Source` as well, but all the data is guaranteed to be in a single frame whose
/// channels and samples rate have been passed to `new`.
#[derive(Clone)]
#[allow(clippy::module_name_repetitions)]
pub struct UniformSourceIterator<I, D>
where
    I: Source,
    I::Item: Sample,
    D: Sample,
{
    inner: Option<DataConverter<ChannelCountConverter<SampleRateConverter<Take<I>>>, D>>,
    target_channels: u16,
    target_sample_rate: u32,
    total_duration: Option<Duration>,
}

impl<I, D> UniformSourceIterator<I, D>
where
    I: Source,
    I::Item: Sample,
    D: Sample,
{
    #[inline]
    #[allow(clippy::use_self)]
    pub fn new(
        input: I,
        target_channels: u16,
        target_sample_rate: u32,
    ) -> UniformSourceIterator<I, D> {
        let total_duration = input.total_duration();
        let input = UniformSourceIterator::bootstrap(input, target_channels, target_sample_rate);

        UniformSourceIterator {
            inner: Some(input),
            target_channels,
            target_sample_rate,
            total_duration,
        }
    }

    #[inline]
    fn bootstrap(
        input: I,
        target_channels: u16,
        target_sample_rate: u32,
    ) -> DataConverter<ChannelCountConverter<SampleRateConverter<Take<I>>>, D> {
        // Limit the frame length to something reasonable
        let frame_len = input.current_frame_len().map(|x| x.min(32768));

        let from_channels = input.channels();
        let from_sample_rate = input.sample_rate();

        let input = Take {
            iter: input,
            n: frame_len,
        };
        let input = SampleRateConverter::new(
            input,
            cpal::SampleRate(from_sample_rate),
            cpal::SampleRate(target_sample_rate),
            from_channels,
        );
        let input = ChannelCountConverter::new(input, from_channels, target_channels);

        DataConverter::new(input)
    }
}

impl<I, D> Iterator for UniformSourceIterator<I, D>
where
    I: Source,
    I::Item: Sample,
    D: Sample,
{
    type Item = D;

    #[inline]
    fn next(&mut self) -> Option<D> {
        if let Some(value) = self.inner.as_mut().unwrap().next() {
            return Some(value);
        }

        let input = self
            .inner
            .take()
            .unwrap()
            .into_inner()
            .into_inner()
            .into_inner()
            .iter;

        let mut input = Self::bootstrap(input, self.target_channels, self.target_sample_rate);

        let value = input.next();
        self.inner = Some(input);
        value
    }

    #[inline]
    fn size_hint(&self) -> (usize, Option<usize>) {
        (self.inner.as_ref().unwrap().size_hint().0, None)
    }
}

impl<I, D> Source for UniformSourceIterator<I, D>
where
    I: Iterator + Source,
    I::Item: Sample,
    D: Sample,
{
    #[inline]
    fn current_frame_len(&self) -> Option<usize> {
        None
    }

    #[inline]
    fn channels(&self) -> u16 {
        self.target_channels
    }

    #[inline]
    fn sample_rate(&self) -> u32 {
        self.target_sample_rate
    }

    #[inline]
    fn total_duration(&self) -> Option<Duration> {
        self.total_duration
    }
    #[inline]
    fn elapsed(&mut self) -> Duration {
        Duration::from_secs(0)
    }
    fn seek(&mut self, time: Duration) -> Result<Duration, ()> {
        let mut input = self
            .inner
            .take()
            .unwrap()
            .into_inner()
            .into_inner()
            .into_inner()
            .iter;
        let ret = input.seek(time);
        let input = Self::bootstrap(input, self.target_channels, self.target_sample_rate);

        self.inner = Some(input);
        ret
    }
}

#[derive(Clone, Debug)]
struct Take<I> {
    iter: I,
    n: Option<usize>,
}

impl<I> Iterator for Take<I>
where
    I: Iterator,
{
    type Item = <I as Iterator>::Item;

    #[inline]
    fn next(&mut self) -> Option<<I as Iterator>::Item> {
        if let Some(n) = &mut self.n {
            if *n == 0 {
                None
            } else {
                *n -= 1;
                self.iter.next()
            }
        } else {
            self.iter.next()
        }
    }

    #[inline]
    fn size_hint(&self) -> (usize, Option<usize>) {
        self.n.map_or_else(
            || self.iter.size_hint(),
            |n| {
                let (lower, upper) = self.iter.size_hint();

                let lower = cmp::min(lower, n);

                let upper = match upper {
                    Some(x) if x < n => Some(x),
                    _ => Some(n),
                };

                (lower, upper)
            },
        )
    }
}
