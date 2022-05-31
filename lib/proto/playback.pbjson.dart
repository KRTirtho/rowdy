///
//  Generated code. Do not modify.
//  source: proto/playback.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields,deprecated_member_use_from_same_package

import 'dart:core' as $core;
import 'dart:convert' as $convert;
import 'dart:typed_data' as $typed_data;
@$core.Deprecated('Use serverEventNameDescriptor instead')
const ServerEventName$json = const {
  '1': 'ServerEventName',
  '2': const [
    const {'1': 'DURATION', '2': 0},
    const {'1': 'PLAYBACK', '2': 1},
    const {'1': 'VOLUME', '2': 2},
    const {'1': 'SPEED', '2': 3},
  ],
};

/// Descriptor for `ServerEventName`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List serverEventNameDescriptor = $convert.base64Decode('Cg9TZXJ2ZXJFdmVudE5hbWUSDAoIRFVSQVRJT04QABIMCghQTEFZQkFDSxABEgoKBlZPTFVNRRACEgkKBVNQRUVEEAM=');
@$core.Deprecated('Use playbackEventPlayerStateDescriptor instead')
const PlaybackEventPlayerState$json = const {
  '1': 'PlaybackEventPlayerState',
  '2': const [
    const {'1': 'PAUSED', '2': 0},
    const {'1': 'CHANGED', '2': 1},
    const {'1': 'RESUMED', '2': 2},
    const {'1': 'STOPPED', '2': 3},
  ],
};

/// Descriptor for `PlaybackEventPlayerState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List playbackEventPlayerStateDescriptor = $convert.base64Decode('ChhQbGF5YmFja0V2ZW50UGxheWVyU3RhdGUSCgoGUEFVU0VEEAASCwoHQ0hBTkdFRBABEgsKB1JFU1VNRUQQAhILCgdTVE9QUEVEEAM=');
@$core.Deprecated('Use emptyDescriptor instead')
const Empty$json = const {
  '1': 'Empty',
};

/// Descriptor for `Empty`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List emptyDescriptor = $convert.base64Decode('CgVFbXB0eQ==');
@$core.Deprecated('Use msgDescriptor instead')
const Msg$json = const {
  '1': 'Msg',
  '2': const [
    const {'1': 'msg', '3': 1, '4': 1, '5': 9, '10': 'msg'},
  ],
};

/// Descriptor for `Msg`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List msgDescriptor = $convert.base64Decode('CgNNc2cSEAoDbXNnGAEgASgJUgNtc2c=');
@$core.Deprecated('Use volumeDescriptor instead')
const Volume$json = const {
  '1': 'Volume',
  '2': const [
    const {'1': 'volume', '3': 1, '4': 1, '5': 1, '10': 'volume'},
  ],
};

/// Descriptor for `Volume`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List volumeDescriptor = $convert.base64Decode('CgZWb2x1bWUSFgoGdm9sdW1lGAEgASgBUgZ2b2x1bWU=');
@$core.Deprecated('Use durationDescriptor instead')
const Duration$json = const {
  '1': 'Duration',
  '2': const [
    const {'1': 'milliseconds', '3': 1, '4': 1, '5': 3, '10': 'milliseconds'},
  ],
};

/// Descriptor for `Duration`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List durationDescriptor = $convert.base64Decode('CghEdXJhdGlvbhIiCgxtaWxsaXNlY29uZHMYASABKANSDG1pbGxpc2Vjb25kcw==');
@$core.Deprecated('Use speedDescriptor instead')
const Speed$json = const {
  '1': 'Speed',
  '2': const [
    const {'1': 'speed', '3': 1, '4': 1, '5': 1, '10': 'speed'},
  ],
};

/// Descriptor for `Speed`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List speedDescriptor = $convert.base64Decode('CgVTcGVlZBIUCgVzcGVlZBgBIAEoAVIFc3BlZWQ=');
@$core.Deprecated('Use pathDescriptor instead')
const Path$json = const {
  '1': 'Path',
  '2': const [
    const {'1': 'path', '3': 1, '4': 1, '5': 9, '10': 'path'},
    const {'1': 'cwd', '3': 2, '4': 1, '5': 9, '10': 'cwd'},
    const {'1': 'isAbsolute', '3': 3, '4': 1, '5': 8, '10': 'isAbsolute'},
  ],
};

/// Descriptor for `Path`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pathDescriptor = $convert.base64Decode('CgRQYXRoEhIKBHBhdGgYASABKAlSBHBhdGgSEAoDY3dkGAIgASgJUgNjd2QSHgoKaXNBYnNvbHV0ZRgDIAEoCFIKaXNBYnNvbHV0ZQ==');
@$core.Deprecated('Use serverEventDescriptor instead')
const ServerEvent$json = const {
  '1': 'ServerEvent',
  '2': const [
    const {'1': 'name', '3': 1, '4': 1, '5': 14, '6': '.playback.ServerEventName', '10': 'name'},
    const {'1': 'durationData', '3': 2, '4': 1, '5': 11, '6': '.playback.Duration', '9': 0, '10': 'durationData'},
    const {'1': 'speedData', '3': 3, '4': 1, '5': 11, '6': '.playback.Speed', '9': 0, '10': 'speedData'},
    const {'1': 'playbackData', '3': 4, '4': 1, '5': 11, '6': '.playback.ServerPlaybackEvent', '9': 0, '10': 'playbackData'},
    const {'1': 'volumeData', '3': 5, '4': 1, '5': 11, '6': '.playback.Volume', '9': 0, '10': 'volumeData'},
  ],
  '8': const [
    const {'1': 'eventtype'},
  ],
};

/// Descriptor for `ServerEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List serverEventDescriptor = $convert.base64Decode('CgtTZXJ2ZXJFdmVudBItCgRuYW1lGAEgASgOMhkucGxheWJhY2suU2VydmVyRXZlbnROYW1lUgRuYW1lEjgKDGR1cmF0aW9uRGF0YRgCIAEoCzISLnBsYXliYWNrLkR1cmF0aW9uSABSDGR1cmF0aW9uRGF0YRIvCglzcGVlZERhdGEYAyABKAsyDy5wbGF5YmFjay5TcGVlZEgAUglzcGVlZERhdGESQwoMcGxheWJhY2tEYXRhGAQgASgLMh0ucGxheWJhY2suU2VydmVyUGxheWJhY2tFdmVudEgAUgxwbGF5YmFja0RhdGESMgoKdm9sdW1lRGF0YRgFIAEoCzIQLnBsYXliYWNrLlZvbHVtZUgAUgp2b2x1bWVEYXRhQgsKCWV2ZW50dHlwZQ==');
@$core.Deprecated('Use serverPlaybackEventDescriptor instead')
const ServerPlaybackEvent$json = const {
  '1': 'ServerPlaybackEvent',
  '2': const [
    const {'1': 'playbackEventType', '3': 1, '4': 1, '5': 14, '6': '.playback.PlaybackEventPlayerState', '10': 'playbackEventType'},
  ],
};

/// Descriptor for `ServerPlaybackEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List serverPlaybackEventDescriptor = $convert.base64Decode('ChNTZXJ2ZXJQbGF5YmFja0V2ZW50ElAKEXBsYXliYWNrRXZlbnRUeXBlGAEgASgOMiIucGxheWJhY2suUGxheWJhY2tFdmVudFBsYXllclN0YXRlUhFwbGF5YmFja0V2ZW50VHlwZQ==');
