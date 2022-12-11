//
//  KLineIndicatorsView.swift
//  KLine-Chart
//
//  Created by 何俊松 on 2020/3/3.
//  Copyright © 2020 hjs. All rights reserved.
//

import UIKit

class KLineIndicatorsView: UIView {
    @IBOutlet var maButton: UIButton! // tag == 1
    @IBOutlet var bollButton: UIButton! // tag == 2
    @IBOutlet var macdButton: UIButton! // tag == 1
    @IBOutlet var kdjButton: UIButton! // tag == 2
    @IBOutlet var rsiButton: UIButton! // tag == 3
    @IBOutlet var wrButton: UIButton! // tag == 4

    static func indicatorsView() -> KLineIndicatorsView {
        guard let view = Bundle.main.loadNibNamed("KLineIndicatorsView", owner: self, options: nil)?.last as? KLineIndicatorsView else {
            fatalError()
        }
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 80)
        view.backgroundColor = ChartColors.bgColor
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowRadius = 5
        return view
    }

    @IBAction func mainbuttonClick(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            maButton.isSelected = true
            bollButton.isSelected = false
            TGKLineStateManager.manager.setMainState(TGMainState.ma)
        case 2:
            maButton.isSelected = false
            bollButton.isSelected = true
            TGKLineStateManager.manager.setMainState(TGMainState.boll)
        default:
            break
        }
    }

    @IBAction func vicebuttonClick(_ sender: UIButton) {
        macdButton.isSelected = false
        kdjButton.isSelected = false
        rsiButton.isSelected = false
        wrButton.isSelected = false

        switch sender.tag {
        case 1:
            macdButton.isSelected = true
            TGKLineStateManager.manager.setSecondaryState(.macd)
        case 2:
            kdjButton.isSelected = true
            TGKLineStateManager.manager.setSecondaryState(.kdj)
        case 3:
            rsiButton.isSelected = true
            TGKLineStateManager.manager.setSecondaryState(.rsi)
        case 4:
            wrButton.isSelected = true
            TGKLineStateManager.manager.setSecondaryState(.wr)
        default:
            break
        }
    }

    @IBAction func mainhideClick(_: UIButton) {
        maButton.isSelected = false
        bollButton.isSelected = false
        TGKLineStateManager.manager.setMainState(TGMainState.none)
    }

    @IBAction func viceHideClick(_: Any) {
        macdButton.isSelected = false
        kdjButton.isSelected = false
        rsiButton.isSelected = false
        wrButton.isSelected = false
        TGKLineStateManager.manager.setSecondaryState(.none)
    }

    func correctState() {
        switch TGKLineStateManager.manager.mainState {
        case .ma:
            mainbuttonClick(maButton)
        case .boll:
            mainbuttonClick(bollButton)
        case .none:
            mainhideClick(UIButton())
        }

        switch TGKLineStateManager.manager.secondaryState {
        case .macd:
            vicebuttonClick(macdButton)
        case .kdj:
            vicebuttonClick(kdjButton)
        case .rsi:
            vicebuttonClick(rsiButton)
        case .wr:
            vicebuttonClick(wrButton)
        case .none:
            viceHideClick(UIButton())
        }
    }

    @IBAction func addDataClick(_: UIButton) {
        if let model = TGKLineStateManager.manager.addDatas.last {
            var models = TGKLineStateManager.manager.datas
            KLineDataUtil.addLastData(dataList: models, data: model)
            models.insert(model, at: 0)
            TGKLineStateManager.manager.datas = models
            TGKLineStateManager.manager.addDatas.removeLast()
        }
    }
}
