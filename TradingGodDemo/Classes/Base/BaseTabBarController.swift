//
//  BaseTabBarController.swift
//  SwiftDemo
//
//  Created by 尹东博 on 2022/11/25.
//
 
import UIKit
import Foundation

class BaseTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupItemTitleTextAttributes();
        setupChildViewControllers();
    }
    
    func setupChildViewControllers() {
        setupOneChildViewController(childVc: MainViewController(), title: "tab1_main", image: "tab1", selectedImage: "tab1_select")
        setupOneChildViewController(childVc: MarketViewController(), title: "tab2_market", image: "tab2", selectedImage: "tab2_select")
        setupOneChildViewController(childVc: OtherViewController(), title: "tab3_other", image: "tab3", selectedImage: "tab3_select")
        setupOneChildViewController(childVc: MineViewController(), title: "tab4_mine", image: "tab3", selectedImage: "tab3_select")
        
    }
    
    func setupItemTitleTextAttributes() {
        tg_setTabBarColor(.white, .green, .gray)
    }
     
    fileprivate func setupOneChildViewController(childVc:UIViewController, title:String, image:String, selectedImage:String) {
        childVc.tabBarItem.title = title
        self.tabBar.tintColor = .green
        childVc.title = title 
        if (image.count > 0) {
            childVc.tabBarItem.image = UIImage(named: image)?.withRenderingMode(.alwaysOriginal)
            childVc.tabBarItem.selectedImage = UIImage(named: selectedImage)?.withRenderingMode(.alwaysOriginal)
        }
        let nav = BaseNavigationController.init(rootViewController: childVc)
        self.addChild(nav)
    }
}

func tg_setTabBarColor(_ normalColor:UIColor,_ selectColor:UIColor,_ bgColor:UIColor?) {
    let tabBarItem = UITabBarItem.appearance()
    
    // 普通状态下的文字属性
    var normalAttrs = Dictionary<NSAttributedString.Key,Any>()
    normalAttrs[NSAttributedString.Key.font] = UIFont.systemFont(ofSize: 10)
    normalAttrs[NSAttributedString.Key.foregroundColor] = normalColor
    // 选中状态下的文字属性
    var selectedAttrs = Dictionary<NSAttributedString.Key,Any>()
    selectedAttrs[NSAttributedString.Key.font] = UIFont.systemFont(ofSize: 10)
    selectedAttrs[NSAttributedString.Key.foregroundColor] = selectColor
    
    tabBarItem.setTitleTextAttributes(normalAttrs, for: .normal)
    tabBarItem.setTitleTextAttributes(selectedAttrs, for: .selected)
    
    // iOS13适配，处理未选中颜色失效
    if #available(iOS 13.0, *) {
        UITabBar.appearance().unselectedItemTintColor = normalColor
    }
    // iOS15适配，处理tabBar背景和分割线透明，选中颜色失效
    if #available(iOS 15.0, *) {
        let appearance = UITabBarAppearance();
        if (bgColor != nil) {
            appearance.backgroundColor = bgColor; // tabBar背景颜色
        }
        //        appearance.backgroundEffect = nil; // 去掉半透明效果
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = normalAttrs;
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = selectedAttrs;
        UITabBar.appearance().standardAppearance = appearance;
        UITabBar.appearance().scrollEdgeAppearance = appearance;
    }
}
