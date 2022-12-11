//
//  TGRingChartView.swift
//  TradingGodDemo
//
//  Created by 尹东博 on 2022/12/11.
//

import UIKit

enum MarkViewDirectionEnum {
    case none
    case top
    case bottom
    case left
    case right
}

class TGRingChartView: UIView {
    var title:String = ""
    var titleColor:UIColor = .black
    var titleFont:UIFont = .systemFont(ofSize: 12)
    
    var valueColor:UIColor?
    var valueFont:UIFont?
    
    var colorArray:Array<Any> = []
    var titleArray:Array<Any> = []
    var valueArray:Array<Any> = []
    
    var ringWidth:CGFloat?
    
    var titleLabel:UILabel?
    var valueLabel:UILabel?
    var layerArray:NSMutableArray?
    var mvArray:NSMutableArray?
    var beginAngle:CGFloat = 0.0
    var ACenter:CGPoint = .zero
    var radius:CGFloat = 0.0
    var endAngle:CGFloat = 0.0
    var totality:CGFloat = 0.0
    var markViewDirection:MarkViewDirectionEnum?
    var width:CGFloat = 0
    var height:CGFloat = 0
    
    let sAngle:CGFloat = -Double.pi/2
    let eAngle:CGFloat = Double.pi * 2
     
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
     
    init(frame: CGRect, direction:MarkViewDirectionEnum) {
        markViewDirection = direction
        width = frame.size.width
        height = frame.size.height
        var centerX:CGFloat = width * 0.5
        var centerY:CGFloat = height * 0.5
        if (markViewDirection == .left){
            centerX = width * 0.75
            centerY = height * 0.5
        }else if(markViewDirection == .right) {
            centerX = width * 0.25
            centerY = height * 0.5
        }else if (markViewDirection == .top) {
            centerX = width * 0.5
            centerY = height * 0.75
        }else if (markViewDirection == .bottom) {
            centerX = width * 0.5
            centerY = height * 0.25
        }
        ACenter = CGPoint(x: centerX, y: centerY)
        radius = height > width ? (width * 0.5 - 15) : (height * 0.5 - 15)
        super.init(frame: frame)
    }
     
    func valueForTotality() {
        guard valueArray.count != 0 else {return}
        for m in valueArray {
            let count = m as! CGFloat
            totality += count
        }
    }
    
    public func drawChart() {
        if (markViewDirection != nil) {
            var x = 0
            var y = 0
            var mvWidth:CGFloat = 100.0
            var mvHeight:CGFloat = 12
            var margin:CGFloat = 0
            
            mvArray = NSMutableArray.init()
            for (i,v) in valueArray.enumerated() {
                let indexX:Int = i % 2
                let IndexY:Int = i / 2

                if (markViewDirection == .left) {
                    margin = (radius * 2 - CGFloat(12*valueArray.count)) / 2
                    x = Int(width * 0.75 - radius - mvWidth  - 30)
                    let radius_h = Int((height - radius * 2)/2)
                    let margin_h = Int((margin + mvHeight)) * i
                    y = radius_h / margin_h

                }else if (markViewDirection == .right) {
                    
//                    margin = (radius*2 - Float(12*valueArray.count)) / 5
//                    x = width * 0.25 + radius + 30;
//                    y = (height - radius * 2) / 2 + (margin + mvHeight) * i;

                }else if (markViewDirection == .top) {
//                    x = indexX == 0 ? width / 2 - 15 - mvWidth : _width / 2 + 15;
//                    y = _height * 0.75 - _radius - 30 - (valueArray.count / 2) * 12 - (valueArray.count / 2 - 1) * 10 + indexY * (12 + 10);

                }else if (markViewDirection == .bottom) {
//                    x = indexX == 0 ? width / 2 - 15 - mvWidth : _width / 2 + 15;
//                    y = height * 0.25 + radius + 30 + indexY * (12 + 10);
                }

//                let itemView = UIView.init(frame: CGRect(x: x, y: y, width: 100, height: 12))
//                addSubview(itemView)
//                mvArray?.addObjects(from: itemView)
////
                let colorV = UIView.init(frame: CGRect(x: 0, y: 0, width: 12, height: 12))
                addSubview(colorV)
                colorV.backgroundColor = colorArray[i] as! UIColor
                colorV.layer.cornerRadius = 6
                colorV.layer.masksToBounds = true
//
//                let tLabel = UILabel.init(frame: CGRect(x: 25, y: 0, width: 40, height: 12))
//                addSubview(tLabel)
//                tLabel.text = v as! String
//                tLabel.font = .systemFont(ofSize: 12)
//                tLabel.textColor = .black
//                tLabel.textAlignment = .center
//
//                let vLabel = UILabel.init(frame: CGRect(x: 70, y: 0, width: 40, height: 12))
//                addSubview(vLabel)
//                vLabel.text = v as! String
//                vLabel.font = .systemFont(ofSize: 12)
//                vLabel.textColor = .black
//                vLabel.textAlignment = .center
            }
        }
    }
   
    
}
