//
//  TGKLineModel.swift
//  TradingGodDemo
//
//  Created by 尹东博 on 2022/12/8.
//

import UIKit
import YYModel 

/*
 [ts,o,h,l,c,vol,volCcy,volCcyQuote,confirm]
 [
   "1670486520000", //ts
   "1232.64", //o
   "1232.71",//h
   "1232.64",//l
   "1232.71",//c
   "18",// vol
   "1.8",//volCcy
   "2218.808",// volCcyQuote
   "0" // confirm
 ]
 */

class TGKLineModel: NSObject,YYModel {
    public var ts: NSInteger = 0 // 开始时间，Unix时间戳的毫秒数格式，如 1597026383085
    public var ts_end: NSInteger {
        get { // 获取结束时间戳
            return ts + 60000
        }
    }
    public var  o:CGFloat = 0 // 开盘价格
    public var  h:CGFloat = 0  // 最高价格
    public var  l:CGFloat = 0  // 最低价格
    public var  c:CGFloat = 0  // 收盘价格
    public var  vol:CGFloat = 0  // 交易量，以张为单位 如果是衍生品合约，数值为合约的张数。 如果是币币/币币杠杆，数值为交易货币的数量。
    public var  volCcy:CGFloat = 0  // 交易量，以币为单位  如果是衍生品合约，数值为交易货币的数量。 如果是币币/币币杠杆，数值为计价货币的数量
    public var  volCcyQuote:CGFloat = 0  // 交易量，以计价货币为单位  如：BTC-USDT 和 BTC-USDT-SWAP, 单位均是 USDT；  BTC-USD-SWAP 单位是 USD
    public var  confirm:Int = 0 // K线状态 0 代表 K 线未完结，1 代表 K 线已完结。
    
    public var MA5Price: CGFloat = 0
    public var MA10Price: CGFloat = 0
    public var MA20Price: CGFloat = 0
    public var MA30Price: CGFloat = 0
     
    public var mb: CGFloat = 0
    public var up: CGFloat = 0
    public var dn: CGFloat = 0
     
    public var dif: CGFloat = 0
    public var dea: CGFloat = 0
    public var macd: CGFloat = 0
    public var ema12: CGFloat = 0
    public var ema26: CGFloat = 0
    
    
    public var MA5Volume: CGFloat = 0
    public var MA10Volume: CGFloat = 0
      
    public var rsi: CGFloat = 0
    public var rsiABSEma: CGFloat = 0
    public var rsiMaxEma: CGFloat = 0
    
    public var k: CGFloat = 0
    public var d: CGFloat = 0
    public var j: CGFloat = 0
    public var r: CGFloat = 0
    
    public var buyVolume:CGFloat = 0
    public var sellVolume:CGFloat = 0
 
    
    open class func initWith(arr:[String]) -> TGKLineModel {
        let model = TGKLineModel.init()
        model.dataAnalysis(arr: arr)
        return model 
    }
    
    func  dataAnalysis(arr:[String]) {
        guard arr.count > 0 else {
            return
        }
        for (i,v) in arr.enumerated() {
            if i == 0 {
                ts = v.StringToNSInteger() 
            }else if i == 1 {
                o = v.StringToCGFloat()
            }else if i == 2 {
                h = v.StringToCGFloat()
            }else if i == 3 {
                l = v.StringToCGFloat()
            }else if i == 4 {
                c = v.StringToCGFloat()
            }else if i == 5{
                vol = v.StringToCGFloat()
            }else if i == 6 {
                volCcy = v.StringToCGFloat()
            }else if i == 7 {
                volCcyQuote = v.StringToCGFloat()
            }else if i == 8 {
                confirm = v.StringToNSInteger()
            }
        }
    }
    
  func queryTradesData() {
      let arr:[Trades] = TGDataManager.queryData(start_ts: self.ts, end_ts: self.ts_end)
      guard arr.count != 0 else {return}
      self.buyVolume = 0
      self.sellVolume = 0
      for trade in arr {
          let sz_f = trade.sz?.StringToCGFloat() ?? 0
          if trade.side == "buy" {
              self.buyVolume = sz_f + self.buyVolume
          }else {
              self.sellVolume = sz_f + self.sellVolume
          }
      }
  }
}



