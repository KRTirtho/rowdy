import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:rowdy/rowdy.dart';

void main() async {
  await Rowdy.initRPC();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  late PlaybackService playbackService;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    playbackService = PlaybackService();
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
        body: Column(
          children: [
            Center(
              child: FutureBuilder<String>(
                future: playbackService.getHello(),
                builder: (context, snapshot) {
                  return Text(
                    'From gRPC: ${snapshot.data}\nRunning on: $_platformVersion\n',
                  );
                },
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.play_arrow_rounded),
                  onPressed: () async {
                    print(await playbackService.play("../audio/malibu.mp3"));
                  },
                ),
                IconButton(
                  icon: Icon(Icons.pause_rounded),
                  onPressed: () async {
                    await playbackService.pause();
                  },
                ),
                IconButton(
                  icon: Icon(Icons.play_arrow_outlined),
                  onPressed: () async {
                    await playbackService.resume();
                  },
                ),
                IconButton(
                  icon: Icon(Icons.stop_rounded),
                  onPressed: () async {
                    await playbackService.stop();
                  },
                ),
                IconButton(
                  icon: Icon(Icons.wb_sunny_rounded),
                  onPressed: () async {
                    await playbackService.togglePlayback();
                  },
                ),
                IconButton(
                  icon: Icon(Icons.add_rounded),
                  onPressed: () async {
                    final volume = await playbackService.getVolume();
                    await playbackService.setVolume(volume + 5);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.minimize_rounded),
                  onPressed: () async {
                    final volume = await playbackService.getVolume();
                    await playbackService.setVolume(volume - 5);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.fast_forward_rounded),
                  onPressed: () async {
                    final speed = await playbackService.getSpeed();
                    await playbackService.setSpeed(speed + 5);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.fast_rewind_rounded),
                  onPressed: () async {
                    final speed = await playbackService.getSpeed();
                    await playbackService.setSpeed(speed - 5);
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
