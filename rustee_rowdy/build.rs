use std::{path::PathBuf, env};

use tonic_build;

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let out_dir = PathBuf::from(env::var("OUT_DIR").unwrap());
    tonic_build::configure()
        .file_descriptor_set_path(out_dir.join("playback_descriptor.bin"))
        .compile(&["proto/playback.proto"], &["proto"])
        .unwrap();

    tonic_build::compile_protos("proto/playback.proto")?;
    Ok(())
}
