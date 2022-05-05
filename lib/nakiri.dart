
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/services.dart';

class Nakiri {
  static const MethodChannel _channel = MethodChannel('nakiri'); /// 通道名，需和iOS、android端保持一致

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
  static Future<int> add() async {
    final int result = await _channel.invokeMethod('bonusPoints', [5, 8]); /// 接收一个数组或者字典作为参数传递给原生端
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
}
