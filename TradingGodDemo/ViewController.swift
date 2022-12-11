//
//  ViewController.swift
//  TradingGodDemo
//
//  Created by 尹东博 on 2022/11/27.
//

import UIKit

enum LoginShowType {
    case loginShowType_None
    case loginShowType_User
    case loginSHowType_Pass
}

class ViewController: UIViewController, UITextFieldDelegate {
    
    let vLoginW = UIScreen.main.bounds.width - 30;
    var showType = LoginShowType.loginShowType_None;
    let offsetLeftHand = 60;

    lazy var oImgLefthandFrame = CGRect.zero;
    lazy var oImgRightHandFrame = CGRect.zero;
    lazy var oImgLeftHandGoneFrame = CGRect.zero;
    lazy var oImgRightHandGoneFrame = CGRect.zero;
    var currentTextField = UITextField.init();
    
    lazy var txtUser:UITextField = { () -> UITextField in
        let txtUser = UITextField.init(frame: CGRect(x: 30, y: 30, width: vLoginW - 60, height: 44));
        txtUser.delegate = self;
        txtUser.layer.cornerRadius = 5;
        txtUser.layer.borderColor = UIColor.lightGray.cgColor;
        txtUser.layer.borderWidth = 0.5;
        txtUser.leftView = UIView.init(frame: CGRect(x: 11, y: 11, width: 44, height: 44));
        txtUser.leftViewMode = .always;
        let imgUsr = UIImageView.init(frame: CGRect(x: 11, y: 11, width: 22, height: 22));
        imgUsr.image = UIImage.init(named: "iconfont-user");
        txtUser.leftView?.addSubview(imgUsr);
        return txtUser
    }()
    
    lazy var txtPwd:UITextField = { () -> UITextField in
        let txtPwd = UITextField.init(frame: CGRect(x: 30, y: 90, width: vLoginW-60, height: 44));
        txtPwd.delegate = self;
        txtPwd.layer.cornerRadius = 5;
        txtPwd.layer.borderColor = UIColor.lightGray.cgColor;
        txtPwd.layer.borderWidth = 0.5;
        txtPwd.isSecureTextEntry = true;
        txtPwd.leftView = UIView.init(frame: CGRect(x: 0, y: 0, width: 44, height: 44));
        txtPwd.leftViewMode = .always;
//        txtPwd.layer.borderColor = UIColor.green.cgColor;
//        txtPwd.layer.borderWidth = 1;
        let imgPws = UIImageView.init(frame: CGRect(x: 11, y: 11, width: 22, height: 22));
        imgPws.image = UIImage.init(named: "iconfont-password");
        txtPwd.leftView?.addSubview(imgPws);
        return txtPwd;
    }()
    
    lazy var imgLeftHandGone:UIImageView = { () -> UIImageView in
        let imgLeftHandGone = UIImageView.init(frame: CGRect(x: view.frame.size.width/2-100, y: 180, width: 40, height: 40));
        imgLeftHandGone.image = UIImage.init(named: "icon_hand");
        return imgLeftHandGone
    }()
    
    lazy var imgRightHandGone:UIImageView = {() -> UIImageView in
        let imgRightHandGone = UIImageView.init(frame: CGRect(x: view.frame.size.width/2 + 62, y: 180, width: 40, height: 40));
        imgRightHandGone.image = UIImage.init(named: "icon_hand");
        return imgRightHandGone;
    }()
    
    lazy var imgLeftHand:UIImageView = {() -> UIImageView in
        let imgLeftHand = UIImageView.init();
        return imgLeftHand;
    }()
    
    lazy var imgRightHand:UIImageView = {() -> UIImageView in
        let imgRightHand = UIImageView.init();
        return imgRightHand;
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        let bg_img = UIImageView.init(image: UIImage.init(named: "login_bg"));
        bg_img.frame = view.bounds;
        view.addSubview(bg_img);
        
        view.backgroundColor = .cyan
        
        let imgLogin = UIImageView.init(frame: CGRect(x: view.frame.size.width/2 - 211 / 2, y: 100, width: 211, height: 109));
        imgLogin.image = UIImage.init(named: "owl-login")
        imgLogin.layer.masksToBounds = true;
        view.addSubview(imgLogin);
        
        let rectLeftHand = CGRect(x: 61-offsetLeftHand, y: 90, width: 40, height: 65);
//        let imgLeftHand = UIImageView.init(frame: rectLeftHand);
        imgLeftHand.frame = rectLeftHand
        imgLeftHand.image = UIImage.init(named: "owl-login-arm-left")
        imgLogin.addSubview(imgLeftHand);
         
        let rectRightHand =  CGRect(x: imgLogin.frame.size.width/2 + 60, y: 90, width: 40, height: 65);
        imgRightHand.frame = rectRightHand;
        imgRightHand.image = UIImage.init(named: "owl-login-arm-right")
        imgLogin.addSubview(imgRightHand);
        
        let vLogin = UIView.init(frame: CGRect(x: 15, y: 200, width: vLoginW, height: 160));
        vLogin.layer.borderWidth = 1;
        vLogin.layer.borderColor = UIColor.lightGray.cgColor;
        vLogin.backgroundColor = .white;
        view.addSubview(vLogin);
         
        view.addSubview(imgLeftHandGone);
        view.addSubview(imgRightHandGone);
        vLogin.addSubview(txtUser);
        vLogin.addSubview(txtPwd);
         
        oImgLefthandFrame = imgLeftHand.frame;
        oImgRightHandFrame = imgRightHand.frame;
        oImgLeftHandGoneFrame = imgLeftHandGone.frame;
        oImgRightHandGoneFrame = imgRightHandGone.frame;
        
        
        let btn = UIButton(type: .custom);
        btn.frame = CGRect(x: 0, y: 400, width: vLoginW, height: 44);
        btn.center.x = view.frame.size.width/2;
        btn.backgroundColor = .white;
        btn.layer.cornerRadius = 2.5;
        
        btn.layer.masksToBounds = true;
        view.addSubview(btn);
        btn.addTarget(self, action: #selector(buttonClick), for: .touchUpInside);
        btn.setTitle("登录", for: .normal);
        btn.setTitleColor(.black, for: .normal);
        
        applyCurvedShadow(btn: btn);
        
        
        let graLayer =  CAGradientLayer();
        graLayer.frame = btn.frame;
        let colors = [UIColor.cyan.cgColor, UIColor.red.cgColor, UIColor.yellow.cgColor];
        graLayer.colors = colors;
        btn.layer.addSublayer(graLayer);
         
    }
 
    @objc func buttonClick() {
        print("hahahahahaha")
        
        WisdomHUD.showSuccess(text: "登陆成功", barStyle: .light, inSupView: view, delays: 3) { interval in
            let mainVc = MainViewController()
            let nav = BaseNavigationController.init(rootViewController: mainVc)
            nav.modalPresentationStyle = .fullScreen
            self.navigationController?.present(nav, animated: true, completion: {})
        }
        

    }
 
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.txtUser.resignFirstResponder()
        self.txtPwd.resignFirstResponder()
        UIView.animate(withDuration: 0.5) {
            self.imgLeftHand.frame = self.oImgLefthandFrame;
            self.imgRightHand.frame = self.oImgRightHandFrame;
            self.imgLeftHandGone.frame = self.oImgLeftHandGoneFrame;
            self.imgRightHandGone.frame = self.oImgRightHandGoneFrame;
        }
    }
    
    func applyCurvedShadow(btn: UIButton) {
        let size = btn.bounds.size
        let width = size.width
        let height = size.height
        let path = UIBezierPath()
        path.move(to: CGPoint(x: width, y: 0))
        path.addLine(to: CGPoint(x: width + 3, y: 0))
        path.addLine(to: CGPoint(x: width + 3, y: height))
        path.addLine(to: CGPoint(x:0, y: height))
        path.close()
        let layer = view.layer
        layer.shadowPath = path.cgPath
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 3
        layer.shadowOffset = CGSize(width: 3, height: 0)
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.isEqual(txtUser) {
//            if(showType != .loginSHowType_Pass){
//                showType = .loginShowType_User;
//                return
//            }
            showType = LoginShowType.loginShowType_User;
            UIView.animate(withDuration: 0.5) {
                self.imgLeftHand.frame = self.oImgLefthandFrame;
                //CGRect.init(x: self.imgLeftHand.frame.origin.x - 60, y: self.imgLeftHand.frame.origin.y + 30, width: self.imgLeftHand.frame.size.width, height: self.imgLeftHand.frame.size.height);
                self.imgRightHand.frame = self.oImgRightHandFrame;
                //CGRect.init(x: self.imgRightHand.frame.origin.x + 48, y: self.imgRightHand.frame.origin.y + 30, width: self.imgRightHand.frame.size.width, height: self.imgRightHand.frame.size.height);
                self.imgLeftHandGone.frame = self.oImgLeftHandGoneFrame;
                //CGRect.init(x: self.imgLeftHandGone.frame.origin.x - 70, y: self.imgLeftHandGone.frame.origin.y, width: 40, height: 40);
                self.imgRightHandGone.frame = self.oImgRightHandGoneFrame;
                //CGRect.init(x: self.imgRightHandGone.frame.origin.x + 30, y: self.imgRightHandGone.frame.origin.y, width: 40, height: 40);
            }
        }else if (textField.isEqual(txtPwd)) {
//            if(showType == .loginSHowType_Pass) {
//                showType = .loginSHowType_Pass;
//                return;
//            }
            showType = .loginSHowType_Pass;
            UIView.animate(withDuration: 0.5) {
                self.imgLeftHand.frame = CGRect.init(x: self.imgLeftHand.frame.origin.x + 60, y: self.imgLeftHand.frame.origin.y - 30, width: self.imgLeftHand.frame.size.width, height: self.imgLeftHand.frame.size.height);
                self.imgRightHand.frame = CGRect.init(x: self.imgRightHand.frame.origin.x - 48, y: self.imgRightHand.frame.origin.y - 30, width: self.imgRightHand.frame.size.width, height: self.imgRightHand.frame.size.height);
                self.imgLeftHandGone.frame = CGRect.init(x: self.imgLeftHandGone.frame.origin.x + 70, y: self.imgLeftHandGone.frame.origin.y, width: 0, height: 0);
                self.imgRightHandGone.frame = CGRect.init(x: self.imgRightHandGone.frame.origin.x - 30, y: self.imgRightHandGone.frame.origin.y, width: 0, height: 0);
            }
        }
    }
}

