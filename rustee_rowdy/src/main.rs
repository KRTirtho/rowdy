mod api;
mod playback;

fn main() -> anyhow::Result<()>{
    api::init_audio_server()
}
