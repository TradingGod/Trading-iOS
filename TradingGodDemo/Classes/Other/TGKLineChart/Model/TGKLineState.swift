//
//  TGKLineState.swift
//  TradingGodDemo
//
//  Created by 尹东博 on 2022/12/8.
//

import Foundation

public enum TGKLineDirection: Int {
    case vertical
    case horizontal
}


public enum TGMainState: Int {
    case ma
    case boll
    case none
}

public enum TGVolState: Int {
    case a
    case vol
    case none 
}

public enum TGSecondaryState: Int {
    case macd
    case kdj
    case rsi
    case wr
    case none
}
