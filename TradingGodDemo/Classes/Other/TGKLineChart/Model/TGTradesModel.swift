//
//  TGTradesModel.swift
//  TradingGodDemo
//
//  Created by 尹东博 on 2022/12/10.
//

import UIKit
import YYModel

/*
 {"arg":{"channel":"trades",
 "instId":"ETH-USDT-SWAP"},
 "data":[
 {"instId":"ETH-USDT-SWAP",
 "tradeId":"757974798",
 "px":"1265.09",
 "sz":"78",
 "side":"sell",
 "ts":"1670657146222"}]}
 */

@objcMembers
class TGTradesModel: NSObject,YYModel {
    var instId:String = ""
    var tradeId:String = ""
    var px:String = ""
    var sz:String = ""
    var side:String = "" // buy、sell
    var ts:String = ""
}
