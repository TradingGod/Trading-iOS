//
//  OtherViewController.swift
//  SwiftDemo
//
//  Created by 尹东博 on 2022/11/25.
//

import UIKit 
import Alamofire
import SwiftyJSON
import YYModel
import CoreData

class OtherViewController: BaseViewController , TGWebSocketDelegate{
    
    let kLineCharView = TGKLineChartView(frame: CGRect(x: 0, y: 0, width: kSCREEN_WIDTH, height: 350))
    var dataList:[TGKLineModel] = []
    var tradesList:[TGTradesModel] = []
    var timer: Timer?
    var buyVolume : CGFloat = 0.0
    var sellVolume: CGFloat = 0.0
     

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.title = "other_title"
        TGWebSocket.sharedInstance.delegate = self
         
        let btn = UIButton.init(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        btn.backgroundColor = .red
        btn.setTitle("订阅信息", for: .normal)
        view.addSubview(btn)
        btn.addTarget(self, action: #selector(reponseBtn), for: .touchUpInside)
        
        
        let btn2 = UIButton.init(frame: CGRect(x: 100, y: 0, width: 100, height: 30))
        btn2.backgroundColor = .green
        view.addSubview(btn2)
        btn2.setTitle("行情信息", for: .normal)
        btn2.addTarget(self, action: #selector(reponseBtnB), for: .touchUpInside)
        
        
        let btn3 = UIButton.init(frame: CGRect(x: 200, y: 0, width: 100, height: 30))
        btn3.backgroundColor = .blue
        view.addSubview(btn3)
        btn3.setTitle("1分钟k线", for: .normal)
        btn3.addTarget(self, action: #selector(reponseBtnC), for: .touchUpInside)
        
        
        let btn4 = UIButton.init(frame: CGRect(x: 300, y: 0, width: 100, height: 30))
        btn4.backgroundColor = . purple
        view.addSubview(btn4)
        btn4.setTitle("最近成交请求", for: .normal)
        btn4.addTarget(self, action: #selector(reponseBtnD), for: .touchUpInside)
        
        
        let btn5 = UIButton.init(frame: CGRect(x: 0, y: 30, width: 100, height: 30))
        btn5.backgroundColor = . systemPink
        view.addSubview(btn5)
        btn5.setTitle("深度请求", for: .normal)
        btn5.addTarget(self, action: #selector(reponseBtnE), for: .touchUpInside)
    
//        let btn6 = UIButton.init(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
//        btn6.backgroundColor = . systemPink
//        view.addSubview(btn6)
//        btn6.addTarget(self, action: #selector(reponseBtnF), for: .touchUpInside)
       
//        kLineCharView.backgroundColor = .gray
        view.addSubview(kLineCharView)
        TGKLineStateManager.manager.klineChart = kLineCharView
        
        
//        let item = UIBarButtonItem(title: "右", style: .plain , target: self, action: #selector(rightActionMethod))
//        navigationItem.rightBarButtonItem = item
//        navigationController?.navigationBar.tintColor = .white
        
        reponseBtnC()
        reponseBtnD()
        rightActionMethod()
    }
    
    func initTimer() { // 40 /2 20-1 0.05
        guard timer == nil else {return}
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(recordTime), userInfo: nil, repeats: true)
        if let curTimer: Timer = timer {
            RunLoop.main.add(curTimer, forMode: .common)
        }
    }
    
    @objc func recordTime() {
        request2TimesData()
    }
    
    
    @objc func reponseBtn() {
        print("订阅请求~~~~~~~~~~~~~~~~")
        let dic = ["op":"subscribe","args":[["channel":"instruments","instType":"SWAP"]]] as [String : Any]
        TGWebSocket.sharedInstance.sendMessage(message: dic, charPeriod: 0, description: "订阅请求～～")
//        首次订阅推送产品的全量数据；后续当有产品状态变化时（如期货交割、期权行权、新合约/币对上线、人工暂停/恢复交易等），推送产品的增量数据。
    }
    
    @objc func reponseBtnB() {
        print("行情请求～～～～～～～～～～～～～～～·")
        let dic = ["op":"subscribe","args":[["channel":"tickers","instId":"ETH-USDT-SWAP"]]] as [String : Any]
        TGWebSocket.sharedInstance.sendMessage(message: dic, charPeriod: 0, description: "行情请求～～")
//        获取产品的最新成交价、买一价、卖一价和24小时交易量等信息。
//        最快100ms推送一次，没有触发事件时不推送，触发推送的事件有：成交、买一卖一发生变动。
    }
    
    @objc func reponseBtnC() {
        print("1分钟k线请求～～～～～～～～～～～～～～～·")
        let dic = ["op":"subscribe","args":[["channel":"candle1m","instId":"ETH-USDT-SWAP"]]] as [String : Any]
        TGWebSocket.sharedInstance.sendMessage(message: dic, charPeriod: 0, description: "1分钟k线请求～～")
    }
    
    @objc func reponseBtnD() {
        print("最近成交请求～～～～～～～～～～～～～～～·")
        let dic = ["op":"subscribe","args":[["channel":"trades","instId":"ETH-USDT-SWAP"]]] as [String : Any]
        TGWebSocket.sharedInstance.sendMessage(message: dic, charPeriod: 0, description: "最近成交请求～～")
    }
    
    @objc func reponseBtnE() {
        print("深度请求～～～～～～～～～～～～～～～·")
        let dic = ["op":"subscribe","args":[["channel":"books5","instId":"ETH-USDT-SWAP"]]] as [String : Any]
        TGWebSocket.sharedInstance.sendMessage(message: dic, charPeriod: 0, description: "深度请求～～")
    }
      
    @objc func rightActionMethod() {
        dataList.removeAll()
        Alamofire.request("https://www.okx.com/api/v5/market/candles", method: .get, parameters: ["instId":"ETH-USDT-SWAP","bar":"1m","limit":"300"]).response {
            response in
            do {
                let jsonData = try JSON(data: response.data!)
                let dataJson = jsonData["data"].rawValue as? [[String]]
                guard dataJson != nil else {
                    return
                }
                self.dataAnalysis(arr: dataJson!)
                KLineDataUtil.calculate(dataList: self.dataList)
                TGKLineStateManager.manager.datas = self.dataList
                self.initTimer() 
            }catch { }
        }
    }
    
    func request2TimesData() {
        Alamofire.request("https://www.okx.com/api/v5/market/candles", method: .get, parameters: ["instId":"ETH-USDT-SWAP","bar":"1m","limit":"2"]).response {
            response in
            do {
                let jsonData = try JSON(data: response.data!)
                let dataJson = jsonData["data"].rawValue as? [[String]]
                guard dataJson != nil else {
                    return
                }
                self.replaceArrData(arr: dataJson!)
                KLineDataUtil.calculate(dataList: self.dataList)
                TGKLineStateManager.manager.datas = self.dataList
            }catch { }
        }
    }
    
    func  dataAnalysis(arr:[[String]]) {
        for m in arr {
            let model = TGKLineModel.initWith(arr: m)
            dataList.append(model)
        }
    }
    
    func replaceArrData(arr:[[String]]) {
        guard arr.count != 0 else { return }
        guard dataList.count != 0 else {return}
//        let model = TGKLineModel.initWith(arr: itemArr)
        var r_arr:[TGKLineModel] = []
        for m in arr {
            let model = TGKLineModel.initWith(arr: m)
            r_arr.append(model)
        }
        let firstModel = r_arr.first
        let secModel = r_arr[1]
        let o_firstModel = dataList.first
//        let o_secModel = dataList[1]
        let tempArr:NSMutableArray = NSMutableArray.init(array: dataList)
        if firstModel?.ts == o_firstModel?.ts { // 当前k线
            firstModel?.buyVolume = self.buyVolume
            firstModel?.sellVolume = self.sellVolume
            tempArr.replaceObject(at: 0, with: firstModel!)
        }else if secModel.ts == o_firstModel?.ts { //过去了
            tempArr.insert(firstModel!, at: 0)
        }else {
            rightActionMethod()
        }
        dataList = tempArr.copy() as! [TGKLineModel]
        KLineDataUtil.calculate(dataList: self.dataList)
        TGKLineStateManager.manager.datas = self.dataList
    }
    
    
    // TGWebSocketDelegate
    func tgWebSocketdidReceiveMessage(message: [String : Any]) {
        var argDic:[String:String]?
        var data:[Any]?
        var channel:String =  ""
        if message.keys.contains("arg") {
            argDic = message["arg"] as? [String:String]
            channel = argDic?["channel"] ?? ""
        }
        if message.keys.contains("data") {
            if channel == "trades" {
                data = message["data"] as? [[String:String]]
            }
            if channel == "candle1m" {
                data = message["data"] as? [[String]]
            }
        }
        guard argDic != nil else { return }
        guard data != nil else {return}
        if argDic!["channel"] == "candle1m" {
            if data!.count > 0 {
                let candle_arr = data?.last as! [String]
                let klineM = TGKLineModel.initWith(arr: candle_arr)
                if klineM.confirm == 1 {
                    print("新一分钟即将开始-------------------")
                    self.buyVolume = 0
                    self.sellVolume = 0
                }
            }
        }
        
        if argDic!["channel"] == "trades" {
            let dic = data?.last as? NSDictionary
            let mmm = TGTradesModel.yy_model(with: dic as! [AnyHashable : Any])
            if mmm != nil {
                tradesList.append(mmm!)
//                let px_f:CGFloat = mmm?.px.StringToCGFloat() ?? 0
                let sz_f:CGFloat = mmm?.sz.StringToCGFloat() ?? 0
                let volue = sz_f
                if mmm?.side == "buy" {
                    self.buyVolume = volue + self.buyVolume
                }else {
                    self.sellVolume = volue + self.sellVolume
                }
                TGDataManager.addTradesData(tradesModel: mmm!)
            }
        }
    }
     
}
