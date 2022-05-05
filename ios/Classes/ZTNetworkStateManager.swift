//
//  ZTNetworkState.swift
//  XHSG
//
//  Created by Asuna on 2020/7/20.
//  Copyright © 2020 Asuna. All rights reserved.
//

import Foundation
import Alamofire

public typealias ZTNetworkStateChangeBlock = (_ state: NetworkReachabilityManager.NetworkReachabilityStatus) -> Void

public final class ZTNetworkStateManager {

    public static let shared = ZTNetworkStateManager()
    
    private let reachability: NetworkReachabilityManager? = NetworkReachabilityManager()
    
    private var dic: Dictionary<String, ZTNetworkStateChangeBlock> = Dictionary()
    
    /// 获取当前网络状态
    public var state: NetworkReachabilityManager.NetworkReachabilityStatus {
        get {
            return reachability?.networkReachabilityStatus ?? .unknown
        }
    }
    
    /// 获取当前网络状态（字符串）
    public var stateString: String {
        get {
            switch state {
                case .notReachable:
                    return "无网络"
                
            case .reachable(.wwan):
                    return "移动数据"
                
            case .reachable(.ethernetOrWiFi):
                    return "WIFI"
                
                default: break
            }
            
            return "未知网络"
        }
    }
    
    /// 是否连接有网络
    public var checkNetWorkIsOk: Bool {
        get {
            return reachability?.isReachable ?? true
        }
    }
    
    private init() {
        reachability?.listener = { (state) in
            let array = self.dic.values
            for block in array {
                block(state)
            }
        }
        
        reachability?.startListening()
    }
    
    /// 添加网络变化回调（会强引用，需要外部自行weak）；key是唯一标识
    public func addNetworkStateChangeBlockWithKey(_ key: String, block changeBlock: @escaping ZTNetworkStateChangeBlock) -> Bool {
        if key.count == 0 {
            return false
        }
        
        self.dic.updateValue(changeBlock, forKey: key)
        
        return true
    }
    
    /// 删除网络变化回调；当需要监听的对象被销毁时，需要把block删掉
    public func removeNetworkStateChangeBlockWithKey(_ key: String) -> Bool {
        if key.count == 0 {
            return false
        }
        
        self.dic.removeValue(forKey: key)
        
        return true
    }
}
