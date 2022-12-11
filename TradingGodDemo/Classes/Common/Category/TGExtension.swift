//
//  TGExtension.swift
//  TradingGodDemo
//
//  Created by 尹东博 on 2022/11/29.
//

import Foundation
import UIKit


public extension CGFloat {
    /**
     转化为字符串格式
     
     - parameter minF:
     - parameter maxF:
     - parameter minI:
     
     - returns:
     */
    func td_toString(_ minF: Int = 2, maxF: Int = 6, minI: Int = 1) -> String {
        let valueDecimalNumber = NSDecimalNumber(value: Double(self) as Double)
        let twoDecimalPlacesFormatter = NumberFormatter()
        twoDecimalPlacesFormatter.maximumFractionDigits = maxF
        twoDecimalPlacesFormatter.minimumFractionDigits = minF
        twoDecimalPlacesFormatter.minimumIntegerDigits = minI
        return twoDecimalPlacesFormatter.string(from: valueDecimalNumber)!
    }
}


public extension String {
    func StringToCGFloat()->(CGFloat) {
        var cgFloat: CGFloat = 0
        if let doubleValue = Double(self) {
            cgFloat = CGFloat(doubleValue)
        }
        return cgFloat
    }
    
    func StringToNSInteger()->(NSInteger) {
        return NSInteger(self) ?? 0
    }
}
