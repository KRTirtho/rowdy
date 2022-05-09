import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'ffi.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool playerInitialized = false;
  late Stream<Float64List> progress;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    api.initPlayer().then((_) {
      setState(() => playerInitialized = true);
      progress = api.progressStream();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.play_arrow_rounded),
              onPressed: playerInitialized
                  ? () async {
                      await api.play(path: "audio/malibu.mp3");
                      setState(() {
                        isPlaying = true;
                      });
                    }
                  : null,
            ),
            if (playerInitialized && isPlaying)
              StreamBuilder<Float64List>(
                  stream: progress,
                  builder: (context, snapshot) {
                    return Text("Progress: ${snapshot.data}");
                  })
          ],
        ),
      ),
    );
  }
}
