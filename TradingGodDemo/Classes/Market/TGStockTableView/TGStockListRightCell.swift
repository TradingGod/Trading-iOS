//
//  TGStockListRightCell.swift
//  TradingGodDemo
//
//  Created by 尹东博 on 2022/12/5.
//

import UIKit

class TGStockListRightCell: UITableViewCell {

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public var model: MainCellModel? {
        didSet {
            priceLabel.text = model?.last
            rateLabel.text = model?.rise_rate_str
            rangeLabel.text = model?.range_str
            volumeLabel.text = model?.vol24h
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUI()
    }
    
    
    fileprivate lazy var priceLabel:UILabel = {
        var pLabel = UILabel.init()
        pLabel.font = .systemFont(ofSize: 12)
        pLabel.textAlignment = .center
        pLabel.numberOfLines = 2
        pLabel.layer.borderWidth = 1
        pLabel.layer.borderColor = UIColor.red.cgColor
        return pLabel
    }()
    
    fileprivate lazy var rateLabel:UILabel = {
        var rLabel = UILabel.init()
        rLabel.font = .systemFont(ofSize: 12)
        rLabel.textAlignment = .center
        rLabel.numberOfLines = 2
        rLabel.layer.borderWidth = 1
        rLabel.layer.borderColor = UIColor.red.cgColor
        return rLabel
    }()
    
    fileprivate lazy var rangeLabel:UILabel = {
        var rLabel = UILabel.init()
        rLabel.font = .systemFont(ofSize: 12)
        rLabel.textAlignment = .center
        rLabel.numberOfLines = 2
        rLabel.layer.borderWidth = 1
        rLabel.layer.borderColor = UIColor.red.cgColor
        return rLabel
    }()
    
    fileprivate lazy var volumeLabel:UILabel = {
        var vLabel = UILabel.init()
        vLabel.font = .systemFont(ofSize: 12)
        vLabel.textAlignment = .center
        vLabel.numberOfLines = 2
        vLabel.layer.borderWidth = 1
        vLabel.layer.borderColor = UIColor.red.cgColor
        return vLabel
    }()
    
    private func setUpUI() {
        contentView.addSubview(priceLabel)
        contentView.addSubview(rateLabel)
        contentView.addSubview(rangeLabel)
        contentView.addSubview(volumeLabel)
        setsubViewsLayout()
    }
    
    fileprivate func setsubViewsLayout(){
        priceLabel.snp.makeConstraints { make in
            make.left.top.equalTo(contentView).offset(5)
            make.bottom.equalTo(contentView).offset(-5)
            make.width.equalTo(95)
        }
        
        rateLabel.snp.makeConstraints { make in
            make.top.equalTo(priceLabel)
            make.bottom.equalTo(contentView).offset(-5)
            make.width.equalTo(85)
            make.left.equalTo(priceLabel.snp_right).offset(5)
        }
        
        rangeLabel.snp.makeConstraints { make in
            make.top.equalTo(rateLabel)
            make.bottom.equalTo(contentView).offset(-5)
            make.width.equalTo(100)
            make.left.equalTo(rateLabel.snp_right).offset(5)
        }
        
        volumeLabel.snp.makeConstraints { make in
            make.top.equalTo(rangeLabel)
            make.bottom.equalTo(contentView).offset(-5)
            make.width.equalTo(100)
            make.left.equalTo(rangeLabel.snp_right).offset(5)
        }
    }
}
