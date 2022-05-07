
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/services.dart';

class Nakiri {
  static const MethodChannel _channel = MethodChannel('nakiri'); /// 通道名，需和iOS、android端保持一致

  static const EventChannel eventChannel = EventChannel("flutter_plugin_event_nakiri"); /// 定义一个渠道事件监听；名字需要唯一且各端保持一致

  static const BasicMessageChannel basicMessageChannel = BasicMessageChannel("flutter_plugin_basic_nakiri", StandardMessageCodec()); /// 定义一个渠道事件监听；名字需要唯一且各端保持一致

  static int number = 1;

  /// 当需要原生调用Flutter方法时，请先调用下初始化方法来增加监听
  static void init() {
    /// 设置原生调用Flutter时的回调
    _channel.setMethodCallHandler((call) async {
      switch(call.method) {
        case "updateNumber":
          return _updateNumber(call.arguments); /// 把结果返回给原生端

        default:
          break;
      }
    });

    /// 设置原生发送消息给Flutter时的回调
    basicMessageChannel.setMessageHandler((message) async {
      return message; /// 收到消息后，可以通过return把值回复给原生
    });
  }

  /// 默认实现
  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  /// 实现iOS端新增的方法
  static Future<String> stateString() async {
    final String state = await _channel.invokeMethod('stateString');
    return state;
  }

  /// 实现iOS端新增的方法
  static Future<int> add([int a = 5, int b = 8]) async {
    final int result = await _channel.invokeMethod('bonusPoints', [a, b]); /// 接收一个数组或者字典作为参数传递给原生端
    return result;
  }

  /// 实现iOS端新增的方法，测试原生数据类型
  static Future<void> testType() async {
    const _bool = true;
    const _int = 32;
    const _double = 100.5;
    const _string = 'text';

    final _uint8List = Uint8List.fromList([1, 2]);
    final _uint32List = Uint32List.fromList([3, 4]);
    final _uint64List = Uint64List.fromList([5, 6]);
    final _float32List = Float32List.fromList([1.5, 2.5]);
    final _float64List = Float64List.fromList([3.5, 4.5]);

    final _list = [];
    _list.add("list");
    _list.add(777);

    final _map = {};
    _map["nakiri"] = "ayame";

    final arg = {};
    arg["bool"] = _bool;
    arg["int"] = _int;
    arg["double"] = _double;
    arg["string"] = _string;
    arg["uint8List"] = _uint8List;
    arg["uint32List"] = _uint32List;
    arg["uint64List"] = _uint64List;
    arg["float32List"] = _float32List;
    arg["float64List"] = _float64List;
    arg["list"] = _list;
    arg["map"] = _map;
    arg["null"] = null;

    await _channel.invokeMethod('testType', arg);
  }

  /// 测试原生调用Flutter方法
  static Future<int> testAdd([int a = 3]) async {
    final int result = await _channel.invokeMethod('testAdd', a); /// 直接传递一个值给原生端
    return result;
  }

  /// 测试原生发送消息给Flutter
  static Future<int> sender([int a = 8]) async {
    final int result = await _channel.invokeMethod('basic', a); /// 直接传递一个值给原生端
    return result;
  }

  /// 实现原生调用Flutter方法
  static int _updateNumber(int value) {
    return number + value;
  }
}
