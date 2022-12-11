//
//  Date.swift
//  TradingGodDemo
//
//  Created by 尹东博 on 2022/11/28.
//

import UIKit

extension NSString {
    class func lessSecondToDay(seconds:Int) -> String {
//        let hour = seconds/3600
        let min = seconds%(3600)/60
        let second = seconds%60
        if second <= 0 {
            return "过期"
        }
//        return "\(hour):\(min):\(second)"
        return "\(min):\(second)"
    }
}
