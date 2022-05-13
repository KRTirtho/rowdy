package main

/*
#include <myapi.h>

void InitRPC(void *v);
*/

import (
	"C"
	"fmt"
	"log"
	"net"
	"time"

	player "github.com/KRTirtho/rowdy/rowdy_beep/playback"
	pb "github.com/KRTirtho/rowdy/rowdy_beep/proto"
	"github.com/faiface/beep/speaker"
	"google.golang.org/grpc"
	"google.golang.org/grpc/reflection"
)

const port int = 50551

//export InitRPC
func InitRPC() {
	listener, err := net.Listen("tcp", fmt.Sprintf("localhost:%d", port))

	if err != nil {
		log.Fatalf("failed to listen: %v", err)
	}

	grpcServer := grpc.NewServer()

	playbackServerInstance := &player.PlaybackServer{IsPlaying: false}
	pb.RegisterPlaybackServer(grpcServer, playbackServerInstance)
	reflection.Register(grpcServer)
	log.Printf("Started server at: %v", listener.Addr())
	speaker.Init(
		player.DefaultFormat.SampleRate,
		player.DefaultFormat.SampleRate.N(time.Second/10),
	)
	error := grpcServer.Serve(listener)
	if error == nil {
		log.Fatalf("failed to start server: %v", error)

	}
}

func main() {}
