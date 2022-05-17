mod api;
mod bridge_generated;
mod player;

#[cfg(test)]
mod tests {

    use std::{thread, time::Duration};

    use crate::api::{duration, init_player, pause, play, resume, elapsed};

    #[test]
    fn audio_plays() {
        init_player();
        play(String::from("/home/krtirtho/dev/beep/audio/malibu.mp3"));
        println!("total duration: {}", duration());
        thread::sleep(Duration::from_secs(5));
        pause();
        thread::sleep(Duration::from_secs(5));
        resume();

        loop {
          println!("Progress: {}", elapsed())
        }
    }
}
