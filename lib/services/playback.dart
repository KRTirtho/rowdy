import 'dart:async';
import 'dart:io';

import 'package:fixnum/fixnum.dart' show Int64;
import 'package:grpc/grpc.dart';
import 'package:rowdy/proto/playback.pbgrpc.dart' hide Duration;
import 'package:rowdy/proto/playback.pbgrpc.dart' as playback;

class PlaybackService {
  late final PlaybackClient channel;

  // Distributed Server Stream Controllers
  final StreamController<Duration> _positionStreamController;
  final StreamController<Duration> _durationStreamController;
  final StreamController<Speed> _speedStreamController;
  final StreamController<ServerPlaybackEvent> _playbackStreamController;
  final StreamController<Volume> _volumeStreamController;

  late Timer _positionPollTimer;
  late StreamSubscription<ServerEvent> _serverEventSubscription;

  PlaybackService()
      : _positionStreamController = StreamController<Duration>(),
        _durationStreamController = StreamController<Duration>(),
        _speedStreamController = StreamController<Speed>(),
        _playbackStreamController = StreamController<ServerPlaybackEvent>(),
        _volumeStreamController = StreamController<Volume>() {
    channel = PlaybackClient(ClientChannel(
      "localhost",
      port: 50051,
      options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
    ));

    print("Subscribing To Server Stream");
    final serverEvents = channel.subscribeEvents(Empty());
    _serverEventSubscription = serverEvents.listen(
      (value) {
        print(value.name.name);
        switch (value.name) {
          case ServerEventName.DURATION:
            _durationStreamController.sink.add(
              Duration(
                milliseconds: value.durationData.milliseconds.toInt(),
              ),
            );
            break;
          case ServerEventName.PLAYBACK:
            _playbackStreamController.sink.add(value.playbackData);
            break;
          case ServerEventName.SPEED:
            _speedStreamController.sink.add(value.speedData);
            break;
          case ServerEventName.VOLUME:
            _volumeStreamController.sink.add(value.volumeData);
            break;
          default:
        }
      },
      onDone: () => print("Done Listening to Stream"),
      onError: (error) => print("There's an error $error"),
    );

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
    return _positionStreamController.stream;
  }

  void dispose() {
    _positionStreamController.close();
    _durationStreamController.close();
    _speedStreamController.close();
    _playbackStreamController.close();
    _volumeStreamController.close();
    _serverEventSubscription.cancel();
    _positionPollTimer.cancel();
  }
}
