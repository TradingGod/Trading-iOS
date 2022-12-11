//
//  TGStockTopView.swift
//  TradingGodDemo
//
//  Created by 尹东博 on 2022/12/5.
//

import UIKit
import Network


@objc protocol RightScrollViewDelegate {
    func rightScrollViewDidScroll(_ rScrollView:UIScrollView, _ offSet:CGPoint)
}

@objc protocol TopFunctionViewDelegate {
    func topFunctionViewAction(_ button:UIButton)
    func topFunctionViewEditing(editing:Bool)
}


class TGStockTopView: UIView , UIScrollViewDelegate {
    fileprivate lazy var dataArr:Array<String> = []
    
    open var delegate: RightScrollViewDelegate?
    open var topViewDelegate : TopFunctionViewDelegate? 
    
    open lazy var rightScrollView:UIScrollView = {
        var sv = UIScrollView.init(frame: .zero)
        sv.contentSize = CGSize(width: 100 * dataArr.count, height: 0)
        sv.showsHorizontalScrollIndicator = false
        sv.delegate = self 
//        sv.layer.borderWidth = 1
//        sv.layer.borderColor = UIColor.red.cgColor
        return sv
    }()
    
    fileprivate lazy var editBtn:UIButton = {
        var btn = setupFuncBtn(title: "编辑", image_str: "tg_edit", action: "buttonClick:", isHidden: false)
//        if #available(iOS 15.0, *) { //高于 iOS 15.0
//            var conf = UIButton.Configuration.plain()
//            conf.imagePlacement = .trailing
//            conf.imagePadding = 5
//            btn.configuration = conf
//        } else {
//            btn.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 50, bottom: 0, right: 0)
//            btn.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 30)
//        }
        return btn
    }()
    
    fileprivate lazy var cancelBtn:UIButton = {
        var btn = setupFuncBtn(title: "取消排序", image_str: "", action: "buttonCancel:", isHidden: true)
        return btn
    }()
    
    fileprivate func setupFuncBtn(title:String, image_str:String ,action:String , isHidden: Bool) -> UIButton {
        let btn = UIButton()
        btn.titleLabel?.font = .systemFont(ofSize: 12)
//        btn.layer.borderWidth = 1
//        btn.layer.borderColor = UIColor.green.cgColor
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.addTarget(self, action: Selector((action)), for: .touchUpInside)
        btn.isHidden = isHidden
        if image_str.ch_length > 0 {
            btn.setImage(UIImage.init(named: image_str), for: .normal)
        }
        return btn
    }
       
    public init(frame: CGRect , titles:Array<String>) {
        super.init(frame: frame) 
        print("传进来的 数组 : \(titles)")
        dataArr = titles
        setupSubViews()
    }
    
    private override init(frame: CGRect){
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupSubViews() {
        self.addSubview(editBtn)
        self.addSubview(cancelBtn)
        self.addSubview(rightScrollView)
         
        editBtn.snp.makeConstraints { make in
            make.left.equalTo(self).offset(10)
            make.top.equalTo(self).offset(3)
            make.bottom.equalTo(self).offset(-3)
            make.width.equalTo(80)
        }
        
        cancelBtn.snp.makeConstraints { make in
            make.left.top.bottom.width.equalTo(editBtn)
        }
        
        rightScrollView.snp.makeConstraints { make in
            make.left.equalTo(self).offset(90);
            make.top.equalTo(self).offset(3)
            make.right.equalTo(self.snp_right).offset(0)
            make.bottom.equalTo(self.snp_bottom).offset(-3)
        }
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
        setupScrollViewItems()
    }
    
    fileprivate func setupScrollViewItems (){
        for (index,element) in dataArr.enumerated() {
            let itemView = TGStockTopItemView.init(frame: CGRect(x: index*100, y: 0, width: 100, height: Int(self.mj_h) - 6), target: self ,action: "itemBtnResponse:", title: element ,index:index)
            itemView.tag = index
            rightScrollView.addSubview(itemView)
        }
    }
      
    @objc func buttonClick(_ sender:UIButton) {
        print("编辑")
        updateEditingState(editing: true)
        topViewDelegate?.topFunctionViewEditing(editing: true)
    }
    
    @objc func buttonCancel(_ sender:UIButton) {
        print("取消")
        updateEditingState(editing: false)
        topViewDelegate?.topFunctionViewEditing(editing: false)
    }
    
    @objc func itemBtnResponse(_ sender:UIButton) {
        print(" 点击了 \(sender.tag)")
        sender.isSelected = !sender.isSelected
        
        topViewDelegate?.topFunctionViewAction(sender)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.rightScrollViewDidScroll(scrollView, scrollView.contentOffset)
    }
    
    open func updateEditingState(editing:Bool) {
        if editing {
            cancelBtn.isHidden = false
            editBtn.isHidden = true
        }else {
            cancelBtn.isHidden = true
            editBtn.isHidden = false
        }
    }
}

