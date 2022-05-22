use crate::playback::{playback::playback_server::PlaybackServer, PlaybackService};
use tokio::runtime::Runtime;
use tonic::transport::Server;

pub fn hello() -> String {
    return "Hello".to_string();
}

pub fn init_audio_server() -> anyhow::Result<()> {
    let rt = Runtime::new().unwrap();
    rt.block_on(async {
        println!("Bootstrapping protobuf & services for Audio Server");
        let addr = "[::1]:50051".parse()?;
        let playback_service = PlaybackService::default();
        println!("Server started at {}", addr);
        Server::builder()
            .add_service(PlaybackServer::new(playback_service))
            .serve(addr)
            .await?;
        Ok(())
    })
}
