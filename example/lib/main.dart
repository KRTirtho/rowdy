import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:rowdy/rowdy.dart';

void main() {
  Rowdy.initialize();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  late PlaybackService playback;
  double volume = 0;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    playback = PlaybackService();
    playback.getVolume().then((value) {
      volume = value;
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await Rowdy.platformVersion ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.play_circle_outline_rounded),
              onPressed: () async {
                print("DURATION: ${await playback.play("audio/malibu.mp3")}");
              },
            ),
            IconButton(
              icon: const Icon(Icons.pause),
              onPressed: () async {
                await playback.pause();
              },
            ),
            IconButton(
              icon: const Icon(Icons.play_arrow_rounded),
              onPressed: () async {
                await playback.resume();
              },
            ),
            IconButton(
              icon: const Icon(Icons.stop_rounded),
              onPressed: () async {
                await playback.stop();
              },
            ),
            IconButton(
              icon: const Icon(Icons.legend_toggle_rounded),
              onPressed: () async {
                await playback.togglePlayback();
              },
            ),
            StreamBuilder<Duration>(
              stream: playback.positionStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) throw snapshot.error as Exception;
                return Text("Elapsed time: ${snapshot.data}");
              },
            ),
            Slider(
              value: volume,
              max: 100,
              min: 0,
              onChanged: (value) {
                setState(() {
                  volume = value;
                });
              },
              onChangeEnd: (value) {
                // setting volume in percentage
                setState(() {
                  playback.setVolume(value).then((_) {
                    volume = value;
                  });
                });
              },
            )
          ],
        ),
      ),
    );
  }
}
