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

  Duration position = Duration.zero;
  Duration duration = Duration.zero;
  Volume volume = Volume(volume: 100);
  ServerPlaybackEvent playbackState =
      ServerPlaybackEvent(playbackEventType: PlaybackEventPlayerState.STOPPED);
  Speed speed = Speed(speed: 1);

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

    final serverEvents = channel.subscribeEvents(Empty());
    _serverEventSubscription = serverEvents.listen(
      (value) {
        switch (value.name) {
          case ServerEventName.DURATION:
            final data = Duration(
              milliseconds: value.durationData.milliseconds.toInt(),
            );
            duration = data;
            _durationStreamController.sink.add(data);
            break;
          case ServerEventName.PLAYBACK:
            playbackState = value.playbackData;
            _playbackStreamController.sink.add(value.playbackData);
            break;
          case ServerEventName.SPEED:
            speed = value.speedData;
            _speedStreamController.sink.add(value.speedData);
            break;
          case ServerEventName.VOLUME:
            volume = value.volumeData;
            _volumeStreamController.sink.add(value.volumeData);
            break;
          default:
        }
      },
    );

    _positionPollTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) async {
        if (_positionStreamController.isClosed) return timer.cancel();
        if (!playing) return;
        final fetchedDuration = await channel.getPosition(Empty());
        _positionStreamController.sink.add(
          Duration(milliseconds: fetchedDuration.milliseconds.toInt()),
        );
      },
    );
  }

  bool get playing => [
        PlaybackEventPlayerState.CHANGED,
        PlaybackEventPlayerState.RESUMED,
      ].contains(playbackState.playbackEventType);

  Stream<Duration> get positionStream => _positionStreamController.stream;

  Stream<Duration> get durationStream => _durationStreamController.stream;

  Stream<playback.Volume> get volumeStream => _volumeStreamController.stream;

  Stream<playback.ServerPlaybackEvent> get playbackStateStream =>
      _playbackStreamController.stream;

  Stream<playback.Speed> get speedStream => _speedStreamController.stream;

  Stream<bool> get playingStream =>
      _playbackStreamController.stream.map((event) => [
            PlaybackEventPlayerState.CHANGED,
            PlaybackEventPlayerState.RESUMED,
          ].contains(event.playbackEventType));

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
