import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:rowdy/rowdy.dart';

void main() {
  // Rowdy.initialize();
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
  late Duration duration = Duration.zero;
  late Duration position = Duration.zero;
  bool changing = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    playback = PlaybackService();
    playback.getVolume().then((value) {
      volume = value;
    });
    playback.getPolledPositionStream().listen(
      (value) {
        if (value != Duration.zero && !changing) {
          setState(() {
            position = value;
          });
        }
      },
    );
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
  void dispose() {
    playback.dispose();
    super.dispose();
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
                final fetchedDuration =
                    await playback.play("/home/krtirtho/Music/malibu.flac");
                setState(() {
                  duration = fetchedDuration;
                });
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
            Slider(
              value: position.inSeconds.toDouble(),
              max:
                  duration.inSeconds == 0 ? 100 : duration.inSeconds.toDouble(),
              min: 0,
              onChanged: (value) => setState(() {
                setState(() {
                  changing = true;
                });
                position = Duration(seconds: value.toInt());
              }),
              onChangeEnd: (position) {
                playback.seek(Duration(seconds: position.round()));
                setState(() {
                  changing = false;
                });
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
                print("OnChange End");
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
