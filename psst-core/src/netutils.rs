use std::{io::Read, time::Duration};

use ureq::Error;


/// Constructs a Range header value for given offset and length.
fn range_header(offfset: u64, length: u64) -> String {
    let last_byte = offfset + length - 1; // Offset of the last byte of the range is inclusive.
    format!("bytes={}-{}", offfset, last_byte)
}

/// Parses a total content length from a Content-Range response header.
///
/// For example, returns 146515 for a response with header
/// "Content-Range: bytes 0-1023/146515".
fn parse_total_content_length(response: &ureq::Response) -> u64 {
    response
        .header("Content-Range")
        .expect("Content-Range header not found")
        .split('/')
        .last()
        .expect("Failed to parse Content-Range Header")
        .parse()
        .expect("Failed to parse Content-Range Header")
}

/// Parses an expiration of an audio file URL.
/// Expiration is stored either as:
///
///  1. `exp` field after `__token__`:
///     .../...a35817ca410?__token__=exp=1629466995~hmac=df348...
///                                      ^========^
///  2. or at the beginning of the first query parameter:
///     .../59db919e18d6336461a0c71da051842ceef1b5af?1602319025_wu-SPeHxn...
///                                                  ^========^
fn parse_expiration(url: &str) -> Option<Duration> {
    let token_exp = url.split("__token__=exp=").nth(1);
    let expires_millis = if let Some(token_exp) = token_exp {
        // Parse from the expiration token param.
        token_exp.split('~').next()?
    } else {
        // Parse from the first param.
        let first_param = url.split('?').nth(1)?;
        first_param.split('_').next()?
    };
    let expires_millis = expires_millis.parse().ok()?;
    let expires = Duration::from_millis(expires_millis);
    Some(expires)
}

pub fn fetch_file_range(uri: &str, offset: u64, length: u64) -> Result<(u64, impl Read), Error> {
    let response = ureq::get(uri)
        .set("Range", &range_header(offset, length))
        .call()?;
    let total_length = parse_total_content_length(&response);
    let data_reader = response.into_reader();
    Ok((total_length, data_reader))
}
