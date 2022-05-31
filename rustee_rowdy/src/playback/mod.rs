use std::path::Path;
use std::pin::Pin;
use std::sync::Arc;

use playback::playback_server::Playback;
use playback::{
    server_event::Eventtype, Duration, Empty, Msg, PlaybackEventPlayerState, ServerEvent,
    ServerEventName, ServerPlaybackEvent, Speed, Volume,
};
use rowdy_player::{GeneralP, PlaybackStatusType, Player, PlayerControlEvent};
use tokio::sync::{mpsc, RwLock};
use tokio_stream::{wrappers::UnboundedReceiverStream, Stream};
use tonic::{Request, Response, Status};

pub mod playback {
    tonic::include_proto!("playback");
    pub(crate) const FILE_DESCRIPTOR_SET: &[u8] =
        tonic::include_file_descriptor_set!("playback_descriptor");
}

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
            milliseconds: ((player.duration().unwrap_or_else(|| 0_f64) * 1000_f64)
                .round()
                .abs()) as i64,
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

    type SubscribeEventsStream = Pin<Box<dyn Stream<Item = Result<ServerEvent, Status>> + Send>>;

    async fn subscribe_events(
        &self,
        _incoming: Request<Empty>,
    ) -> Result<Response<Self::SubscribeEventsStream>, Status> {
        let (tx, rx) = mpsc::unbounded_channel::<Result<ServerEvent, Status>>();
        let player = self.player.read().await;
        let receiver = player.get_control_event_receiver().clone();
        tokio::spawn(async move {
            while let Ok(event) = receiver.recv_async().await {
                let mut payload = ServerEvent::default();
                match event {
                    PlayerControlEvent::Duration(duration) => {
                        payload.set_name(ServerEventName::Duration);
                        payload.eventtype = Some(Eventtype::DurationData(Duration {
                            milliseconds: duration.as_millis() as i64,
                        }))
                    }
                    PlayerControlEvent::Playback(status_type) => {
                        let mut playback_data = ServerPlaybackEvent::default();
                        let event_type = match status_type {
                            PlaybackStatusType::CHANGED => PlaybackEventPlayerState::Changed,
                            PlaybackStatusType::PAUSED => PlaybackEventPlayerState::Paused,
                            PlaybackStatusType::RESUMED => PlaybackEventPlayerState::Resumed,
                            PlaybackStatusType::STOPPED => PlaybackEventPlayerState::Stopped,
                        };
                        playback_data.set_playback_event_type(event_type);
                        payload.set_name(ServerEventName::Playback);
                        payload.eventtype = Some(Eventtype::PlaybackData(playback_data))
                    }
                    PlayerControlEvent::Speed(speed) => {
                        payload.set_name(ServerEventName::Speed);
                        payload.eventtype = Some(Eventtype::SpeedData(Speed { speed }));
                    }
                    PlayerControlEvent::Volume(volume) => {
                        payload.set_name(ServerEventName::Volume);
                        payload.eventtype = Some(Eventtype::VolumeData(Volume { volume }))
                    }
                }
                if let Err(what) = tx.send(Ok(payload)) {
                    println!("Failed {}", what.to_string());
                }
            }
        });
        let out_stream = Box::pin(UnboundedReceiverStream::new(rx));

        Ok(Response::new(out_stream as Self::SubscribeEventsStream))
    }
}
