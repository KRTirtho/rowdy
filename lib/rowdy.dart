import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';
import 'package:rowdy/ffi.dart';
export 'package:rowdy/services/playback.dart';

late RusteeRowdy api;

class Rowdy {
  static const MethodChannel _channel = MethodChannel('rowdy');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static initialize() async {
    try {
      api = loadDylib();
      await api.initAudioServer();
    } on FfiException catch (e) {
      if (e.code == "RESULT_ERROR") return;
      print("[Rowdy] [Initialization Error] $e");
    }
  }

  Future<String> hello() {
    return api.hello();
  }
}
