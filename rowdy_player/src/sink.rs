use std::sync::mpsc::Receiver;
use std::sync::{Arc, Mutex, RwLock};
use std::time::Duration;
// use std::{
//     collections::VecDeque,
//     sync::atomic::{AtomicBool, AtomicUsize, Ordering},
// };
use flume;
use std::sync::atomic::{AtomicBool, AtomicUsize, Ordering};

use crate::{PlaybackStatusType, PlayerControlEvent};

use super::{queue, source::Done, Sample, Source};
use super::{OutputStreamHandle, PlayError};

/// Handle to an device that outputs sounds.
///
/// Dropping the `Sink` stops all sounds. You can use `detach` if you want the sounds to continue
/// playing.
pub struct Sink {
    queue_tx: Arc<queue::SourcesQueueInput<f32>>,
    // sleep_until_end: Mutex<VecDeque<Receiver<()>>>,
    sleep_until_end: Mutex<Option<Receiver<()>>>,

    controls: Arc<Controls>,
    sound_count: Arc<AtomicUsize>,

    detached: bool,

    elapsed: Arc<RwLock<Duration>>,

    control_event_tx: Arc<flume::Sender<PlayerControlEvent>>,
    pub control_event_rx: Arc<flume::Receiver<PlayerControlEvent>>,
}

struct Controls {
    pause: AtomicBool,
    volume: Mutex<f32>,
    seek: Mutex<Option<Duration>>,
    stopped: AtomicBool,
    speed: Mutex<f32>,
}

#[allow(unused, clippy::missing_const_for_fn)]
impl Sink {
    /// Builds a new `Sink`, beginning playback on a stream.
    #[inline]
    pub fn try_new(stream: &OutputStreamHandle, chan: (Arc<flume::Sender<PlayerControlEvent>>, Arc<flume::Receiver<PlayerControlEvent>>)) -> Result<Self, PlayError> {
        let (sink, queue_rx) = Self::new_idle(chan);
        stream.play_raw(queue_rx)?;
        // stream.play_raw(queue_rx).ok();
        Ok(sink)
    }

    /// Builds a new `Sink`.
    #[inline]
    pub fn new_idle((control_event_tx, control_event_rx): (Arc<flume::Sender<PlayerControlEvent>>, Arc<flume::Receiver<PlayerControlEvent>>)) -> (Self, queue::SourcesQueueOutput<f32>) {
        let (queue_tx, queue_rx) = queue::queue(true);

        let sink = Self {
            queue_tx,
            // sleep_until_end: Mutex::new(VecDeque::new()),
            sleep_until_end: Mutex::new(None),
            controls: Arc::new(Controls {
                pause: AtomicBool::new(false),
                volume: Mutex::new(1.0),
                stopped: AtomicBool::new(false),
                seek: Mutex::new(None),
                speed: Mutex::new(1.0),
            }),
            sound_count: Arc::new(AtomicUsize::new(0)),
            detached: false,
            elapsed: Arc::new(RwLock::new(Duration::from_secs(0))),
            control_event_rx,
            control_event_tx,
        };

        let post_ctrl_event_tx = sink.control_event_tx.clone();

        // default values for [Control] sent as an event
        post_ctrl_event_tx.send(PlayerControlEvent::Duration(Duration::from_secs(0)));
        // TODO Use actual [Path] instead of a fake one
        post_ctrl_event_tx.send(PlayerControlEvent::Playback(PlaybackStatusType::CHANGED));
        post_ctrl_event_tx.send(PlayerControlEvent::Speed(1.0));
        post_ctrl_event_tx.send(PlayerControlEvent::Volume(1.0));
        (sink, queue_rx)
    }

    /// Appends a sound to the queue of sounds to play.
    #[inline]
    pub fn append<S>(&self, source: S)
        where
            S: Source + Send + 'static,
            S::Item: Sample + Send,
    // S::Item: Send,
    {
        let controls = self.controls.clone();

        let elapsed = self.elapsed.clone();
        let source = source
            .speed(1.0)
            .pausable(false)
            .amplify(1.0)
            .stoppable()
            .periodic_access(Duration::from_millis(50), move |src| {
                if controls.stopped.load(Ordering::SeqCst) {
                    src.stop();
                    // control_event_tx
                    //     .send(PlayerControlEvent::Playback(PlaybackStatusType::STOPPED));
                } else {
                    if let Some(seek_time) = controls.seek.lock().unwrap().take() {
                        src.seek(seek_time).unwrap();
                    }
                    let src_elapsed = src.elapsed();
                    *elapsed.write().unwrap() = src_elapsed;
                    src.inner_mut().set_factor(*controls.volume.lock().unwrap());
                    src.inner_mut()
                        .inner_mut()
                        .set_paused(controls.pause.load(Ordering::SeqCst));
                    src.inner_mut()
                        .inner_mut()
                        .inner_mut()
                        .set_factor(*controls.speed.lock().unwrap());
                }
            })
            .convert_samples();
        // firing duration event when the track is finally loaded
        // successfully
        if let Some(duration) = source.total_duration() {
            self.control_event_tx
                .send(PlayerControlEvent::Duration(duration));
        }
        self.sound_count.fetch_add(1, Ordering::Relaxed);
        let source = Done::new(source, self.sound_count.clone());
        // self.sleep_until_end
        //     .lock()
        //     .unwrap()
        //     .push_back(self.queue_tx.append_with_signal(source));
        *self.sleep_until_end.lock().unwrap() = Some(self.queue_tx.append_with_signal(source));
    }

    /// Gets the volume of the sound.
    ///
    /// The value `1.0` is the "normal" volume (unfiltered input). Any value other than 1.0 will
    /// multiply each sample by this value.
    #[inline]
    pub fn volume(&self) -> f32 {
        *self.controls.volume.lock().unwrap()
    }

    /// Changes the volume of the sound.
    ///
    /// The value `1.0` is the "normal" volume (unfiltered input). Any value other than `1.0` will
    /// multiply each sample by this value.
    #[inline]
    pub fn set_volume(&self, value: f32) {
        *self.controls.volume.lock().unwrap() = value;
        self.control_event_tx
            .send(PlayerControlEvent::Volume(value.into()));
    }

    /// Resumes playback of a paused sink.
    ///
    /// No effect if not paused.
    #[inline]
    pub fn play(&self) {
        let prev_value = self.is_paused();
        self.controls.pause.store(false, Ordering::SeqCst);
        if prev_value && !self.is_paused() {
            self.control_event_tx
                .send(PlayerControlEvent::Playback(PlaybackStatusType::RESUMED));
        }
    }

    /// Pauses playback of this sink.
    ///
    /// No effect if already paused.
    ///
    /// A paused sink can be resumed with `play()`.
    pub fn pause(&self) {
        let prev_value = self.is_paused();
        self.controls.pause.store(true, Ordering::SeqCst);
        // only emit event when pause watch actually called & not was not
        // just re-called
        if !prev_value && self.is_paused() {
            self.control_event_tx
                .send(PlayerControlEvent::Playback(PlaybackStatusType::PAUSED));
        }
    }

    /// Toggles playback of the sink
    pub fn toggle_playback(&self) {
        if self.is_paused() {
            self.play();
        } else {
            self.pause();
        }
    }

    pub fn seek(&self, seek_time: Duration) {
        *self.controls.seek.lock().unwrap() = Some(seek_time);
    }

    /// Gets if a sink is paused
    ///
    /// Sinks can be paused and resumed using `pause()` and `play()`. This returns `true` if the
    /// sink is paused.
    pub fn is_paused(&self) -> bool {
        self.controls.pause.load(Ordering::SeqCst)
    }

    /// Destroys the sink without stopping the sounds that are still playing.
    #[inline]
    pub fn detach(mut self) {
        self.detached = true;
    }

    /// Sleeps the current thread until the sound ends.
    #[inline]
    pub fn sleep_until_end(&self) {
        if let Some(sleep_until_end) = self.sleep_until_end.lock().unwrap().take() {
            let _ = sleep_until_end.recv();
        }
    }

    // pub fn get_current_receiver(&self) -> Option<Receiver<()>> {
    //     self.sleep_until_end.lock().unwrap().pop_front()
    // }
    /// Returns true if this sink has no more sounds to play.
    #[inline]
    pub fn is_empty(&self) -> bool {
        self.len() == 0
    }

    /// Returns the number of sounds currently in the queue.
    #[inline]
    pub fn len(&self) -> usize {
        self.sound_count.load(Ordering::Relaxed)
    }

    #[inline]
    pub fn elapsed(&self) -> Duration {
        *self.elapsed.read().unwrap()
    }

    /// Gets the speed of the sound.
    ///
    /// The value `1.0` is the "normal" speed (unfiltered input). Any value other than `1.0` will
    /// change the play speed of the sound.
    #[inline]
    pub fn speed(&self) -> f32 {
        *self.controls.speed.lock().unwrap()
    }

    /// Changes the speed of the sound.
    ///
    /// The value `1.0` is the "normal" speed (unfiltered input). Any value other than `1.0` will
    /// change the play speed of the sound.
    #[inline]
    pub fn set_speed(&self, value: f32) {
        *self.controls.speed.lock().unwrap() = value;
        self.control_event_tx
            .send(PlayerControlEvent::Volume(value.into()));
    }
}

impl Drop for Sink {
    #[inline]
    fn drop(&mut self) {
        self.queue_tx.set_keep_alive_if_empty(false);

        if !self.detached {
            self.controls.stopped.store(true, Ordering::Relaxed);
        }
    }
}
