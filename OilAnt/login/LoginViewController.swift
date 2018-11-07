//
//  LoginViewController.swift
//  OilAnt
//
//  Created by 王瑞 on 2018/11/6.
//  Copyright © 2018年 王瑞. All rights reserved.
//

import UIKit

import Alamofire

let LOGIN = "/user/login";//登录
class LoginViewController: UIViewController {

    @IBOutlet weak var userMobile: UITextField!
    @IBOutlet weak var userPass: UITextField!
    
    let userDefault = UserDefaults.standard
    
    @IBAction func LoginBtn(_ sender: Any) {
        //        print(userMobile.text!)
        //        print(userPass.text!)
        let params = [
            "mobile": userMobile.text!,
            "password" : userPass.text!
        ]
        
        // 4.请求头
        let headers: HTTPHeaders = [
            "Accept": "application/json"
        ]
        
        LoginViewController.requestPOST(SERVICE_URL+LOGIN, params, headers: headers, success: { (result) in
            //              if(baseModel.code != "200"){
            //                    let alertController = UIAlertController(title: baseModel.msg,
            //                                                            message: nil, preferredStyle: .alert)
            //                    //  显示提示框
            //                    self.present(alertController, animated: true, completion: nil)
            //                    //  两秒钟后自动消失
            //                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            //                        self.presentedViewController?.dismiss(animated: false, completion: nil)
            //                    }
            //              }else{
            
            let cstorage = HTTPCookieStorage.shared
            if let cookies = cstorage.cookies {
                for cookie:HTTPCookie in cookies {
                    //                    print("name：\(cookie.name)", "value：\(cookie.value)")
                    
                    let userDefault = UserDefaults.standard
                    
                    userDefault.set("\(cookie.name)=\(cookie.value)", forKey: "session")
                    
                }
            }
//            //实例化一个将要跳转的viewController
//            let mainView = MainTableViewController()
//            //跳转
//            self.present(mainView , animated: true, completion: nil)
             self.performSegue(withIdentifier: "ShowMainView", sender: "aaa")
            
            //            }
        })
        { (error) in
            
        }
    }
    
    // MARK: - Block
    /// 成功
    typealias successHandler = (_ success: Any?) -> Void
    /// 失败
    typealias failureHandler = (_ error: Error?) -> Void
    
    
    // MARK: - 发送请求的方法
    /// POST请求
    class func requestPOST(_ url: String,
                           _ parameters: Parameters? = nil,
                           _ encoding: ParameterEncoding = URLEncoding.default,
                           headers: HTTPHeaders? = nil,
                           success: @escaping successHandler,
                           failure: @escaping failureHandler) -> DataRequest {
        return request(url: url, method: .post, parameters: parameters, encoding: encoding, headers: headers, success: success, failure: failure)
    }
    /// GET方法
    class func requestGET(_ url: String,
                          _ parameters: Parameters? = nil,
                          _ encoding: ParameterEncoding = URLEncoding.default,
                          _ headers: HTTPHeaders? = nil,
                          success: @escaping successHandler,
                          failure: @escaping failureHandler) -> DataRequest {
        return request(url: url, method: .get, parameters: parameters, encoding: encoding, headers: headers, success: success, failure: failure)
    }
    
    /// PUT请求
    class func requestPUT(_ url: String,
                          _ parameters: Parameters? = nil,
                          _ encoding: ParameterEncoding = URLEncoding.default,
                          _ headers: HTTPHeaders? = nil,
                          success: @escaping successHandler,
                          failure: @escaping failureHandler) -> DataRequest {
        return request(url: url, method: .put, parameters: parameters, encoding: encoding, headers: headers, success: success, failure: failure)
    }
    
    /* 发送请求
     @param     url         请求的链接
     @param     method      请求的类型
     @param     parameters  请求的参数
     @param     encoding    请求的参数的类型
     @param     headers     请求头
     @param     success     成功的block
     @param     failure     失败的block
     */
    class func request(url: String,
                       method: HTTPMethod,
                       parameters: Parameters?,
                       encoding: ParameterEncoding,
                       headers: HTTPHeaders?,
                       success: @escaping successHandler,
                       failure: @escaping failureHandler) -> DataRequest {
        
        return Alamofire.request(url,
                                 method: method,
                                 parameters: parameters,
                                 encoding: encoding,
                                 headers: headers).responseJSON { (response) in
                                    let sessionStr = (response.response!.allHeaderFields)["Set-Cookie"]
                                    
                                    print(sessionStr)
                                    let sss = sessionStr as! String
                                    if(sss.contains("funny")){
                                        
                                        let i = sss.range(of: "; Path=/,")
                                        let j = sss.range(of: "; Path=/;")
                                        let subStr = sss.substring(with:(i?.upperBound)!..<(j?.lowerBound)!)
                                        print(subStr)
                                        let userDefault = UserDefaults.standard
                                        
                                        userDefault.set(subStr, forKey: "session")
                                        
                                    }
                                    success(response.result.value)
                                    failure(response.result.error)
        }
    }
    
    // 顶部刷新
    @objc func headerRefresh(){
        
        print("下拉刷新")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationItem.title = "登陆"
        
        // Do any additional setup after loading the view.
        //        textField.clearButtonMode = .whileEditing  //编辑时出现清除按钮
        //        textField.clearButtonMode = .unlessEditing  //编辑时不出现，编辑后才出现清除按钮
        //        textField.clearButtonMode = .always  //一直显示清除按钮
        userMobile.clearButtonMode = .unlessEditing  //编辑时不出现，编辑后才出现清除按钮
        userPass.clearButtonMode = .unlessEditing  //编辑时不出现，编辑后才出现清除按钮
        //        Default：系统默认的虚拟键盘
        //        ASCII Capable：显示英文字母的虚拟键盘
        //        Numbers and Punctuation：显示数字和标点的虚拟键盘
        //        URL：显示便于输入url网址的虚拟键盘
        //        Number Pad：显示便于输入数字的虚拟键盘
        //        Phone Pad：显示便于拨号呼叫的虚拟键盘
        //        Name Phone Pad：显示便于聊天拨号的虚拟键盘
        //        Email Address：显示便于输入Email的虚拟键盘
        //        Decimal Pad：显示用于输入数字和小数点的虚拟键盘
        //        Twitter：显示方便些Twitter的虚拟键盘
        //        Web Search：显示便于在网页上书写的虚拟键盘
        userMobile.keyboardType = UIKeyboardType.numberPad
        userPass.keyboardType = UIKeyboardType.emailAddress
        //        textField.returnKeyType = UIReturnKeyType.done //表示完成输入
        //        textField.returnKeyType = UIReturnKeyType.go //表示完成输入，同时会跳到另一页
        //        textField.returnKeyType = UIReturnKeyType.search //表示搜索
        //        textField.returnKeyType = UIReturnKeyType.join //表示注册用户或添加数据
        //        textField.returnKeyType = UIReturnKeyType.next //表示继续下一步
        //        textField.returnKeyType = UIReturnKeyType.send //表示发送
        
        userMobile.returnKeyType = UIReturnKeyType.next
        userPass.returnKeyType = UIReturnKeyType.done
        
        userMobile.placeholder="请输入手机号"
        userPass.placeholder="请输入密码"
        
        //        userMobile.text="15037165971"
        userMobile.text="18211005247"
        userPass.text="123456"
        
        
    }
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
   


}
