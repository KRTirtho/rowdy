import 'dart:async';

import 'package:flutter/services.dart';
export 'package:rowdy/services/playback.dart';

class Rowdy {
  static const MethodChannel _channel = MethodChannel('rowdy');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
