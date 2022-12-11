//
//  BaseRootViewController.swift
//  SwiftDemo
//
//  Created by 尹东博 on 2022/11/25.
//

import UIKit

class BaseRootViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad() 
    }
    
    func addChilder(child:UIViewController , title:String, image:String, index:Int)  {
        let navigtion = BaseNavigationController(rootViewController: child)
        child.title = title
        child.tabBarItem.tag = index
        child.tabBarItem.image = UIImage(named: image)
        self.addChild(navigtion)
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.blue], for: .selected)
    }

}
