//
//  UILabel+Category.swift
//  TradingGodDemo
//
//  Created by 尹东博 on 2022/11/28.
//

import Foundation
import UIKit


extension UILabel {
    class func createLabel(color: UIColor, fontSize:CGFont) -> UILabel {
        let label = UILabel()
        label.textColor = color
        label.font = UIFont.systemFont(ofSize: fontSize as! CGFloat)
        return label
    }
}
