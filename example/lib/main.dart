import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:nakiri/nakiri.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  String _stateString = 'Unknown';
  int _add = -2;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String platformVersion;
    String stateString;
    int add;

    try {
      platformVersion = await Nakiri.platformVersion ?? 'Unknown platform version';
      stateString = await Nakiri.stateString();
      add = await Nakiri.add();

      await Nakiri.testType();
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
      stateString = 'Failed to get stateString';
      add = -1;
    }

    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
      _stateString = stateString;
      _add = add;
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text('Running on: $_platformVersion\n'),
            ),
            Center(
              child: Text('Network is: $_stateString\n'),
            ),
            Center(
              child: Text('Bonus points is: $_add\n'),
            ),
          ],
        ),
      ),
    );
  }
}
