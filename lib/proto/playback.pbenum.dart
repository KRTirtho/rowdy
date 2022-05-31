///
//  Generated code. Do not modify.
//  source: proto/playback.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

// ignore_for_file: UNDEFINED_SHOWN_NAME
import 'dart:core' as $core;
import 'package:protobuf/protobuf.dart' as $pb;

class ServerEventName extends $pb.ProtobufEnum {
  static const ServerEventName DURATION = ServerEventName._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'DURATION');
  static const ServerEventName PLAYBACK = ServerEventName._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'PLAYBACK');
  static const ServerEventName VOLUME = ServerEventName._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'VOLUME');
  static const ServerEventName SPEED = ServerEventName._(3, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'SPEED');

  static const $core.List<ServerEventName> values = <ServerEventName> [
    DURATION,
    PLAYBACK,
    VOLUME,
    SPEED,
  ];

  static final $core.Map<$core.int, ServerEventName> _byValue = $pb.ProtobufEnum.initByValue(values);
  static ServerEventName? valueOf($core.int value) => _byValue[value];

  const ServerEventName._($core.int v, $core.String n) : super(v, n);
}

class PlaybackEventPlayerState extends $pb.ProtobufEnum {
  static const PlaybackEventPlayerState PAUSED = PlaybackEventPlayerState._(0, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'PAUSED');
  static const PlaybackEventPlayerState CHANGED = PlaybackEventPlayerState._(1, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'CHANGED');
  static const PlaybackEventPlayerState RESUMED = PlaybackEventPlayerState._(2, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'RESUMED');
  static const PlaybackEventPlayerState STOPPED = PlaybackEventPlayerState._(3, const $core.bool.fromEnvironment('protobuf.omit_enum_names') ? '' : 'STOPPED');

  static const $core.List<PlaybackEventPlayerState> values = <PlaybackEventPlayerState> [
    PAUSED,
    CHANGED,
    RESUMED,
    STOPPED,
  ];

  static final $core.Map<$core.int, PlaybackEventPlayerState> _byValue = $pb.ProtobufEnum.initByValue(values);
  static PlaybackEventPlayerState? valueOf($core.int value) => _byValue[value];

  const PlaybackEventPlayerState._($core.int v, $core.String n) : super(v, n);
}

