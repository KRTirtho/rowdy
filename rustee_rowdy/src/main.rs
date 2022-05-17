use playback::playback_server::{Playback, PlaybackServer};
use playback::{Duration, Empty, Msg, Path, Speed, Volume};
use tokio;
use tonic::transport::Server;
use tonic::{Request, Response, Status};

pub mod playback {
    tonic::include_proto!("playback");
}

#[derive(Default)]
pub struct PlaybackService {}

#[tonic::async_trait]
impl Playback for PlaybackService {
    async fn get_hello(&self, incoming: Request<Empty>) -> Result<Response<Msg>, Status> {
        Ok(Response::new(Msg {
            msg: "Hello LOL".to_string(),
        }))
    }
    async fn play(&self, incoming: Request<Path>) -> Result<Response<Duration>, Status> {
        Ok(Response::new(Duration {
            milliseconds: 42069,
        }))
    }
    async fn pause(&self, incoming: Request<Empty>) -> Result<Response<Empty>, Status> {
        Ok(Response::new(Empty {}))
    }
    async fn resume(&self, incoming: Request<Empty>) -> Result<Response<Empty>, Status> {
        Ok(Response::new(Empty {}))
    }
    async fn stop(&self, incoming: Request<Empty>) -> Result<Response<Empty>, Status> {
        Ok(Response::new(Empty {}))
    }
    async fn toggle_playback(&self, incoming: Request<Empty>) -> Result<Response<Empty>, Status> {
        Ok(Response::new(Empty {}))
    }
    async fn get_volume(&self, incoming: Request<Empty>) -> Result<Response<Volume>, Status> {
        Ok(Response::new(Volume { volume: 50.0 }))
    }
    async fn set_volume(&self, incoming: Request<Volume>) -> Result<Response<Empty>, Status> {
        Ok(Response::new(Empty {}))
    }
    async fn get_speed(&self, incoming: Request<Empty>) -> Result<Response<Speed>, Status> {
        Ok(Response::new(Speed { speed: 2.5 }))
    }
    async fn set_speed(&self, incoming: Request<Speed>) -> Result<Response<Empty>, Status> {
        Ok(Response::new(Empty {}))
    }
}

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let addr = "[::1]:50051".parse()?;
    let playback_service = PlaybackService::default();
    println!("Server started at {}", addr);
    Server::builder()
        .add_service(PlaybackServer::new(playback_service))
        .serve(addr)
        .await?;
    Ok(())
}
