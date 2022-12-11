//
//  TGWebSocket.swift
//  TradingGodDemo
//
//  Created by 尹东博 on 2022/12/7.
//

import UIKit
import SocketRocket


@objc protocol TGWebSocketDelegate {
    func tgWebSocketdidReceiveMessage(message: Dictionary<String, Any>)
}
 
class TGWebSocket :NSObject, SRWebSocketDelegate {
    
    static let sharedInstance = TGWebSocket()
    private override init(){}
     
    public var delegate: TGWebSocketDelegate?
    
    fileprivate var tgSocket:SRWebSocket?
    fileprivate var socket_url : String = ""
    fileprivate var isErrorLink: Bool = false
    fileprivate var isDisconnect: Bool = false
    fileprivate var isConnect:Bool = false
    fileprivate var responseDict:Dictionary<String, Any> = [:]
    fileprivate var reConnectTime :TimeInterval = 0
    fileprivate var heartBeat:Timer?
    
    open func connectWebServiceWithURL(url :String) {
        if url.count <= 0 {
            return
        }
        socket_url = url
        tgSocket = SRWebSocket.init(urlRequest: URLRequest.init(url: URL.init(string: url)!))
        tgSocket?.delegate = self
        tgSocket?.open()
    }
    
    
    @objc func sentheart() {
//        let dic:Dictionary<String,Int> = ["t":999]
//        sendMessage(message: dic, charPeriod: 0, description: "WebSocket心跳包数据")
        try? self.tgSocket?.send(string: "ping")
    }
     
    // open method
    open func reConnect() {
        socketClose()
        if reConnectTime > 64 {
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + self.reConnectTime) {
            self.tgSocket = nil
            self.connectWebServiceWithURL(url: self.socket_url)
            print("重连")
        }
        
        if (self.reConnectTime == 0) {
            reConnectTime = 2
        }else {
            reConnectTime *= 2
        }
    }
    
    open func socketClose() {
        if (tgSocket != nil) {
            tgSocket?.close()
            tgSocket = nil
            destoryHeartBeat()
        }
    }
    
    func ping() {
        if tgSocket?.readyState == .OPEN {
           try? tgSocket?.sendPing(nil)
        }
    }
    
    func destoryHeartBeat(){
        if heartBeat != nil {
            if ((heartBeat?.isValid) != nil) {
                heartBeat?.invalidate()
                heartBeat = nil
            }
        }
    }
    
    // 发送
    open func sendMessage(message: Dictionary<String, Any>, charPeriod:Int, description:String) {
        let concurrentQueue = DispatchQueue(label: "queuename", attributes: .concurrent)
        concurrentQueue.async {
            if (self.tgSocket != nil) {
                if self.tgSocket?.readyState == .OPEN {
                    let dic:[String:AnyObject] = message as Dictionary
                    let jsonString = self.convertDictionaryToString(dict: dic)
                    try? self.tgSocket?.send(string: jsonString)
                }
            } else if (self.tgSocket?.readyState == .CONNECTING) {
                self.reConnect()
            }else if (self.tgSocket?.readyState == .CLOSING || self.tgSocket?.readyState == .CLOSED) {
                self.reConnect()
            } else {
                print("没网络，发送失败，一旦断网 socket 会被我设置 nil 的")
                print("其实最好是发送前判断一下网络状态比较好，我写的有点晦涩，socket==nil来表示断网")
            }
        }
    }
    
    // 心跳
    func initHearBeat() {
        destoryHeartBeat()
        heartBeat = Timer.init(timeInterval: 5, target: self, selector: #selector(sentheart), userInfo: nil, repeats: true)
        if let curTimer: Timer = heartBeat {
            RunLoop.main.add(curTimer, forMode: .common)
        }
    }
    
    // 链接成功
    @objc func webSocketDidOpen(_ webSocket: SRWebSocket) {
        reConnectTime = 0
        initHearBeat()
         
    }
    
    // 链接失败
    @objc func webSocket(_ socket:SRWebSocket, didFailWithError: Error) {
        if socket == tgSocket {
            print("************************** socket 连接失败************************** ")
            tgSocket = nil
            reConnect()
        }
    }
    
    //链接断开
    @objc func webSocket(_ webSocket: SRWebSocket, didCloseWithCode code: Int, reason: String?, wasClean: Bool) {
        if webSocket == tgSocket {
            print("************************** socket连接断开**************************")
            print("断开链接, code\(code), resonse:\(String(describing: reason) ), wasClean:\(wasClean)")
            self.socketClose()
        }
    }
    
    // 返回信息
    @objc func webSocket(_ webSocket: SRWebSocket, didReceiveMessage message: Any) {
        if webSocket == tgSocket {
            
            let str = message as! String
            responseDict = getDictionaryFromJSONString(jsonStr: str)
//            print("message :  \(message)")
            delegate?.tgWebSocketdidReceiveMessage(message: responseDict)
//            let result:Int = responseDict["r"] as! Int
//            if result == 0 {
//                print("数据 正确无误 ～～～")
//            }
        }
    }
     
     /// JSON string to Array
     func getArrayFromJSONString(jsonStr: String) -> Array<Any> {
         
         let data: Data = jsonStr.data(using: .utf8)!
         
         let arr = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
         
         if arr != nil {
             return arr as! Array<Any>
         }
         
         return []
     }
     /// JSON string to Dictionary
     func getDictionaryFromJSONString(jsonStr: String) -> Dictionary<String, Any> {
         let jsonData: Data = jsonStr.data(using: .utf8)!
         let dictionary = try? JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers)
         if dictionary != nil {
             return dictionary as! Dictionary<String, Any>
         }
         return [:]
     }
    
    func convertDictionaryToString(dict:[String:AnyObject]) -> String {
      var result:String = ""
      do {
        let jsonData = try JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.init(rawValue: 0))
        if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
          result = JSONString
        }
      } catch {
        result = ""
      }
      return result
    }
    
    func convertArrayToString(arr:[AnyObject]) -> String {
      var result:String = ""
      do {
        let jsonData = try JSONSerialization.data(withJSONObject: arr, options: JSONSerialization.WritingOptions.init(rawValue: 0))
        if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
          result = JSONString
        }
      } catch {
        result = ""
      }
      return result
    }

}


