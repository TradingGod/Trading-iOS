//
//  TGKLineStateManger.swift
//  TradingGodDemo
//
//  Created by 尹东博 on 2022/12/9.
//

import Foundation

class TGKLineStateManager {
    weak var klineChart: TGKLineChartView? {
        didSet {
            klineChart?.mainState = mainState
            klineChart?.secondaryState = secondaryState
            klineChart?.isLine = isLine
            klineChart?.datas = datas
        }
    }

    private init() {}

    static let manager = TGKLineStateManager()

    var addDatas: [TGKLineModel] = []

    var period: String = "1min"
    var mainState: TGMainState = .ma
    var secondaryState: TGSecondaryState = .macd
    var isLine = false
    var datas: [TGKLineModel] = [] {
        didSet {
            klineChart?.datas = datas
        }
    }

    func setMainState(_ state: TGMainState) {
        mainState = state
        klineChart?.mainState = state
    }

    func setSecondaryState(_ state: TGSecondaryState) {
        secondaryState = state
        klineChart?.secondaryState = state
    }

    func setisLine(_ isLine: Bool) {
        self.isLine = isLine
        klineChart?.isLine = isLine
    }

    func setDatas(_ datas: [TGKLineModel]) {
        self.datas = datas
        klineChart?.datas = datas
    }

    func setPeriod(_ period: String) {
        // 需要重新请求数据
        self.period = period
        datas = []
//        HTTPTool.tool.getData(period: period) { datas in
//            DataUtil.calculate(dataList: datas)
//            KLineStateManger.manager.datas = datas
//        }
    }
}
