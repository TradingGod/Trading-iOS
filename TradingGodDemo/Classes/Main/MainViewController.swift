//
//  MainViewController.swift
//  SwiftDemo
//
//  Created by 尹东博 on 2022/11/24.
//

import Foundation
import UIKit
import MJRefresh
import Alamofire
import Starscream 
import SwiftyJSON 
//import SwiftSocket

class MainViewController: BaseViewController,  UITableViewDelegate, UITableViewDataSource, WebSocketDelegate
{
    var socket : WebSocket!
    let server = WebSocketServer()
    var dataArray = Array<MainCellModel>.init()
    var timer: Timer?
    var count: Int = 0
    let kCountTime_NUM = 5
    var up_num = 0
    var down_num = 0
     
    
    lazy var topView: UIView = {
        let tv = UIView.init(frame: CGRect(x: 0, y: 0, width: kSCREEN_WIDTH, height: 44))
        return tv
    }()
    
    lazy var sLabel: UILabel = {
        let sl = UILabel.init(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
        sl.font = UIFont.systemFont(ofSize: 12)
        sl.numberOfLines = 2 
        return sl
    }()
    
    lazy var listTableView:UITableView = {() -> UITableView in
        var list = UITableView.init(frame: CGRect(x: 0, y: 44, width: kSCREEN_WIDTH, height: kSCRENNT_HEIGHT - kNaviHeight - kTabbarHeight - 84), style: .plain)
        list.delegate = self
        list.dataSource = self
        list.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self.self, refreshingAction: #selector(loadDataSenior))
//        list.mj_footer = MJRefreshAutoNormalFooter.init(refreshingTarget: self.self, refreshingAction: #selector(loadMoreDataSenior))
        return list
    }()
    
    func initTimer() {
        count = kCountTime_NUM
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(recordTime), userInfo: nil, repeats: true)
        if let curTimer: Timer = timer {
            RunLoop.main.add(curTimer, forMode: .common)
        }
    }
    
    @objc func recordTime() {
        count -= 1
        NotificationCenter.default.post(name: Notification.Name(rawValue: "NOTIFICATION_MAIN_COUNTDOWN"), object: count)
        if count == 0 {
            requestTickersData()
        }
    }
    
    deinit {
        cancleTimer()
    }
    
    func cancleTimer() {
        if(timer != nil) {
            timer?.invalidate()
            timer = nil
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
          
        initTimer()
        self.navigationController?.title = "main_title"
        self.edgesForExtendedLayout = []
        view.addSubview(topView)
        topView.addSubview(sLabel)
        view.addSubview(listTableView) 
        requestTickersData()
    }
    
    func dicValueString(_ dic:[String : Any]) -> String?{
          let data = try? JSONSerialization.data(withJSONObject: dic, options: [])
          let str = String(data: data!, encoding: String.Encoding.utf8)
          return str
      }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "testCellID"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? MainTableViewCell
        if cell == nil {
            cell = MainTableViewCell(style: .default, reuseIdentifier: cellId)
        }
        cell?.model = dataArray[indexPath.row] 
        return cell!
    }
    
    @objc func loadDataSenior() {
        requestTickersData()
        listTableView.mj_header?.endRefreshing()
    }
    
//    @objc func loadMoreDataSenior() {
//        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
//            self.listTableView.mj_footer?.resetNoMoreData()
//        }
//    }
     
    private func listDataFiter(arr:Array<MainCellModel>) -> Array<MainCellModel> {
        let arr_o = arr
        var arr_p:Array<MainCellModel> = []
        up_num = 0
        down_num = 0
        for model in arr_o {
            if model.instId.components(separatedBy: "-USDT-").count > 1 {
                arr_p.append(model)
                if model.rise_rate_f! >= 0 {
                    up_num = up_num + 1
                }else {
                    down_num = down_num + 1
                }
            }
        }
        return arr_p
    }
    
    private func requestTickersData() {
        Alamofire.request("https://www.okx.com/api/v5/market/tickers",
                          method: .get,
                          parameters: ["instType":"SWAP"]).response { //  20次/2s
            response in
            do {
                let jsonData = try JSON(data: response.data!)
                let dataArr = jsonData["data"]
                let cArr = NSArray.yy_modelArray(with: MainCellModel.self, json: dataArr.rawValue) as! [MainCellModel]
                let arr = self.systemSortMethod(listArr: cArr, isAscend: true)
                self.dataArray = self.listDataFiter(arr: arr)
                self.listTableView.reloadData()
                self.count = self.kCountTime_NUM
                self.updateSLabelData()
            } catch {
                print("解析失败")
            }
        }
    }
    
    fileprivate func systemSortMethod(listArr:Array<MainCellModel>, isAscend:Bool) -> Array<MainCellModel> {
        var arr:Array<MainCellModel> = listArr
        // swift 推荐用法
        if isAscend {
            arr = arr.sorted { m1, m2 in
                m1.last_f! > m2.last_f!
            }
        }else {
            arr = arr.sorted { m1, m2 in
                m1.last_f! < m2.last_f!
            }
        }
        return arr
    }
    
    fileprivate func updateSLabelData () {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 4
         
        let up_num_str = "\(up_num)"
        let down_num_str = "\(down_num)"
        let str = "  行情涨跌家数:\n  " + up_num_str + ":" + down_num_str
        let attStr = NSMutableAttributedString.init(string: str, attributes: [NSAttributedString.Key.paragraphStyle: style, NSAttributedString.Key.kern : 1])
        self.sLabel.attributedText = attStr
    }
    
    
    private func connectWebSocket() {
        var request = URLRequest(url: URL(string: "https://aws.okx.com")!)//"wss://ws.okx.com:8443/ws/v5/public"
        request.timeoutInterval = 5
        self.socket = WebSocket(request: request)
        self.socket.delegate = self
        self.socket.connect()
        let dic:[String: Any] = ["op":"subscribe","args":[["channel":"instruments","instType":"FUTURES"]]]
        let str = dicValueString(dic)
        self.socket.write(string: str!) { }
    }
    
    // MARK: - WebSocketDelegate
       func didReceive(event: WebSocketEvent, client: WebSocket) {
           switch event {
           case .connected(let headers):
               print("websocket is connected: \(headers)")
           case .disconnected(let reason, let code):
               print("websocket is disconnected: \(reason) with code: \(code)")
           case .text(let string):
               print("Received text: \(string)")
           case .binary(let data):
               print("Received data: \(data.count)")
           case .ping(_):
               break
           case .pong(_):
               break
           case .viabilityChanged(_):
               break
           case .reconnectSuggested(_):
               break
           case .cancelled:
               print("cancelled")
               self.socket.connect()
           case .error(let error):
               handleError(error)
               self.socket.connect()
           }
       }
           
       func handleError(_ error: Error?) {
           if let e = error as? WSError {
               print("websocket encountered an error: \(e.message)")
           } else if let e = error {
               print("websocket encountered an error: \(e.localizedDescription)")
           } else {
               print("websocket encountered an error")
           }
       }
       
       // MARK: Write Text Action
       @objc func writeText(_ sender: UIButton) {
//           socket.write(string: "hello there!")
       }
       
       // MARK: Disconnect Action
       
       @objc func disconnect(_ sender: UIButton) {
//           if isConnected {
//               sender.setTitle("Connect", for: .normal)
//               socket.disconnect()
//           } else {
//               sender.setTitle("Disconnect", for: .normal)
//               socket.connect()
//           }
       }
}
