//
//  UIView+TGView.swift
//  SwiftDemo
//
//  Created by 尹东博 on 2022/11/25.
//

import Foundation
import UIKit

extension UIView {
    public func TG_addCornet(conrners:UIRectCorner, radius:CGFloat) {
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: conrners, cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
}
