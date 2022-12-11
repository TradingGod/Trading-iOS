//
//  MainCellModel.swift
//  SwiftDemo
//
//  Created by 尹东博 on 2022/11/26.
//

import UIKit 
import YYModel

/*
 askPx = "0.3773";
 askSz = 141;
 bidPx = "0.3765";
 bidSz = 70;
 high24h = "0.3821";
 instId = "BNT-USDT-SWAP";
 instType = SWAP;
 last = "0.377";
 lastSz = 11;
 low24h = "0.3676";
 open24h = "0.3729";
 sodUtc0 = "0.3713";
 sodUtc8 = "0.3727";
 ts = 1669552155307;
 vol24h = 101509;
 volCcy24h = 1015090;
 */
 
@objcMembers
class MainCellModel: NSObject,YYModel {
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
    var is_rise : Bool = false
//    var rise_rate : Float = 0.0
    var rise_rate_str: String?{
        get {
            let open24h_f: Float = Float(open24h) ?? 0.0
            let last_f : Float = Float(last) ?? 0.0
            let rise_rate:Float = ((last_f - open24h_f) / open24h_f) //Float(model!.open24h) - Float(model?.last)
            return  String(format: "%.3f", rise_rate)
        }
    }
    
    var rise_rate_f: Float? {
        get {
            return Float(rise_rate_str ?? "0")
        }
    }
    
    var rise_rate_percent : String? {
        get {
            let percent_f = rise_rate_f! * 100
            return String(format: "%.1f%%", percent_f)
        }
    }
    
    var range_str: String? {
        get {
            let hight24h_f = Float(high24h) ?? 0.0
            let low24h_f = Float(low24h) ?? 0.0
            let open_f = Float(open24h) ?? 0.0
            let up_range = (hight24h_f - open_f) / open_f
            let down_range = (open_f - low24h_f) / open_f
            let range = up_range + down_range
            return String(format: "%.3f", range)
        }
    }
    
    var range_f : Float? {
        get {
            return Float(range_str ?? "0")
        }
    }
    
    var last_f : Float? {
        get {
            return Float(last) ?? 0.0
        }
    }
    
    var vol24h_d :Double! {
        get {
            return Double(vol24h) ?? 0.0
        }
    }
    
    var vol24h_w_str: String? {
        let vol = vol24h_d! / 10000
        return String(format: "%.2f万", arguments: [vol])
    }
     
    
    override init() {
        super.init()
    }
    
    required convenience init?(coder aDecoder:NSCoder) {
        self.init()
        self.yy_modelInit(with: aDecoder)
    }
    
    override func yy_modelEncode(with aCoder: NSCoder) {
        self.yy_modelEncode(with: aCoder)
    }
    
//    rise_rate {
//        get {
//            return
//        }
//        set{
////            let open24h_f: Float = Float(open24h) ?? 0.0
////            let last_f : Float = Float(last) ?? 0.0
////            let rise_rate:Float = ((open24h_f - last_f) / open24h_f) //Float(model!.open24h) - Float(model?.last)
//
//        }
//    }
}



    
    
//    init(dic:[String: AnyObject]) {
//        super.init() //给属性分配控件
//        setValuesForKeys(dic)
//    }
    
//    override class func setValue(_ value: Any?, forUndefinedKey key: String) {
//
//    }
//
//    class func dict2Model(list: [String: AnyObject]) -> [MainCellModel] {
//        var models = [MainCellModel]()
//        for dict in list {
////            models.append(MainCellModel(dic: dict))
//        }
//        return models
//    }
//
//    var properties = ["index","selTag","coinLabel","coinDesc","price","priceLimit","marketValue"]
//    override var description:String {
//        let dict = dictionaryWithValues(forKeys: properties)
//        return "\(dict)"
//    }
//}
