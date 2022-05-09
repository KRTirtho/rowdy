use std::{error, fmt, io};

#[derive(Debug)]
pub enum Error {
    InvalidPathURI(String),
    MediaFileNotFound,
    AudioFetchingError(Box<dyn error::Error + Send>),
    AudioDecodingError(Box<dyn error::Error + Send>),
    AudioOutputError(Box<dyn error::Error + Send>),
    ResamplingError(i32),
    IoError(io::Error),
    SendError,
}

impl error::Error for Error {}

impl fmt::Display for Error {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            Self::InvalidPathURI(path) => write!(f, "Invalid Path/URI to Audio file {}", path.as_str()),
            Self::MediaFileNotFound => write!(f, "Audio file not found"),
            Self::ResamplingError(code) => {
                write!(f, "Resampling failed with error code {}", code)
            }
            Self::AudioFetchingError(err)
            | Self::AudioDecodingError(err)
            | Self::AudioOutputError(err) => err.fmt(f),
            Self::IoError(err) => err.fmt(f),
            Self::SendError => write!(f, "Failed to send into a channel"),
        }
    }
}

impl From<io::Error> for Error {
    fn from(err: io::Error) -> Error {
        Error::IoError(err)
    }
}

impl<T> From<crossbeam_channel::SendError<T>> for Error {
    fn from(_: crossbeam_channel::SendError<T>) -> Self {
        Error::SendError
    }
}
