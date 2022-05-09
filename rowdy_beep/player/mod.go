package player

import (
	"log"
	"os"
	"time"

	"github.com/faiface/beep"
	"github.com/faiface/beep/mp3"
	"github.com/faiface/beep/speaker"
	"github.com/google/uuid"
)

type Player struct {
	id         string
	sampleRate beep.SampleRate
}

func Default() *Player {
	return &Player{
		id:         uuid.New().String(),
		sampleRate: 44100, //44.1 kHz
	}
}

func play(player *Player, source string) {
	f, err := os.Open("audio/malibu.mp3")
	if err != nil {
		log.Fatal(err)
	}
	streamer, format, err := mp3.Decode(f)
	if err != nil {
		log.Fatal(err)
	}
	defer streamer.Close()
	speaker.Init(format.SampleRate, format.SampleRate.N(time.Second/10))
	speaker.Play(beep.Seq(streamer))
}
