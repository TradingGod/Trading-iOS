//
//  TGDataManager.swift
//  TradingGodDemo
//
//  Created by 尹东博 on 2022/12/10.
//

import UIKit
import CoreData

class TGDataManager {
//    static let shared = TGDataManager()
//    private init() {}
     
   
    public class func addTradesData(tradesModel:TGTradesModel) {
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        let trades = NSEntityDescription.insertNewObject(forEntityName: "Trades", into: context) as! Trades
        trades.instId = tradesModel.instId
        trades.tradeId = tradesModel.tradeId
        trades.px = tradesModel.px
        trades.sz = tradesModel.sz
        trades.side = tradesModel.side
        trades.ts = tradesModel.ts
        do {
            try context.save()
//            print("保存成功")
        }catch {
            print("保存失败\(error)")
        }
    }
    
    public class func deleteData() { // 批量删除
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Trades>(entityName: "Trades")
        fetchRequest.fetchLimit = 10
        fetchRequest.fetchOffset = 0
        
        let predicate = NSPredicate(format: "id='1'", "")
        fetchRequest.predicate = predicate
        
        do {
            let fetcheObjects = try context.fetch(fetchRequest)
            for info in fetcheObjects {
                context.delete(info)
            }
            try! context.save()
        }catch {
            fatalError("不能保存:\(error)")
        }
    }
    
    public class func queryData(start_ts:NSInteger,end_ts:NSInteger) -> [Trades]{
        //获取管理的数据上下文 对象
           let app = UIApplication.shared.delegate as! AppDelegate
           let context = app.persistentContainer.viewContext
           //声明数据的请求
           let fetchRequest = NSFetchRequest<Trades>(entityName:"Trades")
//           fetchRequest.fetchLimit = 10 //限定查询结果的数量
//           fetchRequest.fetchOffset = 0 //查询的偏移量
           //设置查询条件
           let predicate = NSPredicate(format: " ts >= %ld && ts < %ld", start_ts, end_ts)
           fetchRequest.predicate = predicate
           //查询操作
           do {
               let fetchedObjects = try context.fetch(fetchRequest)
               //遍历查询的结果
//               for info in fetchedObjects{
//
//               }
               return fetchedObjects
           }
           catch {
               fatalError("不能保存：\(error)")
           }
        return []
    }
}


