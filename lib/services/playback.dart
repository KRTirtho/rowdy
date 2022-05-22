import 'dart:io';

import 'package:grpc/grpc.dart';
import 'package:rowdy/proto/playback.pbgrpc.dart';

class PlaybackService {
  late final PlaybackClient channel;
  PlaybackService() {
    channel = PlaybackClient(ClientChannel(
      "localhost",
      port: 50051,
      options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
    ));
  }

  Future<String> getHello() async {
    try {
      return (await channel.getHello(Empty())).msg;
    } on Exception catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<Duration> play(String path) async {
    final response = await channel.play(
      Path(cwd: Directory.current.path, path: path, isAbsolute: true),
    );
    return Duration(
      milliseconds: response.milliseconds,
    );
  }

  Future<void> pause() async {
    await channel.pause(Empty());
  }

  Future<void> resume() async {
    await channel.resume(Empty());
  }

  Future<void> stop() async {
    await channel.stop(Empty());
  }

  Future<void> togglePlayback() async {
    await channel.togglePlayback(Empty());
  }

  Future<double> getVolume() async {
    return (await channel.getVolume(Empty())).volume;
  }

  Future<void> setVolume(double volume) async {
    await channel.setVolume(Volume(volume: volume));
  }

  Future<double> getSpeed() async {
    return (await channel.getSpeed(Empty())).speed;
  }

  Future<void> setSpeed(double speed) async {
    await channel.setSpeed(Speed(speed: speed));
  }
}
