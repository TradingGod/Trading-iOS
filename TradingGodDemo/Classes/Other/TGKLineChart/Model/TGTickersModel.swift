//
//  TGTickersModel.swift
//  TradingGodDemo
//
//  Created by 尹东博 on 2022/12/10.
//

import UIKit
import YYModel

/*
 {"instType":"SWAP",
 "instId":"ETH-USDT-SWAP",
 "last":"1265.96",
 "lastSz":"6",
 "askPx":"1265.96",
 "askSz":"6",
 "bidPx":"1265.95",
 "bidSz":"2290",
 "open24h":"1281.22",
 "high24h":"1299",
 "low24h":"1255",
 "sodUtc0":"1263.07",
 "sodUtc8":"1277.68",
 "volCcy24h":"2185098.2",
 "vol24h":"21850982",
 "ts":"1670656768408"}
 */

class TGTickersModel: NSObject, YYModel{
    var instType:String = ""
    var instId:String = ""
    var last:String = ""
    var lastSz:String = ""
    var askPx:String = ""
    var askSz:String = ""
    var bidPx:String = ""
    var open24h:String = ""
    var hight24h:String = ""
    var low24h:String = ""
    var volCcy24h:String = ""
    var col24h:String = ""
    var ts:String = ""
}
