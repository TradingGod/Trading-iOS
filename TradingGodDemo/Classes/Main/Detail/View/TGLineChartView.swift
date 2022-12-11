//
//  TGLineChart.swift
//  TradingGodDemo
//
//  Created by 尹东博 on 2022/11/29.
//

import UIKit

/*
 private 所修饰的属性或者方法只能在当前类里访问
 private所修饰类只能在当前.swfit 文件里访问
 
 fileprivate
 访问级别所修饰的属性或者方法在当前的swift源文件里可以访问
 
 internal （默认访问级别）
 internal 访问级别所修饰的属性或 方法在源代码所在的整个模块都可以访问、被继承、被重写
 
 public 可以被任何人王文，单他的module 中不可以被override和继承，而module内可以被override和继承
 
 open 可以被任何人使用，包括 override和继承
 访问权限 从高 到 低： open 》 public 〉 interal 》 fileprivate 〉private
 
 当前类（private）、当前swift文件（fileprivate）、当前模块（interal）、其他模块（open、public）
 属性和方法的修饰：当前模块 internal、open、、public是同一级别，在外模块pen、publick是同一级别
 
 类的访问级别：
 当前类（private）、当swift文件（fileprivate）、当前模块（internal）、其他模块（open 需要import），是否可被继承重写
 可以发现cocopods导入的第三方库，作为外模块一般都使用open、publick修饰类
 
 */


public enum TGChartViewScrollPostion {
    case top, end, none
}

public enum TGChartSelectedPosition {
    case free
    case onClosePrice
}

@objc public protocol TGKlineChartDelegate: AnyObject {
    
    /**
     数据源总数
     
     - parameter chart:
     
     - returns:
     */
    func numberOfPointsInKLineChart(chart: TGLineChartView) -> Int
    
    /**
     数据源索引为对应的对象
     
     - parameter chart:
     - parameter index: 索引位
     
     - returns: K线数据对象
     */
    func kLineChart(chart: TGLineChartView, valueForPointAtIndex index: Int) -> TGChartItem
    
    /**
     获取图表X轴的显示的内容
     
     - parameter chart:
     - parameter index:     索引位
     
     - returns:
     */
    @objc optional func kLineChart(chart: TGLineChartView, labelOnXAxisForIndex index: Int) -> String
    
    
    /**
     完成绘画图表
     
     */
    @objc optional func didFinishKLineChartRefresh(chart: TGLineChartView)
    
    /// 配置各个分区小数位保留数
    ///
    /// - parameter chart:
    /// - parameter decimalForSection: 分区
    ///
    /// - returns:
    @objc optional func kLineChart(chart: TGLineChartView, decimalAt section: Int) -> Int
    
    /// 设置y轴标签的宽度
    ///
    /// - parameter chart:
    ///
    /// - returns:
    @objc optional func widthForYAxisLabelInKLineChart(in chart:TGLineChartView) -> CGFloat
    
    /// 点击图表列响应方法
    ///
    /// - Parameters:
    ///   - chart: 图表
    ///   - index: 点击的位置
    ///   - item: 数据对象
    @objc optional func kLineChart(chart: TGLineChartView, didSelectAt index: Int, item: TGChartItem)
    
    
    /// X轴的布局高度
    ///
    /// - Parameter chart: 图表
    /// - Returns: 返回自定义的高度
    @objc optional func heightForXAxisInKLineChart(in chart: TGLineChartView) -> CGFloat
    
    
    /// 初始化时的显示范围长度
    ///
    /// - Parameter chart: 图表
    @objc optional func initRangeInKLineChart(in chart: TGLineChartView) -> Int
    
    
    /// 自定义选择点时出现的标签样式
    ///
    /// - Parameters:
    ///   - chart: 图表
    ///   - yAxis: 可给用户自定义的y轴显示标签
    ///   - viewOfXAxis: 可给用户自定义的x轴显示标签
    @objc optional func kLineChart(chart: TGLineChartView, viewOfYAxis yAxis: UILabel, viewOfXAxis: UILabel)
    
    
    /// 自定义section的头部View显示内容
    ///
    /// - Parameters:
    ///   - chart: 图表
    ///   - section: 分区的索引位
    /// - Returns: 自定义的View
    @objc optional func kLineChart(chart: TGLineChartView, viewForHeaderInSection section: Int) -> UIView?
    
//    /// 自定义section的头部View显示内容
//    ///
//    /// - Parameters:
//    ///   - chart: 图表
//    ///   - section: 分区的索引位
//    /// - Returns: 自定义的View
//    @objc optional func kLineChart(chart: TGLineChartView, titleForHeaderInSection section: CHSection, index: Int, item: CHChartItem) -> NSAttributedString?
//
//
//    /// 切换分区用分页方式展示的线组
//    ///
//    @objc optional func kLineChart(chart: TGLineChartView, didFlipPageSeries section: CHSection, series: CHSeries, seriesIndex: Int)
}
/*
 private 表示代码只能在当前作用域或者同一文件中同一类型的作用域中被使用
 filerprivate 表示可以在当前文件中被访问，而不做类型限定
 */
open class TGLineChartView: UIView { // 只有被open 标记的内容才能在别的框架中被继承或者重写
    //因此，如果你只希望框架的用户使用某个类型和方法，而不希望他们继承或者重写的话，应该用public而非open
    
}
