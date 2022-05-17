import 'dart:async';

import 'package:flutter/services.dart';
import 'package:rowdy/ffi.dart';

late RusteeRowdy api;

class Rowdy {
  static const MethodChannel _channel = MethodChannel('rowdy');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static initialize() {
    api = loadDylib();
  }

  Future<String> hello() {
    return api.hello();
  }
}
