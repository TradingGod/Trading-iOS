//
//  DetailViewController.swift
//  TradingGodDemo
//
//  Created by 尹东博 on 2022/11/29.
//

import UIKit

class DetailViewController: BaseViewController, CHKLineChartDelegate{
    
    var chartView: CHKLineChartView!
    
    var klineDatas = [AnyObject]()
    let times: [String] = ["5min", "15min", "1hour", "1day", "1min"] //选择时间，最后一个时分
    let exPairs: [String] = ["btc_usdt", "eth_usdt"] //选择交易对
    var selectTime: String = ""
    var selectexPair: String = ""
    
    
    lazy var topView : UIView = {() -> UIView in
        let tView = UIView.init(frame: CGRect())
        tView.backgroundColor = .red
        return tView
    }()
    
    lazy var bottomView: UIView = {() -> UIView in
        let bView = UIView.init(frame: CGRect())
        bView.backgroundColor = .green
        return bView
    }()
    
    lazy var contentView: TGLineChartView = {() -> TGLineChartView in
        let cView = TGLineChartView.init(frame: CGRect())
        cView.backgroundColor = .gray
        return cView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        view.addSubview(topView)
        view.addSubview(bottomView)
        view.addSubview(contentView)
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.yellow.cgColor
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        layoutSubview()
        
        createChartView()
        contentView.addSubview(chartView)
         
        getDataByFile()
    }

    private func layoutSubview() {
          
        topView.snp.makeConstraints { make in
            make.topMargin.equalTo(view.snp_top).offset(10)
            make.height.equalTo(50)
            make.width.equalTo(view.snp_width)
//            make.leftMargin.equalTo(view)
        }
        
        bottomView.snp.makeConstraints { make in
            make.bottomMargin.equalTo(view).offset(-34)
            make.width.equalTo(view.snp_width)
            make.height.equalTo(50)
        }
        
        contentView.snp.makeConstraints { make in
            make.topMargin.equalTo(topView.snp_bottomMargin).offset(10)
            make.bottomMargin.equalTo(bottomView.snp_topMargin).offset(-20)
            make.width.equalTo(view)
        }
        
        
        view.layoutIfNeeded()
        view.setNeedsLayout()
        
    }
    
    /**
     使用代码创建K线图表
     */
    func createChartView() {
        self.chartView = CHKLineChartView()
        self.chartView.translatesAutoresizingMaskIntoConstraints = false
        self.chartView.delegate = self
        self.chartView.style = CHKLineChartStyle.base
        self.contentView.addSubview(self.chartView)
        
        //水平布局
        self.contentView.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "H:|-0-[chartView]-0-|",
                options: NSLayoutConstraint.FormatOptions(),
                metrics: nil,
                views:["chartView": self.chartView!]))
        
        //垂直布局
        self.contentView.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:|-0-[chartView]-0-|",
                options: NSLayoutConstraint.FormatOptions(),
                metrics: nil,
                views:["chartView": self.chartView!]))
    }
    
    func getDataByFile() {
        let data = try? Data(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "data", ofType: "json")!))
        let dict = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves) as! [String: AnyObject]
        
        let isSuc = dict["isSuc"] as? Bool ?? false
        if isSuc {
            let datas = dict["datas"] as! [AnyObject]
            NSLog("chart.datas = \(datas.count)")
            self.klineDatas = datas
            self.chartView.reloadData()
        }
    }
    
    /*
     CHKLineChartDelegate
     */
    func numberOfPointsInKLineChart(chart: CHKLineChartView) -> Int {
        return klineDatas.count
    }

    func kLineChart(chart: CHKLineChartView, valueForPointAtIndex index: Int) -> CHChartItem {
        let data = self.klineDatas[index] as! [AnyObject]
        let item = CHChartItem()
        item.time = Int(data[0] as! Int / 1000)
        item.openPrice = CGFloat((data[1] as! NSNumber).floatValue)
        item.highPrice = CGFloat((data[2] as! NSNumber).floatValue)
        item.lowPrice = CGFloat((data[3] as! NSNumber).floatValue)
        item.closePrice = CGFloat((data[4] as! NSNumber).floatValue)
        item.vol = CGFloat((data[5] as! NSNumber).floatValue)
        return item
    }
//
    func kLineChart(chart: CHKLineChartView, labelOnYAxisForValue value: CGFloat, atIndex index: Int, section: CHSection) -> String {
        var strValue = ""
        if value / 10000 > 1 {
            strValue = (value / 10000).ch_toString(maxF: section.decimal) + "万"
        } else {
            strValue = value.ch_toString(maxF: section.decimal)
        }
        return strValue
    }
    
}
