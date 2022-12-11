//
//  KLineInfoView.swift
//  KLine-Chart
//
//  Created by 何俊松 on 2020/3/2.
//  Copyright © 2020 hjs. All rights reserved.
//

import UIKit

class KLineInfoView: UIView {
    @IBOutlet var timeLable: UILabel!

    @IBOutlet var openLable: UILabel!

    @IBOutlet var highLable: UILabel!

    @IBOutlet var lowLabel: UILabel!

    @IBOutlet var clsoeLabel: UILabel!

    @IBOutlet var IncreaseLabel: UILabel!

    @IBOutlet var amplitudeLabel: UILabel!

    @IBOutlet var amountLable: UILabel!

    @IBOutlet weak var buyLabel: UILabel!
    
    @IBOutlet weak var sellLabel: UILabel!
    
    var model: TGKLineModel? {
        didSet {
            guard let _model = model else {
                return
            }
//            timeLable.text = calculateDateText(timestamp: _model.id, dateFormat: "yy-MM-dd HH:mm")
            _model.queryTradesData()
            openLable.text = String(format: "%.2f", _model.o)
            highLable.text = String(format: "%.2f", _model.h)
            lowLabel.text = String(format: "%.2f", _model.l)
            clsoeLabel.text = String(format: "%.2f", _model.c)
            buyLabel.text = String(format: "%.2f", _model.buyVolume)
            sellLabel.text = String(format: "%.2f", _model.sellVolume)
            let upDown = _model.c - _model.o
            var symbol = "-"
            if upDown > 0 {
                symbol = "+"
                self.IncreaseLabel.textColor = ChartColors.upColor
                self.amplitudeLabel.textColor = ChartColors.upColor
            } else {
                self.IncreaseLabel.textColor = ChartColors.dnColor
                self.amplitudeLabel.textColor = ChartColors.dnColor
            }
            let upDownPercent = upDown / _model.o * 100
            IncreaseLabel.text = symbol + String(format: "%.2f", abs(upDown))
            amplitudeLabel.text = symbol + String(format: "%.2f", abs(upDownPercent)) + "%"
            amountLable.text = String(format: "%.2f", _model.vol)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = ChartColors.bgColor
        layer.borderWidth = 1
        layer.borderColor = ChartColors.gridColor.cgColor
    }

    static func lineInfoView() -> KLineInfoView {
        guard let view = Bundle.main.loadNibNamed("KLineInfoView", owner: self, options: nil)?.last as? KLineInfoView else {
            fatalError()
        }
        view.frame = CGRect(x: 0, y: 0, width: 120, height: 185)
        return view
    }
}
