//
//  MarketViewController.swift
//  SwiftDemo
//
//  Created by 尹东博 on 2022/11/25.
//

import UIKit

class MarketViewController: BaseViewController {
    fileprivate lazy var titleArrs:Array<String> = ["最新价格","涨跌幅","一天振幅","一天成交张"]
    
    lazy var tgStockMainView : TGStockMainView = {
        var tgStockMainView = TGStockMainView.init(frame: CGRect(x: 0, y: 0, width: kSCREEN_WIDTH, height: view.mj_h - 44 - 49 - 64), topArr: titleArrs)
        tgStockMainView.backgroundColor = .green
        return tgStockMainView
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
   
        view.addSubview(tgStockMainView)
        self.navigationController?.title = "market_title" 
    }

}
