//
//  TGKLinePainterView.swift
//  TradingGodDemo
//
//  Created by 尹东博 on 2022/12/8.
//

import UIKit



class TGKLinePainterView: UIView {
    var datas: [TGKLineModel] = [] {
        didSet {
            setNeedsDisplay()
        }
    }

    var scrollX: CGFloat = 0 {
        didSet {
            self.setNeedsDisplay()
        }
    }

    // 距离右边的距离
    var startX: CGFloat = 0
    var isLine = false {
        didSet {
            setNeedsDisplay()
        }
    }

    var scaleX: CGFloat = 1.0 {
        didSet {
            self.candleWidth = scaleX * ChartStyle.candleWidth
            self.setNeedsDisplay()
        }
    }

    var isLongPress: Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }

    var longPressX: CGFloat = 0

    var mainRect: CGRect!
    var volRect: CGRect?
    var secondaryRect: CGRect?
    var dateRect: CGRect!

    var mainState: TGMainState = .none {
        didSet {
            setNeedsDisplay()
        }
    }

    var volState: TGVolState = .vol {
        didSet {
            setNeedsDisplay()
        }
    }

    var secondaryState: TGSecondaryState = .none {
        didSet {
            setNeedsDisplay()
        }
    }

    var displayHeight: CGFloat = 0

    var mainRenderer: MainChartRenderer!
    var volRenderer: VolChartRenderer?
    var seconderyRender: SecondaryChartRenderer?

    // 需要绘制的开始和结束下标
    var startIndex: Int = 0
    var stopIndex: Int = 0

    var mMainMaxIndex: Int = 0
    var mMainMinIndex: Int = 0

    var mMainMaxValue: CGFloat = 0
    var mMainMinValue: CGFloat = CGFloat(MAXFLOAT)

    var mVolMaxValue: CGFloat = -CGFloat(MAXFLOAT)
    var mVolMinValue: CGFloat = CGFloat(MAXFLOAT)

    var mSecondaryMaxValue: CGFloat = -CGFloat(MAXFLOAT)
    var mSecondaryMinValue: CGFloat = CGFloat(MAXFLOAT)

    var mMainHighMaxValue: CGFloat = -CGFloat(MAXFLOAT)
    var mMainLowMinValue: CGFloat = CGFloat(MAXFLOAT)

    var fromat: String = "yyyy-MM-dd"

    var showInfoBlock: ((TGKLineModel, Bool) -> Void)?

    var candleWidth: CGFloat!

    var direction: TGKLineDirection = .vertical

    var fuzzylayer: CALayer = {
        let layer = CALayer()
        layer.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        layer.backgroundColor = UIColor.rgb(r: 0, 0, 0, alpha: 0.3).cgColor
        layer.cornerRadius = 10
        layer.masksToBounds = true
        return layer
    }()

    init(frame: CGRect, datas: [TGKLineModel], scrollX: CGFloat, isLine: Bool, scaleX: CGFloat, isLongPress: Bool, mainState: TGMainState, secondaryState: TGSecondaryState) {
        super.init(frame: frame)
        self.datas = datas
        self.scrollX = scrollX
        self.isLine = isLine
        self.scaleX = scaleX
        self.isLongPress = isLongPress
        self.mainState = mainState
        self.secondaryState = secondaryState
        candleWidth = self.scaleX * ChartStyle.candleWidth
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        displayHeight = rect.height - ChartStyle.topPadding - ChartStyle.bottomDateHigh
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        divisionRect()
        calculateValue()
//        calculateFormats()
        initRenderer()
        drawBgColor(context: context, rect: rect)
        drawGrid(context: context)
        if datas.count == 0 { return }
        drawChart(context: context)
        drawRightText(context: context)
//        drawDate(context: context)
        drawMaxAndMin(context: context)
        if isLongPress {
            drawLongPressCrossLine(context: context)
        } else {
            drawTopText(context: context, curPoint: datas.first!)
        }
//        drawRealTimePrice(context: context)
        UIGraphicsPopContext()
    }

    func calculateValue() {
        if datas.count == 0 { return }
        let itemWidth = candleWidth + ChartStyle.canldeMargin
        if scrollX <= 0 {
            startX = -scrollX
            startIndex = 0
        } else {
            let start: CGFloat = scrollX / itemWidth
            var offsetX: CGFloat = 0
            if floor(start) == ceil(start) {
                startIndex = Int(floor(start))
            } else {
                startIndex = Int(floor(scrollX / itemWidth))
                offsetX = CGFloat(startIndex) * CGFloat(itemWidth) - scrollX
            }
            startX = offsetX
        }
        let diffIndex = Int(ceil((frame.width - startX) / itemWidth))
        stopIndex = min(startIndex + diffIndex, datas.count - 1)
        mMainMaxValue = 0
        mMainMinValue = CGFloat(MAXFLOAT)
        mMainHighMaxValue = -CGFloat(MAXFLOAT)
        mMainLowMinValue = CGFloat(MAXFLOAT)
        mVolMaxValue = -CGFloat(MAXFLOAT)
        mVolMinValue = CGFloat(MAXFLOAT)
        mSecondaryMaxValue = -CGFloat(MAXFLOAT)
        mSecondaryMinValue = CGFloat(MAXFLOAT)
        for i in startIndex ... stopIndex {
            let item = datas[i]
            getMianMaxMinValue(item: item, i: i)
            getVolMaxMinValue(item: item)
            getSecondaryMaxMinValue(item: item)
        }
    }

    func drawChart(context: CGContext) {
        for index in startIndex ... stopIndex {
            
            let curpoint = datas[index]
            let itemWidth = candleWidth + ChartStyle.canldeMargin
            let curX = CGFloat(index - startIndex) * itemWidth + startX
            let _curX = frame.width - curX - candleWidth / 2
            var lastPoint: TGKLineModel?
            if index != startIndex {
                lastPoint = datas[index - 1]
            }
            mainRenderer.drawChart(context: context, lastPoint: lastPoint, curPoint: curpoint, curX: _curX)
            volRenderer?.drawChart(context: context, lastPoint: lastPoint, curPoint: curpoint, curX: _curX)
//            seconderyRender?.drawChart(context: context, lastPoint: lastPoint, curPoint: curpoint, curX: _curX)
        }
    }

    func drawRightText(context: CGContext) {
        mainRenderer.drawRightText(context: context, gridRows: ChartStyle.gridRows, gridColums: ChartStyle.gridColumns)
        volRenderer?.drawRightText(context: context, gridRows: ChartStyle.gridRows, gridColums: ChartStyle.gridColumns)
//        seconderyRender?.drawRightText(context: context, gridRows: ChartStyle.gridRows, gridColums: ChartStyle.gridColumns)
    }

    func drawTopText(context: CGContext, curPoint: TGKLineModel) {
        mainRenderer.drawTopText(context: context, curPoint: curPoint)
        volRenderer?.drawTopText(context: context, curPoint: curPoint)
//        seconderyRender?.drawTopText(context: context, curPoint: curPoint)
    }

    func drawBgColor(context: CGContext, rect: CGRect) {
        context.setFillColor(ChartColors.bgColor.cgColor)
        context.fill(rect)
        mainRenderer.drawBg(context: context)
        volRenderer?.drawBg(context: context)
//        seconderyRender?.drawBg(context: context)
    }

    func drawGrid(context: CGContext) {
        context.setStrokeColor(ChartColors.gridColor.cgColor)
        context.setLineWidth(1)
        context.addRect(bounds)
        context.drawPath(using: CGPathDrawingMode.stroke)
        mainRenderer.drawGrid(context: context, gridRows: ChartStyle.gridRows, gridColums: ChartStyle.gridColumns)
        volRenderer?.drawGrid(context: context, gridRows: ChartStyle.gridRows, gridColums: ChartStyle.gridColumns)
//        seconderyRender?.drawGrid(context: context, gridRows: ChartStyle.gridRows, gridColums: ChartStyle.gridColumns)
    }

    func drawDate(context _: CGContext) {
        let columSpace = frame.width / CGFloat(ChartStyle.gridColumns)
        for i in 0 ..< ChartStyle.gridColumns {
            let index = calculateIndex(selectX: CGFloat(i) * columSpace)
            if outRangeIndex(index) { continue }
            let data = datas[index]

            let dateStr = calculateDateText(timestamp: data.ts, dateFormat: fromat) as NSString
            let rect = calculateTextRect(text: dateStr as String, fontSize: ChartStyle.bottomDatefontSize)
            let y = dateRect.minY + (ChartStyle.bottomDateHigh - rect.height) / 2
            dateStr.draw(at: CGPoint(x: CGFloat(columSpace * CGFloat(i)) - rect.width / 2, y: y), withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: ChartStyle.bottomDatefontSize), NSAttributedString.Key.foregroundColor: ChartColors.bottomDateTextColor])
        }
    }

    func drawLongPressCrossLine(context: CGContext) {
        let index = calculateIndex(selectX: longPressX)
        if outRangeIndex(index) { return }
        let point = datas[index]
        let itemWidth = candleWidth + ChartStyle.canldeMargin
        let curX = frame.width - (CGFloat(index - startIndex) * itemWidth + startX + candleWidth / 2)

        context.setStrokeColor(ChartColors.crossHlineColor.cgColor)
        context.setLineWidth(candleWidth)
        context.move(to: CGPoint(x: curX, y: 0))
        context.addLine(to: CGPoint(x: curX, y: frame.height - ChartStyle.bottomDateHigh))
        context.drawPath(using: CGPathDrawingMode.fillStroke)

        let y = mainRenderer.getY(point.c)

        context.setStrokeColor(UIColor.white.cgColor)
        context.setLineWidth(0.5)
        context.move(to: CGPoint(x: 0, y: y))
        context.addLine(to: CGPoint(x: frame.width, y: y))
        context.drawPath(using: CGPathDrawingMode.fillStroke)

        context.setFillColor(UIColor.white.cgColor)
        context.addArc(center: CGPoint(x: curX, y: y), radius: 2, startAngle: 0, endAngle: CGFloat(Double.pi * 2), clockwise: true)
        context.drawPath(using: CGPathDrawingMode.fillStroke)
        drawLongPressCrossLineText(context: context, curPoint: point, curX: curX, y: y)
    }

    func drawLongPressCrossLineText(context: CGContext, curPoint: TGKLineModel, curX: CGFloat, y: CGFloat) {
        let text = String(format: "%.2f", curPoint.c)
        let rect = calculateTextRect(text: text, fontSize: ChartStyle.defaultTextSize)
        let padding: CGFloat = 3
        let textHeight = rect.height + padding * 2
        let textWidth = rect.width
        var isLeft = false
        if curX > frame.width / 2 {
            isLeft = true
            context.move(to: CGPoint(x: frame.width, y: y - textHeight / 2))
            context.addLine(to: CGPoint(x: frame.width, y: y + textHeight / 2))
            context.addLine(to: CGPoint(x: frame.width - textWidth, y: y + textHeight / 2))
            context.addLine(to: CGPoint(x: frame.width - textWidth - 10, y: y))
            context.addLine(to: CGPoint(x: frame.width - textWidth, y: y - textHeight / 2))
            context.addLine(to: CGPoint(x: frame.width, y: y - textHeight / 2))
            context.setLineWidth(1)
            context.setStrokeColor(ChartColors.markerBorderColor.cgColor)
            context.setFillColor(ChartColors.markerBgColor.cgColor)
            context.drawPath(using: CGPathDrawingMode.fillStroke)
            (text as NSString).draw(at: CGPoint(x: frame.width - textWidth - 2, y: y - rect.height / 2), withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: ChartStyle.defaultTextSize), NSAttributedString.Key.foregroundColor: UIColor.white])
        } else {
            isLeft = false
            context.move(to: CGPoint(x: 0, y: y - textHeight / 2))
            context.addLine(to: CGPoint(x: 0, y: y + textHeight / 2))
            context.addLine(to: CGPoint(x: textWidth, y: y + textHeight / 2))
            context.addLine(to: CGPoint(x: textWidth + 10, y: y))
            context.addLine(to: CGPoint(x: textWidth, y: y - textHeight / 2))
            context.addLine(to: CGPoint(x: 0, y: y - textHeight / 2))
            context.setLineWidth(1)
            context.setStrokeColor(ChartColors.markerBorderColor.cgColor)
            context.setFillColor(ChartColors.markerBgColor.cgColor)
            context.drawPath(using: CGPathDrawingMode.fillStroke)
            (text as NSString).draw(at: CGPoint(x: 2, y: y - rect.height / 2), withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: ChartStyle.defaultTextSize), NSAttributedString.Key.foregroundColor: UIColor.white])
        }
//        let dateText = calculateDateText(timestamp: curPoint.ts, dateFormat: fromat)
//        let dateRect = calculateTextRect(text: dateText, fontSize: ChartStyle.defaultTextSize)
//        let datepadding: CGFloat = 3
//        context.setStrokeColor(UIColor.white.cgColor)
//        context.setFillColor(ChartColors.bgColor.cgColor)
//        context.addRect(CGRect(x: curX - dateRect.width / 2 - datepadding, y: self.dateRect.minY, width: dateRect.width + 2 * datepadding, height: dateRect.height + datepadding * 2))
//        context.drawPath(using: CGPathDrawingMode.fillStroke)
//        (dateText as NSString).draw(at: CGPoint(x: curX - dateRect.width / 2, y: self.dateRect.minY + datepadding), withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: ChartStyle.defaultTextSize), NSAttributedString.Key.foregroundColor: UIColor.white])

        showInfoBlock?(curPoint, isLeft)
        drawTopText(context: context, curPoint: curPoint)
    }

    func drawMaxAndMin(context _: CGContext) {
        if isLine { return }
        let itemWidth = candleWidth + ChartStyle.canldeMargin
        let y1 = mainRenderer.getY(mMainHighMaxValue)
        let x1 = frame.width - (CGFloat(mMainMaxIndex - startIndex) * itemWidth + startX + candleWidth / 2)
        if x1 < frame.width / 2 {
            let text = "——" + String(format: "%.2f", mMainHighMaxValue)
            let rect = calculateTextRect(text: text, fontSize: ChartStyle.defaultTextSize)
            (text as NSString).draw(at: CGPoint(x: x1, y: y1 - rect.height / 2), withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: ChartStyle.defaultTextSize), NSAttributedString.Key.foregroundColor: UIColor.white])
        } else {
            let text = String(format: "%.2f", mMainHighMaxValue) + "——"
            let rect = calculateTextRect(text: text, fontSize: ChartStyle.defaultTextSize)
            (text as NSString).draw(at: CGPoint(x: x1 - rect.width, y: y1 - rect.height / 2), withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: ChartStyle.defaultTextSize), NSAttributedString.Key.foregroundColor: UIColor.white])
        }
        let y2 = mainRenderer.getY(mMainLowMinValue)
        let x2 = frame.width - (CGFloat(mMainMinIndex - startIndex) * itemWidth + startX + candleWidth / 2)
        if x2 < frame.width / 2 {
            let text = "——" + String(format: "%.2f", mMainLowMinValue)
            let rect = calculateTextRect(text: text, fontSize: ChartStyle.defaultTextSize)
            (text as NSString).draw(at: CGPoint(x: x2, y: y2 - rect.height / 2), withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: ChartStyle.defaultTextSize), NSAttributedString.Key.foregroundColor: UIColor.white])
        } else {
            let text = String(format: "%.2f", mMainLowMinValue) + "——"
            let rect = calculateTextRect(text: text, fontSize: ChartStyle.defaultTextSize)
            (text as NSString).draw(at: CGPoint(x: x2 - rect.width, y: y2 - rect.height / 2), withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: ChartStyle.defaultTextSize), NSAttributedString.Key.foregroundColor: UIColor.white])
        }
    }

    func drawRealTimePrice(context: CGContext) {
        guard let point = datas.first else { return }
        let text = String(format: "%.2f", point.c)
        let fontSize: CGFloat = 10
        let rect = calculateTextRect(text: text, fontSize: fontSize)
        var y = mainRenderer.getY(point.c)
        if point.c > mMainMaxValue {
            y = mainRenderer.getY(mMainMaxValue)
        } else if point.c < mMainMinValue {
            y = mainRenderer.getY(mMainMinValue)
        }
        if (-scrollX - rect.width) > 0 {
            context.setStrokeColor(ChartColors.realTimeLongLineColor.cgColor)
            context.setLineWidth(0.5)
            context.setLineDash(phase: 0, lengths: [5, 5])
            context.move(to: CGPoint(x: frame.width + scrollX, y: y))
            context.addLine(to: CGPoint(x: frame.width, y: y))
            context.drawPath(using: CGPathDrawingMode.stroke)

            context.addRect(CGRect(x: frame.width - rect.width, y: y - rect.height / 2, width: rect.width, height: rect.height))
            context.setFillColor(ChartColors.bgColor.cgColor)
            context.drawPath(using: CGPathDrawingMode.fill)
            (text as NSString).draw(at: CGPoint(x: frame.width - rect.width, y: y - rect.height / 2), withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize), NSAttributedString.Key.foregroundColor: ChartColors.reightTextColor])
            if isLine {
                context.setFillColor(UIColor.white.cgColor)
                context.addArc(center: CGPoint(x: frame.width + scrollX - candleWidth / 2, y: y), radius: 2, startAngle: 0, endAngle: CGFloat(Double.pi * 2.0), clockwise: true)
                context.drawPath(using: CGPathDrawingMode.fill)

                context.setFillColor(UIColor(white: 255, alpha: 0.3).cgColor)
                context.addArc(center: CGPoint(x: frame.width + scrollX - candleWidth / 2, y: y), radius: 6, startAngle: 0, endAngle: CGFloat(Double.pi * 2.0), clockwise: true)
                context.drawPath(using: CGPathDrawingMode.fill)
            }
        } else {
            context.setStrokeColor(ChartColors.realTimeLongLineColor.cgColor)
            context.setLineWidth(0.5)
            context.setLineDash(phase: 0, lengths: [10, 5])
            context.move(to: CGPoint(x: 0, y: y))
            context.addLine(to: CGPoint(x: frame.width, y: y))
            context.drawPath(using: CGPathDrawingMode.stroke)

            let r: CGFloat = 8
            let w: CGFloat = rect.width + 16
            context.setLineWidth(0.8)
            context.setLineDash(phase: 0, lengths: [])
            context.setFillColor(ChartColors.bgColor.cgColor)
            context.move(to: CGPoint(x: frame.width * 0.8, y: y - r))
            let curX = frame.width * 0.8
            let arcRect = CGRect(x: curX - w / 2, y: y - r, width: w, height: 2 * r)
            let minX = arcRect.minX
            let midX = arcRect.midX
            let maxX = arcRect.maxX

            let minY = arcRect.minY
            let midY = arcRect.midY
            let maxY = arcRect.maxY
            context.move(to: CGPoint(x: minX, y: midY))
            context.addArc(tangent1End: CGPoint(x: minX, y: minY), tangent2End: CGPoint(x: midX, y: minY), radius: r)
            context.addArc(tangent1End: CGPoint(x: maxX, y: minY), tangent2End: CGPoint(x: maxX, y: midY), radius: r)
            context.addArc(tangent1End: CGPoint(x: maxX, y: maxY), tangent2End: CGPoint(x: midX, y: maxY), radius: r)
            context.addArc(tangent1End: CGPoint(x: minX, y: maxY), tangent2End: CGPoint(x: minX, y: midY), radius: r)
            context.closePath()
            context.drawPath(using: CGPathDrawingMode.fillStroke)

            let _startX = arcRect.maxX - 4
            context.setFillColor(ChartColors.reightTextColor.cgColor)
            context.move(to: CGPoint(x: _startX, y: y))
            context.addLine(to: CGPoint(x: _startX - 3, y: y - 3))
            context.addLine(to: CGPoint(x: _startX - 3, y: y + 3))
            context.closePath()
            context.drawPath(using: CGPathDrawingMode.fill)
            (text as NSString).draw(at: CGPoint(x: curX - rect.width / 2 - 4, y: y - rect.height / 2), withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize), NSAttributedString.Key.foregroundColor: ChartColors.reightTextColor])
        }
    }

    func initRenderer() {
        mainRenderer = MainChartRenderer(maxValue: mMainMaxValue, minValue: mMainMinValue, chartRect: mainRect, candleWidth: candleWidth, topPadding: ChartStyle.topPadding, isLine: isLine, state: mainState)
        if let rect = volRect {
            volRenderer = VolChartRenderer(maxValue: mVolMaxValue, minValue: mVolMinValue, chartRect: rect, candleWidth: candleWidth, topPadding: ChartStyle.childPadding)
        } else {
            volRenderer = nil
        }
//        if let rect = secondaryRect {
//            seconderyRender = SecondaryChartRenderer(maxValue: mSecondaryMaxValue, minValue: mSecondaryMinValue, chartRect: rect, candleWidth: candleWidth, topPadding: ChartStyle.childPadding, state: secondaryState)
//        } else {
//            seconderyRender = nil
//        }
    }

    // 区分三大区域
    func divisionRect() {
        volRect = nil
        secondaryRect = nil
        var mainHeight = displayHeight * 0.8
        let volHeight = displayHeight * 0.2
        let secondaryHeight = displayHeight * 0.2
        if volState == .none && secondaryState == .none {
            mainHeight = displayHeight
        } else if volState == .none || secondaryState == .none {
            mainHeight = displayHeight * 0.8
        }
        mainRect = CGRect(x: 0, y: ChartStyle.topPadding, width: frame.width, height: mainHeight)
        if direction == .horizontal {
            dateRect = CGRect(x: 0, y: mainRect.maxY, width: frame.width, height: ChartStyle.bottomDateHigh)
            if volState != .none {
                volRect = CGRect(x: 0, y: dateRect.maxY, width: frame.width, height: volHeight)
            }
            if secondaryState != .none {
                secondaryRect = CGRect(x: 0, y: volRect?.maxY ?? 0, width: frame.width, height: secondaryHeight)
            }
        } else {
            if volState != .none {
                volRect = CGRect(x: 0, y: mainRect.maxY, width: frame.width, height: volHeight)
            }
            if secondaryState != .none {
                secondaryRect = CGRect(x: 0, y: volRect?.maxY ?? 0, width: frame.width, height: secondaryHeight)
            }
            dateRect = CGRect(x: 0, y: displayHeight + ChartStyle.topPadding, width: frame.width, height: ChartStyle.bottomDateHigh)
        }
    }

    func getMianMaxMinValue(item: TGKLineModel, i: Int) {
        if isLine == true {
            mMainMaxValue = max(mMainMaxValue, item.c)
            mMainMinValue = min(mMainMinValue, item.c)
        } else {
            var maxPrice = item.h
            var minPrice = item.l
            if mainState == TGMainState.ma {
                if item.MA5Price != 0 {
                    maxPrice = max(maxPrice, item.MA5Price)
                    minPrice = min(minPrice, item.MA5Price)
                }
                if item.MA10Price != 0 {
                    maxPrice = max(maxPrice, item.MA10Price)
                    minPrice = min(minPrice, item.MA10Price)
                }
                if item.MA20Price != 0 {
                    maxPrice = max(maxPrice, item.MA20Price)
                    minPrice = min(minPrice, item.MA20Price)
                }
                if item.MA30Price != 0 {
                    maxPrice = max(maxPrice, item.MA30Price)
                    minPrice = min(minPrice, item.MA30Price)
                }
            } else if mainState == TGMainState.boll {
                if item.up != 0 {
                    maxPrice = max(item.up, item.h)
                }
                if item.dn != 0 {
                    minPrice = min(item.dn, item.l)
                }
            }
            mMainMaxValue = max(mMainMaxValue, maxPrice)
            mMainMinValue = min(mMainMinValue, minPrice)

            if mMainHighMaxValue < item.h {
                mMainHighMaxValue = item.h
                mMainMaxIndex = i
            }
            if mMainLowMinValue > item.l {
                mMainLowMinValue = item.l
                mMainMinIndex = i
            }
        }
    }

    func getVolMaxMinValue(item: TGKLineModel) {
        mVolMaxValue = max(mVolMaxValue, max(item.vol, max(item.MA5Volume, item.MA10Volume)))
        mVolMinValue = min(mVolMinValue, min(item.vol, min(item.MA5Volume, item.MA10Volume)))
    }

    func getSecondaryMaxMinValue(item: TGKLineModel) {
        if secondaryState == TGSecondaryState.macd {
            mSecondaryMaxValue = max(mSecondaryMaxValue, max(item.macd, max(item.dif, item.dea)))
            mSecondaryMinValue = min(mSecondaryMinValue, min(item.macd, min(item.dif, item.dea)))
        } else if secondaryState == TGSecondaryState.kdj {
            mSecondaryMaxValue = max(mSecondaryMaxValue, max(item.k, max(item.d, item.j)))
            mSecondaryMinValue = min(mSecondaryMinValue, min(item.k, min(item.d, item.j)))
        } else if secondaryState == TGSecondaryState.rsi {
            mSecondaryMaxValue = max(mSecondaryMaxValue, item.rsi)
            mSecondaryMinValue = min(mSecondaryMinValue, item.rsi)
        } else {
            mSecondaryMaxValue = max(mSecondaryMaxValue, item.r)
            mSecondaryMinValue = min(mSecondaryMinValue, item.r)
        }
    }

//    func calculateFormats() {
//        if datas.count < 2 { return }
//        let fristTime = datas.first?.ts ?? 0
//        let secondTime = datas[1].ts
//        let time = abs(fristTime - secondTime)
//        if time >= 24 * 60 * 60 * 28 {
//            fromat = "yyyy-MM"
//        } else if time >= 24 * 60 * 60 {
//            fromat = "yyyy-MM-dd"
//        } else {
//            fromat = "MM-dd HH:mm"
//        }
//    }

    func calculateIndex(selectX: CGFloat) -> Int {
        let index = Int((frame.width - startX - selectX) / (candleWidth + ChartStyle.canldeMargin)) + startIndex
        return index
    }

    func outRangeIndex(_ index: Int) -> Bool {
        if index < 0 || index >= datas.count {
            return true
        } else {
            return false
        }
    }
}
