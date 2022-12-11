//
//  TGSection.swift
//  TradingGodDemo
//
//  Created by 尹东博 on 2022/11/29.
//

import UIKit

public enum TGSectionValueType {
    case master
    case assistant
}


open class TGSection: NSObject {
    /// MARK: - 成员变量
    open var upColor: UIColor = UIColor.green     //升的颜色
    open var downColor: UIColor = UIColor.red     //跌的颜色
    open var titleColor: UIColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1) //文字颜色
    open var labelFont = UIFont.systemFont(ofSize: 10)
    open var valueType: TGSectionValueType = TGSectionValueType.master
    open var key = ""
    open var name: String = ""                              //区域的名称
    open var hidden: Bool = false
    open var paging: Bool = false
    open var selectedIndex: Int = 0
    open var padding: UIEdgeInsets = UIEdgeInsets.zero
    open var series = [TGSeries]()                          //每个分区包含多组系列，每个系列包含多个点线模型
    open var tickInterval: Int = 0
    open var title: String = ""                                      //标题
    open var titleShowOutSide: Bool = false                          //标题是否显示在外面
    open var showTitle: Bool = true                                 //是否显示标题文本
    open var decimal: Int = 2                                        //小数位的长度
    open var ratios: Int = 0                                         //所占区域比例
    open var fixHeight: CGFloat = 0                                 //固定高度，为0则通过ratio计算高度
    open var frame: CGRect = CGRect.zero
    
    /* 重载构造函数
     1. 遍历构造函数允许返回 nil
      - 正常的构造函数一定创建对象
      -  判断给定的参数是否符合条件，如果不符合条件、直接返回nil，不会创建对象，减少内存开销！
     2. 只有便利构造函数中使用 self.init 构造当前对象
     -没有convenience 关键字的构造函数是负责创建对象的，反之用来检查条件的，本身不负责对象的创建
     3. 如果要在遍历构造函数中使用，当前对象的属性，一定要在self。init之后
     */
    convenience init?(valueType:TGSection, key:String = "") {
        self.init()
        
    }
}
