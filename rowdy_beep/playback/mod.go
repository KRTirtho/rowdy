package playback

import (
	"context"
	"errors"
	"log"
	"os"
	"path"
	"time"

	pb "github.com/KRTirtho/rowdy/rowdy_beep/proto"
	"github.com/faiface/beep"
	"github.com/faiface/beep/effects"
	"github.com/faiface/beep/mp3"
	"github.com/faiface/beep/speaker"
)

const (
	SAMPLE_QUALITY int = 4
)

var DefaultFormat beep.Format = beep.Format{SampleRate: 44100, NumChannels: 2, Precision: 2}

type PlaybackServer struct {
	pb.UnimplementedPlaybackServer
	ctrl      *beep.Ctrl
	volume    *effects.Volume
	speed     *beep.Resampler
	IsPlaying bool
}

func (s *PlaybackServer) GetHello(ctx context.Context, in *pb.Empty) (*pb.Msg, error) {
	return &pb.Msg{Msg: "Hello Amigo"}, nil
}

// Plays audio from any given source, HTTP/Local
func (s *PlaybackServer) Play(ctx context.Context, item *pb.Path) (*pb.Duration, error) {
	file, err := os.Open(path.Join(item.GetCwd(), item.GetPath()))
	if err != nil {
		log.Fatal(err)
		return nil, err
	}

	streamer, format, err := mp3.Decode(file)
	if err != nil {
		log.Fatal(err)
		return nil, err
	}

	// allow play() to be called multiple times
	if s.volume != nil && s.volume.Streamer != nil {
		s.ctrl.Streamer = nil
		s.IsPlaying = false
		speaker.Clear()
	}

	// resampling the audio for perfect amount of sample rate for individual
	// audio file
	resampled := beep.Resample(SAMPLE_QUALITY, format.SampleRate, DefaultFormat.SampleRate, streamer)

	// allows reusable control over multiple stream
	if s.ctrl == nil {
		s.ctrl = &beep.Ctrl{Streamer: resampled, Paused: false}
	} else {
		s.ctrl.Streamer = resampled
		s.ctrl.Paused = false
	}

	// mitigating multiple instantiation of same struct
	if s.volume == nil {
		s.volume = &effects.Volume{
			Streamer: s.ctrl,
			Base:     2,
			Volume:   0,
			Silent:   false,
		}
	} else {
		s.volume.Streamer = s.ctrl
	}

	s.speed = beep.ResampleRatio(SAMPLE_QUALITY, 1, s.volume)

	speaker.Play(beep.Seq(s.speed, beep.Callback(func() {
		s.IsPlaying = false
	})))
	s.IsPlaying = true

	return &pb.Duration{
		Milliseconds: format.SampleRate.D(streamer.Len()).Round(time.Second).Milliseconds(),
	}, nil
}

func (s *PlaybackServer) Pause(ctx context.Context, in *pb.Empty) (*pb.Empty, error) {
	speaker.Lock()
	s.ctrl.Paused = true
	s.IsPlaying = false
	speaker.Unlock()
	return &pb.Empty{}, nil
}

func (s *PlaybackServer) Resume(ctx context.Context, in *pb.Empty) (*pb.Empty, error) {
	speaker.Lock()
	s.ctrl.Paused = false
	s.IsPlaying = true
	speaker.Unlock()
	return &pb.Empty{}, nil
}

func (s *PlaybackServer) Stop(ctx context.Context, in *pb.Empty) (*pb.Empty, error) {
	s.volume.Streamer = nil
	s.IsPlaying = false
	speaker.Clear()
	return &pb.Empty{}, nil
}

func (s *PlaybackServer) TogglePlayback(ctx context.Context, in *pb.Empty) (*pb.Empty, error) {
	speaker.Lock()
	if s.IsPlaying {
		s.ctrl.Paused = true
		s.IsPlaying = false
	} else {
		s.ctrl.Paused = false
		s.IsPlaying = true
	}
	speaker.Unlock()
	return &pb.Empty{}, nil
}

func (s *PlaybackServer) GetVolume(ctx context.Context, in *pb.Empty) (*pb.Volume, error) {
	if s.volume == nil {
		return nil, errors.New("player isn't ready yet")
	}
	// converting from floating to percantage
	return &pb.Volume{Volume: s.volume.Volume * 100}, nil
}

func (s *PlaybackServer) SetVolume(ctx context.Context, in *pb.Volume) (*pb.Empty, error) {
	if s.volume == nil {
		return nil, errors.New("player isn't ready yet")
	}
	speaker.Lock()
	// converting from percentage to floating
	s.volume.Volume = in.GetVolume() / 100
	speaker.Unlock()
	return &pb.Empty{}, nil
}

func (s *PlaybackServer) GetSpeed(ctx context.Context, in *pb.Empty) (*pb.Speed, error) {
	if s.speed == nil {
		return nil, errors.New("player isn't ready yet")
	}
	// converting from floating to percantage
	return &pb.Speed{Speed: s.speed.Ratio() * 100}, nil
}

func (s *PlaybackServer) SetSpeed(ctx context.Context, in *pb.Speed) (*pb.Empty, error) {
	if s.speed == nil {
		return nil, errors.New("player isn't ready yet")
	}
	speaker.Lock()
	// converting from percentage to floating
	s.speed.SetRatio(in.GetSpeed() / 100)
	speaker.Unlock()
	return &pb.Empty{}, nil
}
