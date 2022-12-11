//
//  TGSeries.swift
//  TradingGodDemo
//
//  Created by 尹东博 on 2022/11/29.
//

import UIKit
import  Foundation

public struct TGSeriesKey {
    public static let candle = "Candle"
    public static let timeline = "Timeline"
    public static let volume = "Volume"
    public static let ma = "MA"
    public static let ema = "EMA"
    public static let kdj = "KDJ"
    public static let macd = "MACD"
    public static let boll = "BOLL"
    public static let sar = "SAR"
    public static let sam = "SAM"
    public static let rsi = "RSI"
}

open class TGSeries: NSObject {
//    open var key = ""
//    open var title: String = ""
//    open var chartModels = [TGCharModel]() // 每个系列包含多个点线模型
//    open var hidden: Bool = false
//    open var showTitle: Bool = true
//    open var baseValueSticky = false
//    open var symmetrical = false
//    var seriesLayer; 
}


/// 线段组
/// 在图表中一个要显示的“线段”都是以一个CHSeries进行封装。
/// 蜡烛图线段：包含一个蜡烛图点线模型（CHCandleModel）
/// 时分线段：包含一个线点线模型（CHLineModel）
/// 交易量线段：包含一个交易量点线模型（CHColumnModel）
/// MA/EMA线段：包含一个线点线模型（CHLineModel）
/// KDJ线段：包含3个线点线模型（CHLineModel），3个点线的数值根据KDJ指标算法计算所得
/// MACD线段：包含2个线点线模型（CHLineModel），1个条形点线模型
