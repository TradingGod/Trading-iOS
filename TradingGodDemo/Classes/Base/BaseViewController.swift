//
//  BaseViewController.swift
//  SwiftDemo
//
//  Created by 尹东博 on 2022/11/25.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .white
         
        self.edgesForExtendedLayout = []
        let bgImg = UIImageView.init(image: UIImage.init(named: "app_bg"))
        bgImg.frame = self.view.bounds
        view.addSubview(bgImg)
    }


}
