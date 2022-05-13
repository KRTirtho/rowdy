import 'dart:async';
import 'dart:ffi';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:flutter/services.dart';
import 'package:rowdy/generated/rowdy_bindings.dart';
export 'package:rowdy/services/playback.dart';

class Rowdy {
  static const MethodChannel _channel = MethodChannel('rowdy');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static void initRPC() async {
    final dylibPath = path.join(
      Directory.current.path,
      "..",
      "rowdy_beep/build/rowdy_beep.a",
    );
    final dylib = DynamicLibrary.open(dylibPath);
    GoBeep(dylib).InitRPC();
  }
}
