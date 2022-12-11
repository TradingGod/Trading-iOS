//
//  TGDropListView.swift
//  TradingGodDemo
//
//  Created by 尹东博 on 2022/12/7.
//

import UIKit

class TGDropListView: UIView {
    
    fileprivate var cellId = "cellid"
    lazy var titlaArray = [String]()
    lazy var tableArray = [String]()
     
    var selectClosure:((_ tag:Int,_ row:Int)->Void)?
    
    lazy var dropListMaskView:UIView = {
        let screen_width = UIScreen.main.bounds.width
        let screent_height = UIScreen.main.bounds.height
        let mask = UIView.init(frame: CGRect(x: 0, y: 40, width: screen_width, height: screent_height - 40 - kNaviHeight))
        mask.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapAction))
        mask.addGestureRecognizer(tap)
        return mask
    }()
    
    @objc func tapAction() {
                for i in 0..<self.tableArray.count{
                    let tableView = self.viewWithTag(100+i) as! UITableView
                    let drop = self.viewWithTag(1000+i) as! TGDropListView
                    
                    if tableView.frame.height>1{
//                        drop.isSelected = false
//                        UIView.animate(withDuration: 0.2, animations: {
//                            tableView.frame = CGRect.init(x: 0, y: 40, width: screenWidth, height: 1)
//                            self.maskViewSS?.alpha = 0
//                        }, completion: { (idCom) in
//                            self.dropListMaskView?.removeFromSuperview()
//                        }) 
                    }
                }
            }
    

}
