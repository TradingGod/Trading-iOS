//
//  HTTPTool.swift
//  TradingGodDemo
//
//  Created by 尹东博 on 2022/12/8.
//

import UIKit

class HTTPTool: NSObject {
    static let tool = HTTPTool()
    
    var currentDataTask: URLSessionDataTask?
    
//    func getData(period: String, complationBlock: @escaping(([MainCellModel]) -> Void)) {
//        currentDataTask?.cancel()
//        
//        let url = URL(string: "/api/v5/market/candles")
//        let request = URLRequest(url: url!)
//        let session: URLSession = URLSession.shared
//        let dataTask: URLSessionDataTask = session.dataTask(with: request) { data, response, error in
//            if error == nil, let _data = data {
//                guard let dic = try? JSONSerialization.jsonObject(with: _data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String:Any] else {
//                    fatalError()
//                }
//                print(dic)
////                if let dicts = dic["data"] as? [[String: Any]] {
//////                    let datas = dicts.map { (dict) -> MainCellModel in
//////                        return
//////                    }
////                    var addDatas: [Any] = []
////                    var newDatas: [Any] = []
////                    for idx in 0 ..< datas.count {
////                        if idx < 100 {
////                            addDatas.append(datas[idx])
////                        }else {
////                            newDatas.append(datas[idx])
////                        }
////                    }
//////
////                    DispatchQueue.main.async {
//////                        complationBlock(newDatas)
////                    }
////                    return
////                }
//            }
////            let datas?
//            DispatchQueue.main.async {
////                complationBlock()
//            }
//        }
//        currentDataTask = dataTask
//        dataTask.resume()
//    }
    
}
