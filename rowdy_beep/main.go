package main

import (
	"context"
	"errors"
	"fmt"
	"log"
	"net"
	"os"
	"path"
	"time"

	pb "github.com/KRTirtho/rowdy/rowdy_beep/proto"
	"github.com/faiface/beep"
	"github.com/faiface/beep/effects"
	"github.com/faiface/beep/mp3"
	"github.com/faiface/beep/speaker"
	"google.golang.org/grpc"
	"google.golang.org/grpc/reflection"
)

const (
	port           int = 50551
	SAMPLE_QUALITY int = 4
)

type playbackServer struct {
	pb.UnimplementedPlaybackServer
	ctrl       *beep.Ctrl
	volume     *effects.Volume
	speed      *beep.Resampler
	is_playing bool
}

func (s *playbackServer) GetHello(ctx context.Context, in *pb.Empty) (*pb.Msg, error) {
	return &pb.Msg{Msg: "Hello Amigo"}, nil
}

// Plays audio from any given source, HTTP/Local
func (s *playbackServer) Play(ctx context.Context, item *pb.Path) (*pb.Duration, error) {
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
		s.is_playing = false
		speaker.Clear()
	}

	// resampling the audio for perfect amount of sample rate for individual
	// audio file
	resampled := beep.Resample(SAMPLE_QUALITY, format.SampleRate, defaultFormat.SampleRate, streamer)

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
		s.is_playing = false
	})))
	s.is_playing = true

	return &pb.Duration{
		Milliseconds: format.SampleRate.D(streamer.Len()).Round(time.Second).Milliseconds(),
	}, nil
}

func (s *playbackServer) Pause(ctx context.Context, in *pb.Empty) (*pb.Empty, error) {
	speaker.Lock()
	s.ctrl.Paused = true
	s.is_playing = false
	speaker.Unlock()
	return &pb.Empty{}, nil
}

func (s *playbackServer) Resume(ctx context.Context, in *pb.Empty) (*pb.Empty, error) {
	speaker.Lock()
	s.ctrl.Paused = false
	s.is_playing = true
	speaker.Unlock()
	return &pb.Empty{}, nil
}

func (s *playbackServer) Stop(ctx context.Context, in *pb.Empty) (*pb.Empty, error) {
	s.volume.Streamer = nil
	s.is_playing = false
	speaker.Clear()
	return &pb.Empty{}, nil
}

func (s *playbackServer) TogglePlayback(ctx context.Context, in *pb.Empty) (*pb.Empty, error) {
	speaker.Lock()
	if s.is_playing {
		s.ctrl.Paused = true
		s.is_playing = false
	} else {
		s.ctrl.Paused = false
		s.is_playing = true
	}
	speaker.Unlock()
	return &pb.Empty{}, nil
}

func (s *playbackServer) GetVolume(ctx context.Context, in *pb.Empty) (*pb.Volume, error) {
	if s.volume == nil {
		return nil, errors.New("player isn't ready yet")
	}
	// converting from floating to percantage
	return &pb.Volume{Volume: s.volume.Volume * 100}, nil
}

func (s *playbackServer) SetVolume(ctx context.Context, in *pb.Volume) (*pb.Empty, error) {
	if s.volume == nil {
		return nil, errors.New("player isn't ready yet")
	}
	speaker.Lock()
	// converting from percentage to floating
	s.volume.Volume = in.GetVolume() / 100
	speaker.Unlock()
	return &pb.Empty{}, nil
}

func (s *playbackServer) GetSpeed(ctx context.Context, in *pb.Empty) (*pb.Speed, error) {
	if s.speed == nil {
		return nil, errors.New("player isn't ready yet")
	}
	// converting from floating to percantage
	return &pb.Speed{Speed: s.speed.Ratio() * 100}, nil
}

func (s *playbackServer) SetSpeed(ctx context.Context, in *pb.Speed) (*pb.Empty, error) {
	if s.speed == nil {
		return nil, errors.New("player isn't ready yet")
	}
	speaker.Lock()
	// converting from percentage to floating
	s.speed.SetRatio(in.GetSpeed() / 100)
	speaker.Unlock()
	return &pb.Empty{}, nil
}

var defaultFormat beep.Format = beep.Format{SampleRate: 44100, NumChannels: 2, Precision: 2}

func main() {
	listener, err := net.Listen("tcp", fmt.Sprintf("localhost:%d", port))

	if err != nil {
		log.Fatalf("failed to listen: %v", err)
	}

	grpcServer := grpc.NewServer()

	playbackServerInstance := &playbackServer{is_playing: false}
	pb.RegisterPlaybackServer(grpcServer, playbackServerInstance)
	reflection.Register(grpcServer)
	log.Printf("Started server at: %v", listener.Addr())
	speaker.Init(
		defaultFormat.SampleRate,
		defaultFormat.SampleRate.N(time.Second/10),
	)
	error := grpcServer.Serve(listener)
	if error == nil {
		log.Fatalf("failed to start server: %v", error)

	}
}
