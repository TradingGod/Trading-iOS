//
//  TGStockListLeftCell.swift
//  TradingGodDemo
//
//  Created by 尹东博 on 2022/12/5.
//

import UIKit

class TGStockListLeftCell: UITableViewCell {
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var model: MainCellModel? {
        didSet {
            
            iconLabel.text = model?.instId 
        }
    }
     
    fileprivate lazy var iconLabel:UILabel = {
        var iLabel = UILabel.init()
        iLabel.font = .systemFont(ofSize: 12)
        iLabel.textAlignment = .center
        iLabel.numberOfLines = 3
        return iLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUI()
    }
    
    private func setUpUI() {
        contentView.addSubview(iconLabel)
        
        setsubViewsLayout()
    }
    
    fileprivate func setsubViewsLayout(){
        iconLabel.snp.makeConstraints { make in
            make.left.top.bottom.equalTo(contentView).offset(5)
//            make.height.equalTo(30)
            make.width.equalTo(80)
        }
    }
}
