//
//  ZTEventChannel.swift
//  nakiri
//
//  Created by Asuna on 2022/4/29.
//

import Foundation
import Flutter

class ZTEventChannel: NSObject {
    
    private var eventChannel: FlutterEventChannel?
    
    private var eventSink: FlutterEventSink?
    
    private var timer: Timer?
    
    private var number = 5
    
    override init() {
        super.init()
    }
    
    required convenience init(binaryMessenger messenger: FlutterBinaryMessenger) {
        self.init()
        eventChannel = FlutterEventChannel(name: "flutter_plugin_event_nakiri", binaryMessenger: messenger) // 通道名必须唯一且和各端保持一致
        eventChannel?.setStreamHandler(self)
    }
    
    private func removeTimer() {
        timer?.invalidate()
        timer = nil
        number = 5
    }
    
    private func createTimer() {
        if #available(iOS 10.0, *) {
            if timer == nil {
                timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { [weak self] (timer) in
                    self?.timerCall()
                })
            }
        }
    }
    
    @objc private func timerCall() {
        if let event = eventSink {
            event(number)
            
            number += 5
        }
    }
}

extension ZTEventChannel: FlutterStreamHandler {
    
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        // 在这里获取到eventSink
        self.eventSink = events
        createTimer()
        
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        // 在这里移除eventSink
        self.eventSink = nil
        removeTimer()
        
        return nil
    }
}
