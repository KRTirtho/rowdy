///
//  Generated code. Do not modify.
//  source: proto/playback.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:async' as $async;

import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'playback.pb.dart' as $0;
export 'playback.pb.dart';

class PlaybackClient extends $grpc.Client {
  static final _$getHello = $grpc.ClientMethod<$0.Empty, $0.Msg>(
      '/playback.Playback/GetHello',
      ($0.Empty value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Msg.fromBuffer(value));
  static final _$play = $grpc.ClientMethod<$0.Path, $0.Duration>(
      '/playback.Playback/Play',
      ($0.Path value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Duration.fromBuffer(value));
  static final _$pause = $grpc.ClientMethod<$0.Empty, $0.Empty>(
      '/playback.Playback/Pause',
      ($0.Empty value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Empty.fromBuffer(value));
  static final _$resume = $grpc.ClientMethod<$0.Empty, $0.Empty>(
      '/playback.Playback/Resume',
      ($0.Empty value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Empty.fromBuffer(value));
  static final _$stop = $grpc.ClientMethod<$0.Empty, $0.Empty>(
      '/playback.Playback/Stop',
      ($0.Empty value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Empty.fromBuffer(value));
  static final _$togglePlayback = $grpc.ClientMethod<$0.Empty, $0.Empty>(
      '/playback.Playback/TogglePlayback',
      ($0.Empty value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Empty.fromBuffer(value));
  static final _$getVolume = $grpc.ClientMethod<$0.Empty, $0.Volume>(
      '/playback.Playback/GetVolume',
      ($0.Empty value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Volume.fromBuffer(value));
  static final _$setVolume = $grpc.ClientMethod<$0.Volume, $0.Empty>(
      '/playback.Playback/SetVolume',
      ($0.Volume value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Empty.fromBuffer(value));
  static final _$getSpeed = $grpc.ClientMethod<$0.Empty, $0.Speed>(
      '/playback.Playback/GetSpeed',
      ($0.Empty value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Speed.fromBuffer(value));
  static final _$setSpeed = $grpc.ClientMethod<$0.Speed, $0.Empty>(
      '/playback.Playback/SetSpeed',
      ($0.Speed value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Empty.fromBuffer(value));
  static final _$seek = $grpc.ClientMethod<$0.Duration, $0.Empty>(
      '/playback.Playback/Seek',
      ($0.Duration value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Empty.fromBuffer(value));
  static final _$getPosition = $grpc.ClientMethod<$0.Empty, $0.Duration>(
      '/playback.Playback/GetPosition',
      ($0.Empty value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Duration.fromBuffer(value));
  static final _$subscribeEvents = $grpc.ClientMethod<$0.Empty, $0.ServerEvent>(
      '/playback.Playback/SubscribeEvents',
      ($0.Empty value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.ServerEvent.fromBuffer(value));

  PlaybackClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseFuture<$0.Msg> getHello($0.Empty request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getHello, request, options: options);
  }

  $grpc.ResponseFuture<$0.Duration> play($0.Path request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$play, request, options: options);
  }

  $grpc.ResponseFuture<$0.Empty> pause($0.Empty request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$pause, request, options: options);
  }

  $grpc.ResponseFuture<$0.Empty> resume($0.Empty request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$resume, request, options: options);
  }

  $grpc.ResponseFuture<$0.Empty> stop($0.Empty request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$stop, request, options: options);
  }

  $grpc.ResponseFuture<$0.Empty> togglePlayback($0.Empty request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$togglePlayback, request, options: options);
  }

  $grpc.ResponseFuture<$0.Volume> getVolume($0.Empty request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getVolume, request, options: options);
  }

  $grpc.ResponseFuture<$0.Empty> setVolume($0.Volume request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$setVolume, request, options: options);
  }

  $grpc.ResponseFuture<$0.Speed> getSpeed($0.Empty request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getSpeed, request, options: options);
  }

  $grpc.ResponseFuture<$0.Empty> setSpeed($0.Speed request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$setSpeed, request, options: options);
  }

  $grpc.ResponseFuture<$0.Empty> seek($0.Duration request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$seek, request, options: options);
  }

  $grpc.ResponseFuture<$0.Duration> getPosition($0.Empty request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getPosition, request, options: options);
  }

  $grpc.ResponseStream<$0.ServerEvent> subscribeEvents($0.Empty request,
      {$grpc.CallOptions? options}) {
    return $createStreamingCall(
        _$subscribeEvents, $async.Stream.fromIterable([request]),
        options: options);
  }
}

abstract class PlaybackServiceBase extends $grpc.Service {
  $core.String get $name => 'playback.Playback';

  PlaybackServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.Empty, $0.Msg>(
        'GetHello',
        getHello_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($0.Msg value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Path, $0.Duration>(
        'Play',
        play_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Path.fromBuffer(value),
        ($0.Duration value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Empty, $0.Empty>(
        'Pause',
        pause_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Empty, $0.Empty>(
        'Resume',
        resume_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Empty, $0.Empty>(
        'Stop',
        stop_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Empty, $0.Empty>(
        'TogglePlayback',
        togglePlayback_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Empty, $0.Volume>(
        'GetVolume',
        getVolume_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($0.Volume value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Volume, $0.Empty>(
        'SetVolume',
        setVolume_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Volume.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Empty, $0.Speed>(
        'GetSpeed',
        getSpeed_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($0.Speed value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Speed, $0.Empty>(
        'SetSpeed',
        setSpeed_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Speed.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Duration, $0.Empty>(
        'Seek',
        seek_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Duration.fromBuffer(value),
        ($0.Empty value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Empty, $0.Duration>(
        'GetPosition',
        getPosition_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($0.Duration value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Empty, $0.ServerEvent>(
        'SubscribeEvents',
        subscribeEvents_Pre,
        false,
        true,
        ($core.List<$core.int> value) => $0.Empty.fromBuffer(value),
        ($0.ServerEvent value) => value.writeToBuffer()));
  }

  $async.Future<$0.Msg> getHello_Pre(
      $grpc.ServiceCall call, $async.Future<$0.Empty> request) async {
    return getHello(call, await request);
  }

  $async.Future<$0.Duration> play_Pre(
      $grpc.ServiceCall call, $async.Future<$0.Path> request) async {
    return play(call, await request);
  }

  $async.Future<$0.Empty> pause_Pre(
      $grpc.ServiceCall call, $async.Future<$0.Empty> request) async {
    return pause(call, await request);
  }

  $async.Future<$0.Empty> resume_Pre(
      $grpc.ServiceCall call, $async.Future<$0.Empty> request) async {
    return resume(call, await request);
  }

  $async.Future<$0.Empty> stop_Pre(
      $grpc.ServiceCall call, $async.Future<$0.Empty> request) async {
    return stop(call, await request);
  }

  $async.Future<$0.Empty> togglePlayback_Pre(
      $grpc.ServiceCall call, $async.Future<$0.Empty> request) async {
    return togglePlayback(call, await request);
  }

  $async.Future<$0.Volume> getVolume_Pre(
      $grpc.ServiceCall call, $async.Future<$0.Empty> request) async {
    return getVolume(call, await request);
  }

  $async.Future<$0.Empty> setVolume_Pre(
      $grpc.ServiceCall call, $async.Future<$0.Volume> request) async {
    return setVolume(call, await request);
  }

  $async.Future<$0.Speed> getSpeed_Pre(
      $grpc.ServiceCall call, $async.Future<$0.Empty> request) async {
    return getSpeed(call, await request);
  }

  $async.Future<$0.Empty> setSpeed_Pre(
      $grpc.ServiceCall call, $async.Future<$0.Speed> request) async {
    return setSpeed(call, await request);
  }

  $async.Future<$0.Empty> seek_Pre(
      $grpc.ServiceCall call, $async.Future<$0.Duration> request) async {
    return seek(call, await request);
  }

  $async.Future<$0.Duration> getPosition_Pre(
      $grpc.ServiceCall call, $async.Future<$0.Empty> request) async {
    return getPosition(call, await request);
  }

  $async.Stream<$0.ServerEvent> subscribeEvents_Pre(
      $grpc.ServiceCall call, $async.Future<$0.Empty> request) async* {
    yield* subscribeEvents(call, await request);
  }

  $async.Future<$0.Msg> getHello($grpc.ServiceCall call, $0.Empty request);
  $async.Future<$0.Duration> play($grpc.ServiceCall call, $0.Path request);
  $async.Future<$0.Empty> pause($grpc.ServiceCall call, $0.Empty request);
  $async.Future<$0.Empty> resume($grpc.ServiceCall call, $0.Empty request);
  $async.Future<$0.Empty> stop($grpc.ServiceCall call, $0.Empty request);
  $async.Future<$0.Empty> togglePlayback(
      $grpc.ServiceCall call, $0.Empty request);
  $async.Future<$0.Volume> getVolume($grpc.ServiceCall call, $0.Empty request);
  $async.Future<$0.Empty> setVolume($grpc.ServiceCall call, $0.Volume request);
  $async.Future<$0.Speed> getSpeed($grpc.ServiceCall call, $0.Empty request);
  $async.Future<$0.Empty> setSpeed($grpc.ServiceCall call, $0.Speed request);
  $async.Future<$0.Empty> seek($grpc.ServiceCall call, $0.Duration request);
  $async.Future<$0.Duration> getPosition(
      $grpc.ServiceCall call, $0.Empty request);
  $async.Stream<$0.ServerEvent> subscribeEvents(
      $grpc.ServiceCall call, $0.Empty request);
}
