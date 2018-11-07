//
//  DriverViewController.swift
//  OilAnt
//
//  Created by 王瑞 on 2018/11/6.
//  Copyright © 2018年 王瑞. All rights reserved.
//

import UIKit
import SnapKit

class DriverViewController: UIViewController {
    //一图一label
    lazy var createStackView = { (image:String, text:String)  -> UIView in
        let view = UIView()
        let listenPic = UIImageView(image: UIImage(named: image))
        let label = UILabel()
        label.text = text
        label.textAlignment = .center
        view.addSubview(listenPic)
        view.addSubview(label)
        //设置约束
        listenPic.snp.makeConstraints({ (make) in
            make.left.top.equalToSuperview()
            make.width.height.equalTo(140)
        })
        label.snp.makeConstraints({ (make) in
            make.top.equalTo(listenPic.snp.bottom).offset(10)
            make.left.bottom.right.equalToSuperview()
        })
        return view
    }
    //输入框
    lazy var textfield = { () -> UITextField in
        let field = UITextField()
        field.borderStyle = .roundedRect
        field.isUserInteractionEnabled = true
        return field
    }
    
    //MARK:第一个view
    lazy var fristView:UIView = {
        let fristView = UIView()
        let user = UILabel()
        user.text = "个人信息"
        let role = UILabel()
        role.text = "角色选择"
        let userName = textfield()
        let userIdCarld = textfield()
        
        let companyName = textfield()
        let name = UILabel()
        name.text = "姓名"
        let identityCard = UILabel()
        identityCard.text = "身份证号"
        let companyNameLabel = UILabel()
        companyNameLabel.text = "单位名称"
        //驾驶证上传的view
        let stackView:UIView = createUploadView(labeltext: "驾驶证上传")
        //        添加所有控件
        fristView.addSubview(user)
        fristView.addSubview(role)
        fristView.addSubview(userName)
        fristView.addSubview(userIdCarld)
        fristView.addSubview(companyName)
        fristView.addSubview(name)
        fristView.addSubview(identityCard)
        fristView.addSubview(companyNameLabel)
        fristView.addSubview(stackView)
        //添加所有控件的约束
        user.snp.makeConstraints({ (make) in
            make.left.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(20)
        })
        role.snp.makeConstraints({ (make) in
            make.left.equalTo(user.snp.left)
            make.top.equalTo(user.snp.bottom).offset(20)
        })
        name.snp.makeConstraints({ (make) in
            make.left.equalTo(role.snp.left)
            make.top.equalTo(role.snp.bottom).offset(20)
        })
        userName.snp.makeConstraints({ (make) in
            make.width.equalTo(166)
            make.right.equalToSuperview().offset(-40)
            make.top.equalTo(name.snp.top)
            make.bottom.equalTo(name.snp.bottom).offset(5)
        })
        identityCard.snp.makeConstraints({ (make) in
            make.left.equalTo(name.snp.left)
            make.top.equalTo(userName.snp.bottom).offset(20)
        })
        userIdCarld.snp.makeConstraints({ (make) in
            make.width.equalTo(166)
            make.right.equalToSuperview().offset(-40)
            make.top.equalTo(identityCard.snp.top)
            make.bottom.equalTo(identityCard.snp.bottom).offset(5)
        })
        companyNameLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(identityCard.snp.left)
            make.top.equalTo(userIdCarld.snp.bottom).offset(20)
        })
        companyName.snp.makeConstraints({ (make) in
            make.width.equalTo(166)
            make.right.equalToSuperview().offset(-40)
            make.top.equalTo(companyNameLabel.snp.top)
            make.bottom.equalTo(companyNameLabel.snp.bottom).offset(5)
        })
        stackView.snp.makeConstraints({ (make) in
            make.left.equalTo(companyNameLabel.snp.left)
            make.top.equalTo(companyName.snp.bottom).offset(20)
            make.bottom.right.equalToSuperview()
        })
        
        return fristView
    }()
    
    //第二个view
    lazy var secView:UIView = {
        let secView = UIView()
        let carInfo = UILabel()
        carInfo.text = "车辆信息"
        let carPlateNum = UILabel()
        carPlateNum.text = "车牌号"
        let carPlateNumField = textfield()
        let loadLabel = UILabel()
        loadLabel.text = "核载"
        let loadField = textfield()
        let isInstalledSealLabel = UILabel()
        isInstalledSealLabel.text = "是否安装电子铅封"
        let isInatalledCameraLabel = UILabel()
        isInatalledCameraLabel.text = "是否安装车载摄像头"
        let drivingLicense = createUploadView(labeltext: "行驶证上传")
        //添加子视图
        secView.addSubview(carInfo)
        secView.addSubview(carPlateNum)
        secView.addSubview(carPlateNumField)
        secView.addSubview(loadLabel)
        secView.addSubview(loadField)
        secView.addSubview(isInstalledSealLabel)
        secView.addSubview(isInatalledCameraLabel)
        secView.addSubview(drivingLicense)
        //设置约束
        //车辆信息
        carInfo.snp.makeConstraints({ (make) in
            make.left.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(20)
        })
        //车牌号
        carPlateNum.snp.makeConstraints({ (make) in
            make.left.equalTo(carInfo.snp.left)
            make.top.equalTo(carInfo.snp.bottom).offset(20)
        })
        carPlateNumField.snp.makeConstraints({ (make) in
            make.width.equalTo(166)
            make.right.equalToSuperview().offset(-40)
            make.top.equalTo(carPlateNum.snp.top)
            make.bottom.equalTo(carPlateNum.snp.bottom).offset(5)
        })
        //荷载
        loadLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(carPlateNum.snp.left)
            make.top.equalTo(carPlateNumField.snp.bottom).offset(20)
        })
        loadField.snp.makeConstraints({ (make) in
            make.width.equalTo(166)
            make.right.equalToSuperview().offset(-40)
            make.top.equalTo(loadLabel.snp.top)
            make.bottom.equalTo(loadLabel.snp.bottom).offset(5)
        })
        //是否安装铅封
        isInstalledSealLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(loadLabel.snp.left)
            make.top.equalTo(loadField.snp.bottom).offset(20)
        })
        //此处是否少个switch?
        //是否安装了车载摄像头
        isInatalledCameraLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(isInstalledSealLabel.snp.left)
            make.top.equalTo(isInstalledSealLabel.snp.bottom).offset(20)
        })
        //行驶证上传的view
        drivingLicense.snp.makeConstraints({ (make) in
            make.left.equalTo(isInatalledCameraLabel.snp.left)
            make.top.equalTo(isInatalledCameraLabel.snp.bottom).offset(20)
            make.bottom.right.equalToSuperview()
        })
        return secView
    }()
    // 第三个view
    
    lazy var thirdView:UIView = {
        let thirdView = UIView()
        let firstView: UIView = {
            let firstView = UIView()
            let label = UILabel()
            label.numberOfLines = 0
            label.text =  "道路运输经营许可证上传"
            let stackView = createStackView("占位图片", "正")
            firstView.addSubview(label)
            firstView.addSubview(stackView)
            //设置约束
            label.snp.makeConstraints({ (make) in
                make.top.equalToSuperview()
                make.left.equalToSuperview().offset(10)
            })
            stackView.snp.makeConstraints({ (make) in
                make.right.equalToSuperview().offset(-160)
                make.width.equalTo(140)
                make.left.equalTo(label.snp.right).offset(20)
                make.top.equalTo(label.snp.top)
                make.bottom.equalToSuperview()
            })
            return firstView
        }()
        let bottomView = createUploadView(labeltext: "道路运营证上传")
        //添加到父视图
        thirdView.addSubview(firstView)
        thirdView.addSubview(bottomView)
        //添加约束
        firstView.snp.makeConstraints({ (meke) in
            meke.left.top.right.equalToSuperview()
        })
        bottomView.snp.makeConstraints({ (make) in
            make.top.equalTo(firstView.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(10)
            make.bottom.right.equalToSuperview()
        })
        return thirdView
    }()
    lazy var subBtn = UIButton(type: UIButton.ButtonType.system)
    //scrollView
    lazy var scrollView:UIScrollView = {
        let scrollView = UIScrollView(frame: view.bounds)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        scrollView.isUserInteractionEnabled = true
        return scrollView
    }()
    
    //返回按钮点击响应
    @objc func backToPrevious(){
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        let leftBarBtn = UIBarButtonItem(title: "返回", style: .plain, target: self,
                                         action: #selector(backToPrevious))
        self.navigationItem.leftBarButtonItem = leftBarBtn
        self.navigationItem.title = "车主认证"
        
        setupUI()
        
        // Do any additional setup after loading the view.
    }
    //设置界面
    func setupUI(){
        //按钮设置
        subBtn.setTitle("提交", for: .normal)
        subBtn.addTarget(self, action: #selector(btn), for: .touchUpInside)
        view.addSubview(scrollView)
        let scrollContentView = UIView()
        scrollContentView.isUserInteractionEnabled = true
        scrollContentView.addSubview(fristView)
        scrollContentView.addSubview(secView)
        scrollContentView.addSubview(thirdView)
        scrollContentView.addSubview(subBtn)
        scrollView.addSubview(scrollContentView)
        //设置约束
        fristView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalTo(64)
            make.width.equalTo(view.bounds.size.width)
        }
        secView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalTo(fristView.snp.bottom).offset(5)
            make.width.equalTo(view.bounds.size.width)
        }
        thirdView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalTo(secView.snp.bottom).offset(5)
            make.width.equalTo(view.bounds.size.width)
        }
        subBtn.snp.makeConstraints { (make) in
            make.top.equalTo(thirdView.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20)
            make.width.equalTo(50)
            make.height.equalTo(40)
        }
        
        //设置scrollContentView的约束
        scrollContentView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
            make.width.equalTo(UIScreen.main.bounds.width)
        }
        //        scrollView.contentSize = CGSize(width: view.bounds.size.width, height: scrollContentView.frame.size.height)
        
    }
    
    func createUploadView(labeltext:String) -> UIView{
        let stackView = UIView()
        let listenViewleft = createStackView("占位图片", "正")
        let listenViewRight = createStackView("占位图片", "反")
        let label = UILabel()
        label.numberOfLines = 0
        label.text = labeltext
        stackView.addSubview(label)
        stackView.addSubview(listenViewleft)
        stackView.addSubview(listenViewRight)
        //添加约束
        label.snp.makeConstraints({ (make) in
            make.left.top.equalToSuperview()
        })
        listenViewleft.snp.makeConstraints({ (make) in
            make.left.equalTo(label.snp.right).offset(10)
            make.top.equalTo(label.snp.top)
            make.width.equalTo(140)
            make.bottom.equalToSuperview()
        })
        listenViewRight.snp.makeConstraints({ (make) in
            make.left.equalTo(listenViewleft.snp.right).offset(10)
            make.top.equalTo(label.snp.top)
            make.width.equalTo(140)
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview()
        })
        return stackView
    }
    @objc func btn()  {
        print("haaha")
    }
    
    
    
}
