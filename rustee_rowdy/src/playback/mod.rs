use std::path::Path;
use std::sync::{Mutex, Arc};

use playback::playback_server::Playback;
use playback::{Duration, Empty, Msg, Speed, Volume};
use rowdy_player::{GeneralP, Player};
use tonic::{Request, Response, Status};

pub mod playback {
    tonic::include_proto!("playback");
}

pub struct PlaybackService {
    player: Arc<Mutex<Player>>,
}

impl Default for PlaybackService {
    fn default() -> Self {
        PlaybackService {
            player: Arc::new(Mutex::new(Player::default())),
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
        let mut player = self.player.lock().unwrap();
        player.play(&path);

        Ok(Response::new(Duration {
            milliseconds: (player.duration().unwrap_or_else(|| 0_f64) * 1000_f64).round() as i64,
        }))
    }
    async fn pause(&self, _incoming: Request<Empty>) -> Result<Response<Empty>, Status> {
        let mut player = self.player.lock().unwrap();
        player.pause();
        Ok(Response::new(Empty {}))
    }
    async fn resume(&self, _incoming: Request<Empty>) -> Result<Response<Empty>, Status> {
        let mut player = self.player.lock().unwrap();
        player.resume();
        Ok(Response::new(Empty {}))
    }
    async fn stop(&self, _incoming: Request<Empty>) -> Result<Response<Empty>, Status> {
        let mut player = self.player.lock().unwrap();
        player.stop();
        Ok(Response::new(Empty {}))
    }
    async fn toggle_playback(&self, _incoming: Request<Empty>) -> Result<Response<Empty>, Status> {
        let mut player = self.player.lock().unwrap();
        if player.is_paused() {
            player.resume();
        } else {
            player.pause();
        }
        Ok(Response::new(Empty {}))
    }
    async fn get_volume(&self, _incoming: Request<Empty>) -> Result<Response<Volume>, Status> {
        let player = self.player.lock().unwrap();

        Ok(Response::new(Volume {
            volume: player.volume_percent() as f64,
        }))
    }
    async fn set_volume(&self, incoming: Request<Volume>) -> Result<Response<Empty>, Status> {
        let mut player = self.player.lock().unwrap();
        let volume = incoming.get_ref().volume;
        player.set_volume(volume.round() as i32);
        Ok(Response::new(Empty {}))
    }
    async fn get_speed(&self, _incoming: Request<Empty>) -> Result<Response<Speed>, Status> {
        let player = self.player.lock().unwrap();
        Ok(Response::new(Speed {
            speed: player.speed() as f64,
        }))
    }
    async fn set_speed(&self, incoming: Request<Speed>) -> Result<Response<Empty>, Status> {
        let mut player = self.player.lock().unwrap();
        let speed = incoming.get_ref().speed;
        player.set_speed(speed as f32);
        Ok(Response::new(Empty {}))
    }
}
