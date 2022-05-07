import 'dart:async';

import 'package:flutter/material.dart';
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
  int _eventValue = -1;
  int _number = -3;
  int _basicNumber = -1;
  StreamSubscription? _stream;

  @override
  void initState() {
    super.initState();
    Nakiri.init();
    _initPlatformState();
    _initStream();
  }

  Future<void> _initPlatformState() async {
    String platformVersion;
    String stateString;
    int add;
    int number;

    try {
      platformVersion =
          await Nakiri.platformVersion ?? 'Unknown platform version';
      stateString = await Nakiri.stateString();
      add = await Nakiri.add();
      number = await Nakiri.testAdd();

      Nakiri.testType();
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
      stateString = 'Failed to get stateString';
      add = -1;
      number = -1;
    } catch (e) {
      platformVersion = 'Failed to get platform version.';
      stateString = 'Failed to get stateString';
      add = -1;
      number = -1;
    }

    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
      _stateString = stateString;
      _add = add;
      _number = number;
    });
  }

  _initStream() {
    /// 监听原生发来的消息
    _stream ??= Nakiri.eventChannel.receiveBroadcastStream().listen((data) {
      /// 这里的data就是原生端发送过来的数据
      setState(() {
        _eventValue = data;
      });
    }, onError: (error) { /// 错误处理
      setState(() {
        _eventValue = -5;
      });
    });
  }

  _removeStream() {
    if (_stream != null) {
      /// 移除监听
      _stream?.cancel();
      _stream = null;
    }
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
            Center(
              child: Text('Number value is: $_number\n'),
            ),
            Center(
              child: Text('Event value is: $_eventValue\n'),
            ),
            Center(
              child: Text('BasicMessage value is: $_basicNumber\n'),
            ),
          ],
        ),
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton(
              onPressed: () {
                /// 恢复数据流
                _stream?.resume();
              },
              tooltip: '恢复数据流',
              child: const Icon(Icons.play_arrow),
            ),
            const SizedBox(height: 10,),
            FloatingActionButton(
              onPressed: () {
                /// 暂停数据接收
                _stream?.pause();
              },
              tooltip: '暂停接收数据流',
              child: const Icon(Icons.pause),
            ),
            const SizedBox(height: 10,),
            FloatingActionButton(
              onPressed: () {
                _removeStream();

                setState(() {
                  _eventValue = -2;
                });
              },
              tooltip: '移除数据流监听',
              child: const Icon(Icons.restore_from_trash_outlined),
            ),
            const SizedBox(height: 10,),
            FloatingActionButton(
              onPressed: () {
                _initStream();

                setState(() {
                  _eventValue = 0;
                });
              },
              tooltip: '添加数据流监听',
              child: const Icon(Icons.add),
            ),
            const SizedBox(height: 10,),
            FloatingActionButton(
              onPressed: ()  {
                /// Flutter端给原生端发送消息（也可以用赋值的方式获取原生端回复的值）
                Nakiri.basicMessageChannel.send(_basicNumber).then((value) {
                  setState(() {
                    _basicNumber = value;
                  });
                });
              },
              tooltip: '发送数据给原生',
              child: const Icon(Icons.send),
            ),
            const SizedBox(height: 10,),
            FloatingActionButton(
              onPressed: ()  {
                /// 原生端给Flutter端发送消息（也可以用赋值的方式获取原生端回复的值）
                Nakiri.sender(_basicNumber).then((value) {
                  setState(() {
                    _basicNumber = value;
                  });
                });
              },
              tooltip: '原生发送数据给Flutter',
              child: const Icon(Icons.send_and_archive),
            ),
          ],
        ),
      ),
    );
  }
}
