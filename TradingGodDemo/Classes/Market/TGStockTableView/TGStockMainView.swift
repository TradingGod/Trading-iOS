//
//  TGStockMainView.swift
//  TradingGodDemo
//
//  Created by 尹东博 on 2022/12/5.
//

import UIKit

class TGStockMainView: UIView,
                        UITableViewDelegate,
                        UITableViewDataSource,
                        UIScrollViewDelegate ,
                        RightScrollViewDelegate,
                        TopFunctionViewDelegate
{
    fileprivate lazy var topArrs : Array<String> = []
    fileprivate lazy var listArrs = Array<MainCellModel>.init()
    fileprivate lazy var oListArrs = Array<MainCellModel>.init()
    fileprivate var isEdting :Bool = false
    
    fileprivate lazy var topView: TGStockTopView = {() -> TGStockTopView in
        let topView = TGStockTopView.init(frame: CGRect(x: 0, y: 0, width: self.mj_w, height: 40.0), titles: topArrs)
        topView.backgroundColor = .white
        topView.delegate = self
        topView.topViewDelegate = self
        return topView
    }()
    
    fileprivate lazy var leftTable: UITableView = {
        let leftTable = UITableView.init(frame: CGRect(x: 0, y: 40, width: self.mj_w, height: self.mj_h - 40))
        leftTable.dataSource = self
        leftTable.delegate = self
        leftTable.separatorStyle = .none
        leftTable.showsVerticalScrollIndicator = false
        leftTable.showsHorizontalScrollIndicator = false
        leftTable.layer.borderWidth = 1
        leftTable.layer.borderColor = UIColor.red.cgColor
        leftTable.bounces = false
        leftTable.backgroundColor = .white
        return leftTable
    }()
    
    fileprivate lazy var rightTable: UITableView = {
        let rightTable = UITableView.init(frame: CGRect(x: 0, y: 0, width: self.mj_w, height: self.mj_h - 40))
        rightTable.backgroundColor = .white
        rightTable.dataSource = self
        rightTable.delegate = self
        rightTable.separatorStyle = .none
        rightTable.layer.borderWidth = 1
        rightTable.layer.borderColor = UIColor.green.cgColor
        rightTable.bounces = false
        rightTable.showsVerticalScrollIndicator = false
        rightTable.showsHorizontalScrollIndicator = false
        return rightTable
    }()
    
    fileprivate lazy var rightScrollView : UIScrollView = {
        let scv = UIScrollView.init(frame:  CGRect(x: 90, y: leftTable.mj_y, width: self.mj_w, height: self.mj_h - 40))
        scv.delegate = self
        scv.bounces = false
        scv.showsHorizontalScrollIndicator = false
        scv.showsVerticalScrollIndicator = false
        scv.backgroundColor = .white
        return scv
    }()
     
     
    public init(frame: CGRect, topArr:Array<String>) {
        super.init(frame: frame)
        topArrs = topArr
        setupSubViews()
        requestData()
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupSubViews() {
        self.addSubview(topView)
        self.addSubview(leftTable)
        self.addSubview(rightScrollView)
        rightScrollView.addSubview(rightTable)
         
        rightScrollView.contentSize.width = topView.rightScrollView.contentSize.width + topView.rightScrollView.mj_x
    }
    
    fileprivate func requestData() {
        let pathA = Bundle.main.path(forResource: "tickersData", ofType: "json")
        let url = URL(fileURLWithPath: pathA!)
        do {
            let data = try Data(contentsOf: url)
            let jsonData:Any = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
            let jsonDic = jsonData as! NSDictionary
            listArrs = NSArray.yy_modelArray(with: MainCellModel.self, json: jsonDic["data"] ?? "") as! [MainCellModel]
            oListArrs = listArrs
            leftTable.reloadData()
        } catch let error as Error? {
            print("读取本地数据出现错误!\(error)")
        }
    }
    
     
    // tableview delegate / dataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        leftTable.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        rightTable.selectRow(at: indexPath, animated: false, scrollPosition: .none)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (tableView == leftTable){
            let cellId = "stockListLeftCell"
            var cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? TGStockListLeftCell
            if cell == nil {
                cell = TGStockListLeftCell(style: .default, reuseIdentifier: cellId)
                cell?.selectionStyle = .none
            }
            cell?.model = listArrs[indexPath.row]
            cell?.layer.borderWidth = 1
            cell?.layer.borderColor = UIColor.green.cgColor
            return cell!
        }else { 
            let cellId = "stockListRightCell"
            var cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? TGStockListRightCell
            if cell == nil {
                cell = TGStockListRightCell(style: .default, reuseIdentifier: cellId)
                cell?.selectionStyle = .none
            }
            cell?.model = listArrs[indexPath.row]
            cell?.layer.borderWidth = 1
            cell?.layer.borderColor = UIColor.red.cgColor
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        leftTable.deselectRow(at: indexPath, animated: false)
        rightTable.deselectRow(at: indexPath, animated: false)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == rightScrollView {
            topView.rightScrollView.contentOffset = scrollView.contentOffset
        }else {
            leftTable.contentOffset = scrollView.contentOffset
            rightTable.contentOffset = scrollView.contentOffset
        }
    }
     
    func rightScrollViewDidScroll(_ rScrollView: UIScrollView, _ offSet: CGPoint) {
        rightScrollView.contentOffset = offSet
    }
    
    func topFunctionViewEditing(editing: Bool) {
        if isEdting {
            isEdting = false
            listArrs = oListArrs
            self.leftTable.reloadData()
            self.rightTable.reloadData()
            topView.updateEditingState(editing: isEdting)
        }
    }
    
    func topFunctionViewAction(_ button: UIButton) {
        isEdting = true
        let isSelect = button.isSelected
        topView.updateEditingState(editing: isEdting)
        if button.tag == 0 {
            listArrs =  getListArrayWithArr(listArr: listArrs, orderBy: "最新价格", isAscend: isSelect)
        }else if button.tag == 1 {
            listArrs =  getListArrayWithArr(listArr: listArrs, orderBy: "涨跌幅", isAscend: isSelect)
        }else if button.tag == 2 {
            listArrs =  getListArrayWithArr(listArr: listArrs, orderBy: "一天振幅", isAscend: isSelect)
        }else if button.tag == 3 {
            listArrs =  getListArrayWithArr(listArr: listArrs, orderBy: "一天成交张", isAscend: isSelect)
        }
        self.leftTable.reloadData()
        self.rightTable.reloadData()
    }
    
    fileprivate func systemSortMethod(listArr:Array<MainCellModel>, isAscend:Bool) -> Array<MainCellModel> {
        var arr:Array<MainCellModel> = listArr
        // swift 推荐用法
        if isAscend {
            arr = arr.sorted { m1, m2 in
                m1.last_f! > m2.last_f!
            }
        }else {
            arr = arr.sorted { m1, m2 in
                m1.last_f! < m2.last_f!
            }
        }
        return arr
    }
    
    fileprivate func bubbleSortMethod(listArr:Array<MainCellModel>, isAscend:Bool) -> Array<MainCellModel> {
        var arr:Array<MainCellModel> = listArr
        // 冒泡排序
        for i in 0..<(arr.count-1) {
            for j in 0..<(arr.count-i-1) {
                let model_j = arr[j]
                let model_j_next = arr[j+1]
                let curV = Double(model_j.rise_rate_f!)
                let nextV = Double(model_j_next.rise_rate_f!)
                arr = ascendDataArr(dataArr: arr, curV: curV, nextV: nextV, curIdx: j, nextIdx: j+1, isAscend: isAscend)
            }
        }
        return arr
    }
    
    fileprivate func getListArrayWithArr(listArr:Array<MainCellModel>, orderBy:String, isAscend:Bool) -> Array<MainCellModel> {
        var arr:Array<MainCellModel> = listArr
        
        if orderBy == "最新价格" { // swift 推荐用法
            arr = systemSortMethod(listArr: arr, isAscend: isAscend)
        }else if orderBy == "涨跌幅" {
            arr = bubbleSortMethod(listArr: arr, isAscend: isAscend)
        } else {
            for i in 0..<(arr.count-1) { // 随便写个冒泡
                for j in 0..<(arr.count-i-1) {
                    let model_j = arr[j]
                    let model_j_next = arr[j+1]
                    var curV = 0.0
                    var nextV = 0.0
                    if orderBy == "一天成交张" {
                        curV = model_j.vol24h_d
                        nextV = model_j_next.vol24h_d
                    }else if orderBy == "一天振幅"{
                        curV = Double(model_j.rise_rate_f!)
                        nextV = Double(model_j_next.rise_rate_f!)
                    }
                    arr = ascendDataArr(dataArr: arr, curV: curV, nextV: nextV, curIdx: j, nextIdx: j+1, isAscend: isAscend)
                }
            }
        }
        return arr
    }
    
    fileprivate func ascendDataArr(dataArr:Array<MainCellModel>,curV:Double,nextV:Double,curIdx:Int,nextIdx:Int,isAscend:Bool) -> Array<MainCellModel> {
        var arr:Array<MainCellModel> = dataArr
        if isAscend {
            if curV > nextV {
                arr.swapAt(curIdx, nextIdx)
            }
        }else
        {
            if curV < nextV {
                arr.swapAt(curIdx, nextIdx)
            }
        }
        return arr
    }
}
