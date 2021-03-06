///
//  Generated code. Do not modify.
//  source: proto/playback.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'playback.pbenum.dart';

export 'playback.pbenum.dart';

class Empty extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Empty', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'playback'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  Empty._() : super();
  factory Empty() => create();
  factory Empty.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Empty.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Empty clone() => Empty()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Empty copyWith(void Function(Empty) updates) => super.copyWith((message) => updates(message as Empty)) as Empty; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Empty create() => Empty._();
  Empty createEmptyInstance() => create();
  static $pb.PbList<Empty> createRepeated() => $pb.PbList<Empty>();
  @$core.pragma('dart2js:noInline')
  static Empty getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Empty>(create);
  static Empty? _defaultInstance;
}

class Msg extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Msg', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'playback'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'msg')
    ..hasRequiredFields = false
  ;

  Msg._() : super();
  factory Msg({
    $core.String? msg,
  }) {
    final _result = create();
    if (msg != null) {
      _result.msg = msg;
    }
    return _result;
  }
  factory Msg.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Msg.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Msg clone() => Msg()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Msg copyWith(void Function(Msg) updates) => super.copyWith((message) => updates(message as Msg)) as Msg; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Msg create() => Msg._();
  Msg createEmptyInstance() => create();
  static $pb.PbList<Msg> createRepeated() => $pb.PbList<Msg>();
  @$core.pragma('dart2js:noInline')
  static Msg getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Msg>(create);
  static Msg? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get msg => $_getSZ(0);
  @$pb.TagNumber(1)
  set msg($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasMsg() => $_has(0);
  @$pb.TagNumber(1)
  void clearMsg() => clearField(1);
}

class Volume extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Volume', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'playback'), createEmptyInstance: create)
    ..a<$core.double>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'volume', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  Volume._() : super();
  factory Volume({
    $core.double? volume,
  }) {
    final _result = create();
    if (volume != null) {
      _result.volume = volume;
    }
    return _result;
  }
  factory Volume.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Volume.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Volume clone() => Volume()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Volume copyWith(void Function(Volume) updates) => super.copyWith((message) => updates(message as Volume)) as Volume; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Volume create() => Volume._();
  Volume createEmptyInstance() => create();
  static $pb.PbList<Volume> createRepeated() => $pb.PbList<Volume>();
  @$core.pragma('dart2js:noInline')
  static Volume getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Volume>(create);
  static Volume? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get volume => $_getN(0);
  @$pb.TagNumber(1)
  set volume($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasVolume() => $_has(0);
  @$pb.TagNumber(1)
  void clearVolume() => clearField(1);
}

class Duration extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Duration', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'playback'), createEmptyInstance: create)
    ..aInt64(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'milliseconds')
    ..hasRequiredFields = false
  ;

  Duration._() : super();
  factory Duration({
    $fixnum.Int64? milliseconds,
  }) {
    final _result = create();
    if (milliseconds != null) {
      _result.milliseconds = milliseconds;
    }
    return _result;
  }
  factory Duration.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Duration.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Duration clone() => Duration()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Duration copyWith(void Function(Duration) updates) => super.copyWith((message) => updates(message as Duration)) as Duration; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Duration create() => Duration._();
  Duration createEmptyInstance() => create();
  static $pb.PbList<Duration> createRepeated() => $pb.PbList<Duration>();
  @$core.pragma('dart2js:noInline')
  static Duration getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Duration>(create);
  static Duration? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get milliseconds => $_getI64(0);
  @$pb.TagNumber(1)
  set milliseconds($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasMilliseconds() => $_has(0);
  @$pb.TagNumber(1)
  void clearMilliseconds() => clearField(1);
}

class Speed extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Speed', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'playback'), createEmptyInstance: create)
    ..a<$core.double>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'speed', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  Speed._() : super();
  factory Speed({
    $core.double? speed,
  }) {
    final _result = create();
    if (speed != null) {
      _result.speed = speed;
    }
    return _result;
  }
  factory Speed.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Speed.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Speed clone() => Speed()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Speed copyWith(void Function(Speed) updates) => super.copyWith((message) => updates(message as Speed)) as Speed; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Speed create() => Speed._();
  Speed createEmptyInstance() => create();
  static $pb.PbList<Speed> createRepeated() => $pb.PbList<Speed>();
  @$core.pragma('dart2js:noInline')
  static Speed getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Speed>(create);
  static Speed? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get speed => $_getN(0);
  @$pb.TagNumber(1)
  set speed($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSpeed() => $_has(0);
  @$pb.TagNumber(1)
  void clearSpeed() => clearField(1);
}

class Path extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Path', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'playback'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'path')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'cwd')
    ..aOB(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'isAbsolute', protoName: 'isAbsolute')
    ..hasRequiredFields = false
  ;

  Path._() : super();
  factory Path({
    $core.String? path,
    $core.String? cwd,
    $core.bool? isAbsolute,
  }) {
    final _result = create();
    if (path != null) {
      _result.path = path;
    }
    if (cwd != null) {
      _result.cwd = cwd;
    }
    if (isAbsolute != null) {
      _result.isAbsolute = isAbsolute;
    }
    return _result;
  }
  factory Path.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Path.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Path clone() => Path()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Path copyWith(void Function(Path) updates) => super.copyWith((message) => updates(message as Path)) as Path; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Path create() => Path._();
  Path createEmptyInstance() => create();
  static $pb.PbList<Path> createRepeated() => $pb.PbList<Path>();
  @$core.pragma('dart2js:noInline')
  static Path getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Path>(create);
  static Path? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get path => $_getSZ(0);
  @$pb.TagNumber(1)
  set path($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPath() => $_has(0);
  @$pb.TagNumber(1)
  void clearPath() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get cwd => $_getSZ(1);
  @$pb.TagNumber(2)
  set cwd($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasCwd() => $_has(1);
  @$pb.TagNumber(2)
  void clearCwd() => clearField(2);

  @$pb.TagNumber(3)
  $core.bool get isAbsolute => $_getBF(2);
  @$pb.TagNumber(3)
  set isAbsolute($core.bool v) { $_setBool(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasIsAbsolute() => $_has(2);
  @$pb.TagNumber(3)
  void clearIsAbsolute() => clearField(3);
}

enum ServerEvent_Eventtype {
  durationData, 
  speedData, 
  playbackData, 
  volumeData, 
  notSet
}

class ServerEvent extends $pb.GeneratedMessage {
  static const $core.Map<$core.int, ServerEvent_Eventtype> _ServerEvent_EventtypeByTag = {
    2 : ServerEvent_Eventtype.durationData,
    3 : ServerEvent_Eventtype.speedData,
    4 : ServerEvent_Eventtype.playbackData,
    5 : ServerEvent_Eventtype.volumeData,
    0 : ServerEvent_Eventtype.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ServerEvent', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'playback'), createEmptyInstance: create)
    ..oo(0, [2, 3, 4, 5])
    ..e<ServerEventName>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'name', $pb.PbFieldType.OE, defaultOrMaker: ServerEventName.DURATION, valueOf: ServerEventName.valueOf, enumValues: ServerEventName.values)
    ..aOM<Duration>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'durationData', protoName: 'durationData', subBuilder: Duration.create)
    ..aOM<Speed>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'speedData', protoName: 'speedData', subBuilder: Speed.create)
    ..aOM<ServerPlaybackEvent>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'playbackData', protoName: 'playbackData', subBuilder: ServerPlaybackEvent.create)
    ..aOM<Volume>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'volumeData', protoName: 'volumeData', subBuilder: Volume.create)
    ..hasRequiredFields = false
  ;

  ServerEvent._() : super();
  factory ServerEvent({
    ServerEventName? name,
    Duration? durationData,
    Speed? speedData,
    ServerPlaybackEvent? playbackData,
    Volume? volumeData,
  }) {
    final _result = create();
    if (name != null) {
      _result.name = name;
    }
    if (durationData != null) {
      _result.durationData = durationData;
    }
    if (speedData != null) {
      _result.speedData = speedData;
    }
    if (playbackData != null) {
      _result.playbackData = playbackData;
    }
    if (volumeData != null) {
      _result.volumeData = volumeData;
    }
    return _result;
  }
  factory ServerEvent.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ServerEvent.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ServerEvent clone() => ServerEvent()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ServerEvent copyWith(void Function(ServerEvent) updates) => super.copyWith((message) => updates(message as ServerEvent)) as ServerEvent; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ServerEvent create() => ServerEvent._();
  ServerEvent createEmptyInstance() => create();
  static $pb.PbList<ServerEvent> createRepeated() => $pb.PbList<ServerEvent>();
  @$core.pragma('dart2js:noInline')
  static ServerEvent getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ServerEvent>(create);
  static ServerEvent? _defaultInstance;

  ServerEvent_Eventtype whichEventtype() => _ServerEvent_EventtypeByTag[$_whichOneof(0)]!;
  void clearEventtype() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  ServerEventName get name => $_getN(0);
  @$pb.TagNumber(1)
  set name(ServerEventName v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => clearField(1);

  @$pb.TagNumber(2)
  Duration get durationData => $_getN(1);
  @$pb.TagNumber(2)
  set durationData(Duration v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasDurationData() => $_has(1);
  @$pb.TagNumber(2)
  void clearDurationData() => clearField(2);
  @$pb.TagNumber(2)
  Duration ensureDurationData() => $_ensure(1);

  @$pb.TagNumber(3)
  Speed get speedData => $_getN(2);
  @$pb.TagNumber(3)
  set speedData(Speed v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasSpeedData() => $_has(2);
  @$pb.TagNumber(3)
  void clearSpeedData() => clearField(3);
  @$pb.TagNumber(3)
  Speed ensureSpeedData() => $_ensure(2);

  @$pb.TagNumber(4)
  ServerPlaybackEvent get playbackData => $_getN(3);
  @$pb.TagNumber(4)
  set playbackData(ServerPlaybackEvent v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasPlaybackData() => $_has(3);
  @$pb.TagNumber(4)
  void clearPlaybackData() => clearField(4);
  @$pb.TagNumber(4)
  ServerPlaybackEvent ensurePlaybackData() => $_ensure(3);

  @$pb.TagNumber(5)
  Volume get volumeData => $_getN(4);
  @$pb.TagNumber(5)
  set volumeData(Volume v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasVolumeData() => $_has(4);
  @$pb.TagNumber(5)
  void clearVolumeData() => clearField(5);
  @$pb.TagNumber(5)
  Volume ensureVolumeData() => $_ensure(4);
}

class ServerPlaybackEvent extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ServerPlaybackEvent', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'playback'), createEmptyInstance: create)
    ..e<PlaybackEventPlayerState>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'playbackEventType', $pb.PbFieldType.OE, protoName: 'playbackEventType', defaultOrMaker: PlaybackEventPlayerState.PAUSED, valueOf: PlaybackEventPlayerState.valueOf, enumValues: PlaybackEventPlayerState.values)
    ..hasRequiredFields = false
  ;

  ServerPlaybackEvent._() : super();
  factory ServerPlaybackEvent({
    PlaybackEventPlayerState? playbackEventType,
  }) {
    final _result = create();
    if (playbackEventType != null) {
      _result.playbackEventType = playbackEventType;
    }
    return _result;
  }
  factory ServerPlaybackEvent.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ServerPlaybackEvent.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ServerPlaybackEvent clone() => ServerPlaybackEvent()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ServerPlaybackEvent copyWith(void Function(ServerPlaybackEvent) updates) => super.copyWith((message) => updates(message as ServerPlaybackEvent)) as ServerPlaybackEvent; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ServerPlaybackEvent create() => ServerPlaybackEvent._();
  ServerPlaybackEvent createEmptyInstance() => create();
  static $pb.PbList<ServerPlaybackEvent> createRepeated() => $pb.PbList<ServerPlaybackEvent>();
  @$core.pragma('dart2js:noInline')
  static ServerPlaybackEvent getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ServerPlaybackEvent>(create);
  static ServerPlaybackEvent? _defaultInstance;

  @$pb.TagNumber(1)
  PlaybackEventPlayerState get playbackEventType => $_getN(0);
  @$pb.TagNumber(1)
  set playbackEventType(PlaybackEventPlayerState v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasPlaybackEventType() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlaybackEventType() => clearField(1);
}

