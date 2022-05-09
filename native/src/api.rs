use crate::player::{GeneralP, Player};
use anyhow::{Ok, Result};
use flutter_rust_bridge::StreamSink;
use lazy_static::lazy_static;
use std::{
    path::Path,
    sync::{Arc, Mutex},
};

lazy_static! {
    static ref PLAYER: Arc<Mutex<Option<Player>>> = Arc::new(Mutex::new(None));
}

pub fn init_player() -> Result<()> {
    *PLAYER.lock().unwrap() = Some(Player::default());
    Ok(())
}

pub fn play(path: String) {
    PLAYER
        .lock()
        .unwrap()
        .as_mut()
        .unwrap()
        .play(Path::new(path.as_str()));
}

pub fn pause() {
    PLAYER.lock().unwrap().as_mut().unwrap().pause();
}
pub fn shuffle() {
    // PLAYER.lock().unwrap().as_mut().unwrap().shuffle();
}
pub fn set_volume(volume: i32) {
    PLAYER.lock().unwrap().as_mut().unwrap().set_volume(volume);
}
pub fn set_speed(speed: f32) {
    PLAYER.lock().unwrap().as_mut().unwrap().set_speed(speed);
}
pub fn get_volume() -> i32 {
    PLAYER.lock().unwrap().as_ref().unwrap().volume()
}
pub fn get_speed() -> f32 {
    PLAYER.lock().unwrap().as_ref().unwrap().speed()
}

pub fn toggle_playback() {
    PLAYER.lock().unwrap().as_mut().unwrap().toggle_playback()
}

pub fn resume() {
    PLAYER.lock().unwrap().as_mut().unwrap().resume()
}

pub fn duration() -> f64 {
    PLAYER
        .lock()
        .unwrap()
        .as_ref()
        .unwrap()
        .duration()
        .unwrap_or(0.0)
}

pub fn elapsed() -> u64 {
    PLAYER.lock().unwrap().as_ref().unwrap().elapsed().as_secs()
}

pub fn progress_stream(sink: StreamSink<Vec<f64>>) -> Result<()> {
    let mut lock = PLAYER.lock().unwrap();
    loop {
        let player = lock.as_mut().unwrap();
        let progress = player.get_progress().unwrap();
        if !player.is_paused() {
            sink.add(vec![progress.0, progress.1 as f64, progress.2 as f64]);
        } else if player.elapsed().as_secs_f64() == player.duration().unwrap() {
            // breaking the loop if the track ended playing
            sink.close();
            break;
        }
    }
    Ok(())
}
// pub fn load_playlist() {
//     PLAYER.lock().unwrap().as_mut().unwrap().load_playlist();
// }
// pub fn seek() {
//     PLAYER.lock().unwrap().as_mut().unwrap().seek();
// }
// pub fn skip() {
//     PLAYER.lock().unwrap().as_mut().unwrap().skip();
// }
// pub fn append_playlist() {
//     PLAYER.lock().unwrap().as_mut().unwrap().append_playlist();
// }
// pub fn clear_playlist() {
//     PLAYER.lock().unwrap().as_mut().unwrap().clear_playlist();
// }
// pub fn out_playlist() {
//     PLAYER.lock().unwrap().as_mut().unwrap().out_playlist();
// }
