//
//  MainTableViewCell.swift
//  SwiftDemo
//
//  Created by 尹东博 on 2022/11/26.
//

import UIKit
import SnapKit

class MainTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        NotificationCenter.default.addObserver(self, selector: #selector(configureTimerWithTime), name: NSNotification.Name(rawValue: "NOTIFICATION_MAIN_COUNTDOWN"), object: nil)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
     var askPx: String = "" // = "0.3773";
     var askSz: String = ""// = 141;
     var bidPx: String = ""  //= "0.3765";
     var bidSz: Int = 0// = 70;
     var high24h: String = "" //= "0.3821";
     var instId: String = "" //= "BNT-USDT-SWAP";
     var instType: String = ""// = SWAP;
     var last: String = "" //= "0.377";
     var lastSz: String = ""// = 11;
     var low24h: String = ""// = "0.3676";
     var open24h :String = ""// = "0.3729";
     var sodUtc0:String = ""// = "0.3713";
     var sodUtc8 :String = ""// = "0.3727";
     var ts :Int = 0 //1669552155307;
     var vol24h: String = ""// = 101509;
     var volCcy24h: String = ""// = 1015090;
     */
    
    
    public var model: MainCellModel?
    {
        didSet {
            let arr:[String] = (model?.instId.components(separatedBy: "-"))!
            let name = arr[0] as String
            selBtn.setImage(UIImage.init(named: "\(name)_icon.webp"), for: .normal)
            coinLabel.text = model?.instId
            priceLabel.text = "$" + model!.last
            limitLabel.text = model?.rise_rate_percent
            dayVolumeLabel.text = model?.vol24h_w_str
            
            let color_f:UIColor =  model!.rise_rate_f! > 0 ? UIColor.td_hexColor("58c08f") : UIColor.td_hexColor("d05448")
            limitLabel.backgroundColor = color_f
            contentScrollView.contentOffset = CGPoint(x: 0, y: 0)
        }
    }
    
    lazy var selBtn:UIButton = {() -> UIButton in
        var btn = UIButton.init(frame: CGRect())
//        btn.backgroundColor = .green
        return btn
    }()
    
    lazy var coinLabel:UILabel  = {() -> UILabel in
        var cLabel = UILabel.init(frame: CGRect())
        cLabel.text = ""
        cLabel.font = UIFont.systemFont(ofSize: 13)
//        cLabel.backgroundColor = .orange
        cLabel.numberOfLines = 0
        return cLabel
    }()
    
    lazy var contentScrollView: UIScrollView = {
        var scrollView = UIScrollView.init(frame: contentView.bounds)
//        scrollView.backgroundColor = .yellow
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentSize = CGSize(width: contentView.mj_w * 1.5, height: 0)
        return scrollView
    }()
    
    lazy var priceTitle: UILabel = {
        var priceTitle = UILabel.init(frame: CGRect())
        priceTitle.text = "最新价格"
        priceTitle.font = UIFont.systemFont(ofSize: 12)
        priceTitle.textColor = .gray
        return priceTitle
    }()
     
    lazy var priceLabel:UILabel = {() -> UILabel in
        var pLabel = UILabel.init(frame: CGRect())
        pLabel.text = "12345.12"
        pLabel.font = UIFont.systemFont(ofSize: 14)
        pLabel.textColor = .black
        return pLabel
    }()
    
    lazy var limitTitleLabel:UILabel = {() -> UILabel in
        var ltLabel = UILabel.init(frame: CGRect())
        ltLabel.text = "涨跌幅"
        ltLabel.font = UIFont.systemFont(ofSize: 12)
        ltLabel.textColor = UIColor.gray
        return ltLabel
    }()
    
    lazy var limitLabel: UILabel = {() -> UILabel in
        var limitLabel = UILabel.init(frame: CGRect())
        limitLabel.text = "+0.34%"
        limitLabel.font = UIFont.systemFont(ofSize: 14)
        limitLabel.textColor = .white
        limitLabel.textAlignment = .center
        return limitLabel
    }()
    
    lazy var dayVolumeTitle: UILabel = {() -> UILabel in
        var dvLabel = UILabel.init(frame: CGRect())
        dvLabel.text = "24小时成交张"
        dvLabel.font = UIFont.systemFont(ofSize: 12)
        dvLabel.textColor = .gray
        return dvLabel
    }()
    
    lazy var dayVolumeLabel: UILabel = {() -> UILabel in
        var dvLabel = UILabel.init(frame: CGRect())
        dvLabel.text = "123412312356.0999"
        dvLabel.font = UIFont.systemFont(ofSize: 14)
        dvLabel.textColor = .black
        return dvLabel
    }()
    
    lazy var timerLabel : UILabel = {() -> UILabel in
        var tlabel = UILabel.init(frame: CGRect())
        tlabel.text = "00:00"
        tlabel.font = UIFont.systemFont(ofSize: 12)
        tlabel.textColor = .gray
        return tlabel
    }()

    
    private func setUpUI() {
        contentView.addSubview(contentScrollView)
        contentScrollView.addSubview(selBtn)
        contentScrollView.addSubview(coinLabel)
        contentScrollView.addSubview(priceTitle)
        contentScrollView.addSubview(priceLabel)
        contentScrollView.addSubview(limitTitleLabel)
        contentScrollView.addSubview(limitLabel)
        contentScrollView.addSubview(dayVolumeTitle)
        contentScrollView.addSubview(dayVolumeLabel)
        contentScrollView.addSubview(timerLabel)
        setsubViewsLayout()
    }
    
    fileprivate func setsubViewsLayout() {
        
        contentScrollView.snp.makeConstraints { make in
            make.width.height.equalToSuperview()
//            make.topMargin./
//            make.topMargin.leftMargin.equalToSuperview()
        }
        selBtn.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.leftMargin.equalTo(self.contentScrollView).offset(5)
            make.topMargin.equalTo(self.contentScrollView).offset(15)
        }
        
        coinLabel.snp.makeConstraints { make in
            make.centerYWithinMargins.equalTo(selBtn)
            make.width.greaterThanOrEqualTo(60)
            make.height.equalTo(30)
            make.leftMargin.equalTo(selBtn.snp_rightMargin).offset(20)
        }
        
        priceTitle.snp.makeConstraints { make in
            make.topMargin.equalTo(contentScrollView.snp_topMargin).offset(5)
            make.leftMargin.equalTo(coinLabel.snp_rightMargin).offset(30)
            make.height.equalTo(20)
            make.width.greaterThanOrEqualTo(30)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.topMargin.equalTo(coinLabel.snp_bottomMargin).offset(5)
            make.centerXWithinMargins.equalTo(priceTitle.snp_centerX)
//            make.leftMargin.equalTo(priceTitle.snp_leftMargin)
            make.width.greaterThanOrEqualTo(30)
            make .height.equalTo(20)
        }
        
        limitTitleLabel.snp_makeConstraints { make in
            make.centerYWithinMargins.equalTo(priceTitle.snp_centerY)
            make.leftMargin.equalTo(priceTitle.snp_rightMargin).offset(80).priorityLow()
//            make.leftMargin.equalTo(priceLabel.snp_rightMargin).priorityHigh()
            make.height.equalTo(20)
            make.width.greaterThanOrEqualTo(40)
        }
        
        limitLabel.snp_makeConstraints { make in
            make.topMargin.equalTo(priceLabel.snp_topMargin)
//            make.leftMargin.equalTo(limitTitleLabel.snp_leftMargin).offset(0)
            make.centerXWithinMargins.equalTo(limitTitleLabel.snp_centerX)
            make.width.greaterThanOrEqualTo(70)
            make.height.equalTo(20)
        }
        
        dayVolumeTitle.snp.makeConstraints { make in
            make.centerYWithinMargins.equalTo(limitTitleLabel.snp_centerY)
            make.leftMargin.equalTo(limitTitleLabel.snp_rightMargin).offset(45)
            make.width.greaterThanOrEqualTo(40)
            make.height.equalTo(30)
        }
        
        dayVolumeLabel.snp.makeConstraints { make in
            make.topMargin.equalTo(limitLabel.snp_topMargin)
            make.centerXWithinMargins.equalTo(dayVolumeTitle.snp_centerX)
            make.width.greaterThanOrEqualTo(40)
            make.height.equalTo(20)
        }
        
        timerLabel.snp.makeConstraints { make in
            make.leftMargin.equalTo(coinLabel.snp_leftMargin).offset(0)
            make.topMargin.equalTo(coinLabel.snp_bottomMargin).offset(15)
            make.width.greaterThanOrEqualTo(40)
            make.height.equalTo(20)
        }
    }
     
    
   @objc public func configureTimerWithTime(noti:Notification) {
        let time = noti.object as! Int
        if time <= 0 {
            timerLabel.text = "过期"
            return
        }
        timerLabel.text = NSString.lessSecondToDay(seconds: time)
    }
    
}
