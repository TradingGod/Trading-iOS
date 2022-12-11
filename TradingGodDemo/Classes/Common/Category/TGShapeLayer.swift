//
//  TGShapeLayer.swift
//  TradingGodDemo
//
//  Created by 尹东博 on 2022/11/29.
//

import UIKit
import Foundation

open class TGShapeLayer: CAShapeLayer {
    // 关闭 CAShapeLayer 的隐式动画，避免滑动时候或者十字线出现时有残影的现象(实际上是因为 Layer 的 position 属性变化而产生的隐式动画)
    open override func action(forKey event:String) -> CAAction? {
        return nil
    }
}

open class TGTextLayer: CATextLayer {
    // 关闭 CAShapeLayer 的隐式动画，避免滑动时候或者十字线出现时有残影的现象(实际上是因为 Layer 的 position 属性变化而产生的隐式动画)
    open override func action(forKey event:String) -> CAAction? {
        return nil
    }
}
