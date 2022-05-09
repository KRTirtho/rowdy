use std::{
    io,
    io::{Seek, SeekFrom},
    path::Path,
    sync::Arc,
    thread,
    thread::JoinHandle,
    time::Duration,
};

use url::Url;

use ureq::Error;

use crate::{audio::decode::AudioCodecFormat, error, netutils};

use super::storage::{StreamRequest, StreamStorage, StreamWriter};

#[derive(Debug, PartialEq, Eq, Clone, Copy)]
pub enum Format {
    OGG_VORBIS_96 = 0,
    OGG_VORBIS_160 = 1,
    OGG_VORBIS_320 = 2,
    MP3_256 = 3,
    MP3_320 = 4,
    MP3_160 = 5,
    MP3_96 = 6,
    MP3_160_ENC = 7,
    MP4_128_DUAL = 8,
    OTHER3 = 9,
    AAC_160 = 10,
    AAC_320 = 11,
    MP4_128 = 12,
    OTHER5 = 13,
}

#[derive(Debug, Clone)]
pub struct MediaPath {
    pub path: String,
    pub file_format: Format,
    pub duration: Duration,
}

pub enum MediaFile {
    Streamed {
        streamed_file: Arc<StreamedFile>,
        servicing_handle: JoinHandle<()>,
    },
    Local {
        path: Box<Path>,
    },
}

impl MediaFile {
    pub fn supported_audio_formats_for_bitrate(bitrate: usize) -> &'static [Format] {
        match bitrate {
            96 => &[
                Format::OGG_VORBIS_96,
                Format::MP3_96,
                Format::OGG_VORBIS_160,
                Format::MP3_160,
                Format::MP3_160_ENC,
                Format::MP3_256,
                Format::OGG_VORBIS_320,
                Format::MP3_320,
            ],
            160 => &[
                Format::OGG_VORBIS_160,
                Format::MP3_160,
                Format::MP3_160_ENC,
                Format::MP3_256,
                Format::OGG_VORBIS_320,
                Format::MP3_320,
                Format::OGG_VORBIS_96,
                Format::MP3_96,
            ],
            320 => &[
                Format::OGG_VORBIS_320,
                Format::MP3_320,
                Format::MP3_256,
                Format::OGG_VORBIS_160,
                Format::MP3_160,
                Format::MP3_160_ENC,
                Format::OGG_VORBIS_96,
                Format::MP3_96,
            ],
            _ => unreachable!(),
        }
    }

    //change the way of handling audio
    // TODO:
    // - Load local files from URL
    // - Load File Stream
    //   - Load HTTP Streamed files
    pub fn open(path: String) -> Result<Self, error::Error> {
        let url;
        match Url::parse(path.as_str()) {
            Ok(parsed) => url = parsed,
            Err(err) => {
                return Err(error::Error::InvalidPathURI(path));
            }
        }

        let streamed_file;
        match StreamedFile::open(url) {
            Ok(file) => streamed_file = Arc::new(file),
            Err(err) => return Err(error::Error::AudioFetchingError(Box::new(err))),
        }

        // open HTTP streamed audio file
        let servicing_handle = thread::spawn({
            let streamed_file = Arc::clone(&streamed_file);
            move || {
                streamed_file
                    .service_streaming()
                    .expect("Streaming thread failed");
            }
        });
        Ok(Self::Streamed {
            streamed_file,
            servicing_handle,
        })
    }

    pub fn path(&self) -> String {
        match self {
            Self::Streamed { streamed_file, .. } => streamed_file.url.to_string(),
            Self::Local { path, .. } => String::from(path.to_str().unwrap()),
        }
    }

    pub fn storage(&self) -> Option<&StreamStorage> {
        match self {
            Self::Streamed { streamed_file, .. } => Some(&streamed_file.storage),
            _ => None,
        }
    }

    fn header_length(&self) -> u64 {
        match self.path().file_format {
            Format::OGG_VORBIS_96 | Format::OGG_VORBIS_160 | Format::OGG_VORBIS_320 => 167,
            _ => 0,
        }
    }

    fn codec_format(&self) -> AudioCodecFormat {
        match self.path().file_format {
            Format::OGG_VORBIS_96 | Format::OGG_VORBIS_160 | Format::OGG_VORBIS_320 => {
                AudioCodecFormat::OggVorbis
            }
            Format::MP3_256
            | Format::MP3_320
            | Format::MP3_160
            | Format::MP3_96
            | Format::MP3_160_ENC => AudioCodecFormat::Mp3,
            _ => unreachable!(),
        }
    }
}

pub struct StreamedFile {
    url: Url,
    storage: StreamStorage,
}

impl StreamedFile {
    fn open(url: Url) -> Result<StreamedFile, Error> {
        // How many bytes we request in the first chunk.
        const INITIAL_REQUEST_LENGTH: u64 = 1024 * 6;

        // Send the initial request, that gives us the total file length
        // and the beginning of the contents. Use the total length for
        // creating the backing data storage

        // TODO: use a http client instead of CDN
        let (total_length, mut initial_data) =
            netutils::fetch_file_range(url.path(), 0, INITIAL_REQUEST_LENGTH)?;
        let storage = StreamStorage::new(total_length)?;

        // Pipe the initial data from the request body into storage.
        io::copy(&mut initial_data, &mut storage.writer()?)?;

        Ok(StreamedFile { storage, url: url })
    }

    fn service_streaming(&self) -> Result<(), Error> {
        let mut download_range = |offset, length| -> Result<(), Error> {
            let thread_name = format!(
                "cdn-{}-{}..{}",
                self.url.as_str(),
                offset,
                offset + length
            );
            // TODO: We spawn threads here without any accounting.  Seems wrong.
            thread::Builder::new().name(thread_name).spawn({
                let url = String::from(self.url.as_str());
                let mut writer = self.storage.writer()?;
                let file_path = self.storage.path().to_path_buf();
                move || {
                    if let Err(err) = load_range(&mut writer, &url, offset, length) {
                        log::error!("failed to download: {}", err);
                        // Range failed to download, remove it from the requested set.
                        writer.mark_as_not_requested(offset, length);
                    }
                }
            })?;

            Ok(())
        };

        while let Ok(req) = self.storage.receiver().recv() {
            match req {
                StreamRequest::Preload { offset, length } => {
                    if let Err(err) = download_range(offset, length) {
                        log::error!("failed to request audio range: {:?}", err);
                    }
                }
                StreamRequest::Blocked { offset } => {
                    log::info!("blocked at {}", offset);
                }
            }
        }
        Ok(())
    }
}

fn load_range(writer: &mut StreamWriter, url: &str, offset: u64, length: u64) -> Result<(), Error> {
    log::trace!("downloading {}..{}", offset, offset + length);

    // Download range of data from the CDN.  Block until we a have reader of the
    // request body.
    let (_total_length, mut reader) = netutils::fetch_file_range(url, offset, length)?;

    // Pipe it into storage. Blocks until fully written, but readers sleeping on
    // this file should be notified as soon as their offset is covered.
    writer.seek(SeekFrom::Start(offset))?;
    io::copy(&mut reader, writer)?;

    Ok(())
}

struct LocalFile {
    path: Box<Path>,
    bitrate: i32,
    duration: Duration,
}

impl LocalFile {
    fn open(path: Box<Path>) -> Result<Self, error::Error> {
        unimplemented!("Implement open to open Audio Files with perfect encodings")
    }
}
