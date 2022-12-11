//
//  TGStockTopItemView.swift
//  TradingGodDemo
//
//  Created by 尹东博 on 2022/12/5.
//

import UIKit

@objc protocol StockTopItemDeleagte {
    func stockTopItemDidSelect(_ stockTopItemView:TGStockTopItemView, _ button:UIButton)
}

class TGStockTopItemView: UIView {
    open var StockTopDelegate: StockTopItemDeleagte?
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    public init(frame: CGRect, target:UIView ,action:String, title:String, index:Int) {
        super.init(frame: frame)
        self.tag = index
        setupSubViews(title: title,target: target, action:action)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubViews(title: String, target:UIView,action:String) {
        let btn = UIButton.init(type: .custom)
        btn.tag = self.tag
        btn.setTitle(title, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 11)
//        btn.backgroundColor = .red
        btn.setTitleColor(.black, for: .normal) 
        let lineView = UIView.init()
        lineView.backgroundColor = .gray.withAlphaComponent(0.3) 
        btn.addSubview(lineView)
//        if #available(iOS 15.0, *) {
//            var conf = UIButton.Configuration.plain()
//            conf.imagePlacement = .trailing
//            conf.imagePadding = 0
//            btn.configuration = conf
//        }
        
        btn.titleLabel?.textAlignment = .center
        btn.addTarget(target, action: Selector((action)), for: .touchUpInside)
        self.addSubview(btn)
        btn.snp.makeConstraints { make in
            make.left.equalTo(self).offset(0)
            make.top.bottom.equalTo(self).offset(0)
            make.width.equalTo(100)
        }
        lineView.snp.makeConstraints { make in
            make.right.equalTo(btn.snp_right).offset(-2)
            make.top.bottom.equalTo(self).offset(0)
            make.width.equalTo(2)
        }
    }
    
    private func btnResponse(_ button:UIButton) {
        print("点击 的tag   \(button.tag)")
    }
}
