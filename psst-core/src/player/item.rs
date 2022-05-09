use crate::{
    audio::{decode::AudioDecoder, normalize::NormalizationLevel},
    error::Error,
    item_id::ItemId,
};

use super::{
    file::{MediaFile, MediaPath},
    PlaybackConfig,
};

pub struct LoadedPlaybackItem {
    pub file: MediaFile,
    pub source: AudioDecoder,
    pub norm_factor: f32,
}

#[derive(Debug, Clone, Copy, Eq, PartialEq)]
pub struct PlaybackItem {
    pub item_id: ItemId,
    pub norm_level: NormalizationLevel,
}

impl PlaybackItem {
    pub fn load(&self, path: String, config: &PlaybackConfig) -> Result<LoadedPlaybackItem, Error> {
        let file = MediaFile::open(path)?;
        let (source, norm_data) = file.audio_source(key)?;
        let norm_factor = norm_data.factor_for_level(self.norm_level, config.pregain);
        Ok(LoadedPlaybackItem {
            file,
            source,
            norm_factor,
        })
    }
}
