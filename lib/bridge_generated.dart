// AUTO GENERATED FILE, DO NOT EDIT.
// Generated by `flutter_rust_bridge`.

// ignore_for_file: non_constant_identifier_names, unused_element, duplicate_ignore, directives_ordering, curly_braces_in_flow_control_structures, unnecessary_lambdas, slash_for_doc_comments, prefer_const_literals_to_create_immutables, implicit_dynamic_list_literal, duplicate_import, unused_import, prefer_single_quotes, prefer_const_constructors

import 'dart:convert';
import 'dart:typed_data';

import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_rust_bridge/flutter_rust_bridge.dart';
import 'dart:ffi' as ffi;

abstract class RusteeRowdy {
  Future<String> hello({dynamic hint});

  Future<void> initAudioServer({dynamic hint});
}

class RusteeRowdyImpl extends FlutterRustBridgeBase<RusteeRowdyWire>
    implements RusteeRowdy {
  factory RusteeRowdyImpl(ffi.DynamicLibrary dylib) =>
      RusteeRowdyImpl.raw(RusteeRowdyWire(dylib));

  RusteeRowdyImpl.raw(RusteeRowdyWire inner) : super(inner);

  Future<String> hello({dynamic hint}) => executeNormal(FlutterRustBridgeTask(
        callFfi: (port_) => inner.wire_hello(port_),
        parseSuccessData: _wire2api_String,
        constMeta: const FlutterRustBridgeTaskConstMeta(
          debugName: "hello",
          argNames: [],
        ),
        argValues: [],
        hint: hint,
      ));

  Future<void> initAudioServer({dynamic hint}) =>
      executeNormal(FlutterRustBridgeTask(
        callFfi: (port_) => inner.wire_init_audio_server(port_),
        parseSuccessData: _wire2api_unit,
        constMeta: const FlutterRustBridgeTaskConstMeta(
          debugName: "init_audio_server",
          argNames: [],
        ),
        argValues: [],
        hint: hint,
      ));

  // Section: api2wire

  // Section: api_fill_to_wire

}

// Section: wire2api
String _wire2api_String(dynamic raw) {
  return raw as String;
}

int _wire2api_u8(dynamic raw) {
  return raw as int;
}

Uint8List _wire2api_uint_8_list(dynamic raw) {
  return raw as Uint8List;
}

void _wire2api_unit(dynamic raw) {
  return;
}

// ignore_for_file: camel_case_types, non_constant_identifier_names, avoid_positional_boolean_parameters, annotate_overrides, constant_identifier_names

// AUTO GENERATED FILE, DO NOT EDIT.
//
// Generated by `package:ffigen`.

/// generated by flutter_rust_bridge
class RusteeRowdyWire implements FlutterRustBridgeWireBase {
  /// Holds the symbol lookup function.
  final ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
      _lookup;

  /// The symbols are looked up in [dynamicLibrary].
  RusteeRowdyWire(ffi.DynamicLibrary dynamicLibrary)
      : _lookup = dynamicLibrary.lookup;

  /// The symbols are looked up with [lookup].
  RusteeRowdyWire.fromLookup(
      ffi.Pointer<T> Function<T extends ffi.NativeType>(String symbolName)
          lookup)
      : _lookup = lookup;

  void wire_hello(
    int port_,
  ) {
    return _wire_hello(
      port_,
    );
  }

  late final _wire_helloPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Int64)>>('wire_hello');
  late final _wire_hello = _wire_helloPtr.asFunction<void Function(int)>();

  void wire_init_audio_server(
    int port_,
  ) {
    return _wire_init_audio_server(
      port_,
    );
  }

  late final _wire_init_audio_serverPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(ffi.Int64)>>(
          'wire_init_audio_server');
  late final _wire_init_audio_server =
      _wire_init_audio_serverPtr.asFunction<void Function(int)>();

  void free_WireSyncReturnStruct(
    WireSyncReturnStruct val,
  ) {
    return _free_WireSyncReturnStruct(
      val,
    );
  }

  late final _free_WireSyncReturnStructPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(WireSyncReturnStruct)>>(
          'free_WireSyncReturnStruct');
  late final _free_WireSyncReturnStruct = _free_WireSyncReturnStructPtr
      .asFunction<void Function(WireSyncReturnStruct)>();

  void store_dart_post_cobject(
    DartPostCObjectFnType ptr,
  ) {
    return _store_dart_post_cobject(
      ptr,
    );
  }

  late final _store_dart_post_cobjectPtr =
      _lookup<ffi.NativeFunction<ffi.Void Function(DartPostCObjectFnType)>>(
          'store_dart_post_cobject');
  late final _store_dart_post_cobject = _store_dart_post_cobjectPtr
      .asFunction<void Function(DartPostCObjectFnType)>();
}

typedef DartPostCObjectFnType = ffi.Pointer<
    ffi.NativeFunction<ffi.Uint8 Function(DartPort, ffi.Pointer<ffi.Void>)>>;
typedef DartPort = ffi.Int64;
