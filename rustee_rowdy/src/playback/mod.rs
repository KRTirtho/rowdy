use std::path::Path;
use std::pin::Pin;
use std::sync::Arc;

use playback::playback_server::Playback;
use playback::{Duration, Empty, Msg, Speed, Volume};
use rowdy_player::{GeneralP, Player};
use tokio::sync::{mpsc, RwLock};
use tokio_stream::{wrappers::UnboundedReceiverStream, Stream};
use tonic::{Request, Response, Status};

pub mod playback {
    tonic::include_proto!("playback");
    pub(crate) const FILE_DESCRIPTOR_SET: &[u8] =
        tonic::include_file_descriptor_set!("playback_descriptor");
}

type DurationResponseStream = Pin<Box<dyn Stream<Item = Result<Duration, Status>> + Send>>;

pub struct PlaybackService {
    player: Arc<RwLock<Player>>,
}

impl Default for PlaybackService {
    fn default() -> Self {
        PlaybackService {
            player: Arc::new(RwLock::new(Player::default())),
        }
    }
}

#[tonic::async_trait]
impl Playback for PlaybackService {
    async fn get_hello(&self, _incoming: Request<Empty>) -> Result<Response<Msg>, Status> {
        Ok(Response::new(Msg {
            msg: "Hello LOL".to_string(),
        }))
    }
    async fn play(
        &self,
        incoming: Request<self::playback::Path>,
    ) -> Result<Response<Duration>, Status> {
        let pathref = incoming.get_ref();
        let path = Path::new(pathref.cwd.as_str()).join(pathref.path.as_str());
        let mut player = self.player.write().await;
        player.play(&path);

        Ok(Response::new(Duration {
            milliseconds: (player.duration().unwrap_or_else(|| 0_f64) * 1000_f64).round() as i64,
        }))
    }
    async fn pause(&self, _incoming: Request<Empty>) -> Result<Response<Empty>, Status> {
        let mut player = self.player.write().await;
        player.pause();
        Ok(Response::new(Empty {}))
    }
    async fn resume(&self, _incoming: Request<Empty>) -> Result<Response<Empty>, Status> {
        let mut player = self.player.write().await;
        player.resume();
        Ok(Response::new(Empty {}))
    }
    async fn stop(&self, _incoming: Request<Empty>) -> Result<Response<Empty>, Status> {
        let mut player = self.player.write().await;
        player.stop();
        Ok(Response::new(Empty {}))
    }
    async fn toggle_playback(&self, _incoming: Request<Empty>) -> Result<Response<Empty>, Status> {
        let mut player = self.player.write().await;
        if player.is_paused() {
            player.resume();
        } else {
            player.pause();
        }
        Ok(Response::new(Empty {}))
    }
    async fn get_volume(&self, _incoming: Request<Empty>) -> Result<Response<Volume>, Status> {
        let player = self.player.read().await;

        Ok(Response::new(Volume {
            volume: player.volume_percent() as f64,
        }))
    }
    async fn set_volume(&self, incoming: Request<Volume>) -> Result<Response<Empty>, Status> {
        let mut player = self.player.write().await;
        let volume = incoming.get_ref().volume;
        player.set_volume(volume.round() as i32);
        Ok(Response::new(Empty {}))
    }
    async fn get_speed(&self, _incoming: Request<Empty>) -> Result<Response<Speed>, Status> {
        let player = self.player.read().await;
        Ok(Response::new(Speed {
            speed: player.speed() as f64,
        }))
    }
    async fn set_speed(&self, incoming: Request<Speed>) -> Result<Response<Empty>, Status> {
        let mut player = self.player.write().await;
        let speed = incoming.get_ref().speed;
        player.set_speed(speed as f32);
        Ok(Response::new(Empty {}))
    }

    async fn seek(&self, incoming: Request<Duration>) -> Result<Response<Empty>, Status> {
        let position = incoming.get_ref().milliseconds;
        let mut player = self.player.write().await;

        player.seek(position / 1000);

        Ok(Response::new(Empty {}))
    }

    async fn get_position(&self, _incoming: Request<Empty>) -> Result<Response<Duration>, Status> {
        let player = self.player.read().await;

        Ok(Response::new(Duration {
            milliseconds: player.elapsed().as_millis() as i64,
        }))
    }

    type GetPositionStreamStream = DurationResponseStream;

    async fn get_position_stream(
        &self,
        _incoming: Request<Empty>,
    ) -> Result<Response<Self::GetPositionStreamStream>, Status> {
        let (tx, rx) = mpsc::unbounded_channel::<Result<Duration, Status>>();
        let player = self.player.read().await;
        let receiver = player.get_elapsed_receiver().clone();
        tokio::spawn(async move {
            println!("Starting Elapse Task");
            let mut prev_pos = 0_f64;
            while let Ok(elapsed) = receiver.recv_async().await {
                let elapsed_secs = elapsed.as_secs_f64();
                println!("Sent time {}", elapsed_secs);
                if prev_pos != elapsed_secs {
                    if let Err(what) = tx.send(Ok(Duration {
                        milliseconds: elapsed.as_millis() as i64,
                    })) {
                        println!("Failed {}", what.to_string());
                    }
                    prev_pos = elapsed_secs;
                }
            }
        });
        let out_stream = Box::pin(UnboundedReceiverStream::new(rx));

        Ok(Response::new(out_stream as Self::GetPositionStreamStream))
    }
}
