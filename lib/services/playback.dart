import 'dart:async';
import 'dart:io';

import 'package:fixnum/fixnum.dart' show Int64;
import 'package:grpc/grpc.dart';
import 'package:rowdy/proto/playback.pbgrpc.dart' hide Duration;
import 'package:rowdy/proto/playback.pbgrpc.dart' as playback;

class PlaybackService {
  late final PlaybackClient channel;
  final StreamController<Duration> _positionStreamController;
  late Timer _positionPollTimer;
  PlaybackService() : _positionStreamController = StreamController<Duration>() {
    channel = PlaybackClient(ClientChannel(
      "localhost",
      port: 50051,
      options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
    ));

    _positionPollTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) async {
        if (_positionStreamController.isClosed) return timer.cancel();
        final fetchedDuration = await channel.getPosition(Empty());
        _positionStreamController.sink.add(
          Duration(milliseconds: fetchedDuration.milliseconds.toInt()),
        );
      },
    );
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
      milliseconds: response.milliseconds.toInt(),
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

  Future<void> seek(Duration position) async {
    await channel
        .seek(playback.Duration(milliseconds: Int64(position.inMilliseconds)));
  }

  Stream<Duration> getPositionStream() {
    return channel.getPositionStream(Empty()).map((duration) {
      return Duration(milliseconds: duration.milliseconds.toInt());
    });
  }

  Stream<Duration> getPolledPositionStream() {
    return _positionStreamController.stream;
  }

  void dispose() {
    _positionStreamController.close();
    _positionPollTimer.cancel();
  }
}
