use crate::playback::{self, playback::playback_server::PlaybackServer, PlaybackService};
use tokio::runtime::Runtime;
use tonic::transport::Server;

pub fn hello() -> String {
    return "Hello".to_string();
}

pub fn init_audio_server() -> anyhow::Result<()> {
    let rt = Runtime::new().unwrap();
    rt.block_on(async {
        let service = tonic_reflection::server::Builder::configure()
            .register_encoded_file_descriptor_set(playback::playback::FILE_DESCRIPTOR_SET)
            .build()
            .unwrap();
        println!("Bootstrapping protobuf & services for Audio Server");
        let addr = "[::1]:50051".parse()?;
        let playback_service = PlaybackService::default();
        println!("Audio Server running at {}", addr);
        if let Err(err) = Server::builder()
            .add_service(service)
            .add_service(PlaybackServer::new(playback_service))
            .serve(addr)
            .await
        {
            println!("[Audio Server crashed] {}", err.to_string());
        }
        Ok(())
    })
}
