import Flutter
import UIKit

public class SwiftNakiriPlugin: NSObject, FlutterPlugin {

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "nakiri", binaryMessenger: registrar.messenger())
        let instance = SwiftNakiriPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if call.method == "stateString" { // 获取网络状态的实现
            result(ZTNetworkStateManager.shared.stateString)
        } else if call.method == "bonusPoints" { // 使用参数的实现
            let array = call.arguments as! Array<Int>
            result(array[0] + array[1])
        } else if call.method == "getPlatformVersion" { // 默认的实现
            result("iOS " + UIDevice.current.systemVersion)
        } else if call.method == "testType" { // 测试数据类型
            let arg = call.arguments as! Dictionary<String, Any>

            let _bool = arg["bool"]
            if _bool is Bool {
                print("_bool = \(String(describing: _bool))")
            } else {
                print("_bool = 不是bool")
            }

            let _int = arg["int"]
            if _int is Int {
                print("_int = \(String(describing: _int))")
            } else {
                print("_int = 不是int")
            }

            let _double = arg["double"]
            if _double is Double {
                print("_double = \(String(describing: _double))")
            } else {
                print("_double = 不是double")
            }

            let _string = arg["string"]
            if _string is String {
              print("_string = \(String(describing: _string))")
            } else {
              print("_string = 不是string")
            }

            let _uint8List = arg["uint8List"]
            if _uint8List is FlutterStandardTypedData {
                print("_uint8List = \(String(describing: _uint8List))")
            } else {
                print("_uint8List = 不是uint8List")
            }

            let _uint32List = arg["uint32List"]
            if _uint32List is FlutterStandardTypedData {
                print("_uint32List = \(String(describing: _uint32List))")
            } else {
                print("_uint32List = 不是uint32List")
            }

            let _uint64List = arg["uint64List"]
            if _uint64List is FlutterStandardTypedData {
                print("_uint64List = \(String(describing: _uint64List))")
            } else {
                print("_uint64List = 不是uint64List")
            }

            let _float32List = arg["float32List"]
            if _float32List is FlutterStandardTypedData {
                print("_float32List = \(String(describing: _float32List))")
            } else {
                print("_float32List = 不是float32List")
            }

            let _float64List = arg["float64List"]
            if _float64List is FlutterStandardTypedData {
                print("_float64List = \(String(describing: _float64List))")
            } else {
                print("_float64List = 不是float64List")
            }

            let _list = arg["list"]
            if _list is Array<Any> {
                print("_list = \(String(describing: _list))")
            } else {
                print("_list = 不是list")
            }

            let _map = arg["map"]
            if _map is Dictionary<String, Any> {
                print("_map = \(String(describing: _map))")
            } else {
                print("_map = 不是map")
            }

            let _null = arg["null"]
            if _null is NSNull {
                print("_null = \(String(describing: _null))")
            } else {
                print("_null = 不是null")
            }
        } else {
            // 找不到方法
            result(FlutterMethodNotImplemented)
        }
    }
}
