//
//  MainTableViewController.swift
//  OilAnt
//
//  Created by 王瑞 on 2018/11/6.
//  Copyright © 2018年 王瑞. All rights reserved.
//

import UIKit
import Alamofire
import HandyJSON


let SERVICE_URL = "http://testoil.plan-solve.com";
let advancedSearch = "/carry/combinedQuery";//首页筛选


class MainTableViewController: UITableViewController, DelegatePush {
    
    func method() {
        self.requestList()
    }
    

    private var indentList = [IndentEntry]()
    
    let userDefault = UserDefaults.standard

    var headerView: UIView!
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return indentList.count
    }
   
    lazy var customView:UIView = Bundle.main.loadNibNamed("\(MainTabHeaderView.self)", owner: nil, options: nil)!.first as! MainTabHeaderView
   
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return customView.frame.size.height
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let beginLocation =  (customView as! MainTabHeaderView).beginLocation
        beginLocation? .isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self,  action: #selector(MainTableViewController.picTap))
        beginLocation?.addGestureRecognizer(tapGesture)
        
        let endLocation =  (customView as! MainTabHeaderView).endLocation
        endLocation? .isUserInteractionEnabled = true
        let tapGesture2 = UITapGestureRecognizer(target: self,  action: #selector(MainTableViewController.picTap2))
        endLocation?.addGestureRecognizer(tapGesture2)
        
        let filterLable =  (customView as! MainTabHeaderView).filterLable
        filterLable? .isUserInteractionEnabled = true
        let tapGesture3 = UITapGestureRecognizer(target: self,  action: #selector(MainTableViewController.picTap3))
        filterLable?.addGestureRecognizer(tapGesture3)
        
        let searchBtn =  (customView as! MainTabHeaderView).searchBtn
        searchBtn? .isUserInteractionEnabled = true
        let tapGesture4 = UITapGestureRecognizer(target: self,  action: #selector(MainTableViewController.picTap4))
        searchBtn?.addGestureRecognizer(tapGesture4)
        
        let searchKey =  (customView as! MainTabHeaderView).searchKey
        searchKey?.placeholder="请输入关键字"
        
        return customView
    }
    
    @objc func picTap()
    {
        print("beginLocation")
        //实例化一个将要跳转的viewController
        let mainView = CitySelectorViewController()
        //跳转
        self.present(mainView , animated: true, completion: nil)
    }
    
    @objc func picTap2()
    {
        print("endLocation")
        //实例化一个将要跳转的viewController
        let mainView = CitySelectorViewController()
        //跳转
        self.present(mainView , animated: true, completion: nil)
    }
    
    @objc func picTap3()
    {
        print("filterLable")
    }
    
    @objc func picTap4()
    {
        print("searchBtn")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let id = String(describing: IndentCell.self)
        let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath) as! IndentCell
        
        let  indent  = indentList[indexPath.row]
        
        cell.dictrct.text = " \(indent.startDistrict) 至 \(indent.finishDistrict) "
        switch indent.process {
            //        case "0"  :
        //                cell.stateLable.text=""
        case "1":
            cell.stateLable.text="待接单"
            break;
        case "2":
            cell.stateLable.text="待运输"
            break;
        case "3":
            cell.stateLable.text="运输中"
            break;
        case "4":
            cell.stateLable.text="待收货"
            break;
        case "5":
            cell.stateLable.text="待支付"
            break;
        case "6":
            cell.stateLable.text="已完成"
            break
        case "7":
            cell.stateLable.text="已完成"
            break;
        case "-1":
            cell.stateLable.text="已取消"
            break;
        default :
            cell.stateLable.text="运输中"
        }
        cell.goodname.text = indent.goodName
        cell.priceLable.text = "¥ \(indent.unitPrice)"
        cell.dateLable.text =  "发货时间 \(indent.deliveryToDate) - \(indent.deliveryEndDate) "
        
        
        return cell
    }
    
    override func viewDidLoad() {
        
        self.navigationController?.navigationBar.barTintColor = UIColor.orange
        self.navigationItem.title = "主页"
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        print(self)
     
        
//        let objectValue:Any? = self.userDefault.object(forKey: "session")
//        if (objectValue == nil){
        
             let loginview =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginView")
        
             var login = loginview.children.first as! LoginViewController
             login.delegate = self
        
             self.present(loginview , animated: true, completion: nil)
        
//        } else {
//
//            self.requestList()
//        }
    }
    
    func requestList(){
        
        let paramsSearch = [
            //            "startCity": "北京市",
            //            "deliverStartDate": "",
            //            "deliverLastDate": "",
            //            "deliveryToDate": "",
            //            "deliveryEndDate": "",
            //            "goodCategory": "",
            "pageNumber": "0",
            "keyWord": "",
            //            "processes": "",
            "pageSize": "20",
            //            "finishCity" : ""
        ]
        
        let objectValue:Any? = self.userDefault.object(forKey: "session")
        print("\(objectValue as! String)")
        
        let headerss: HTTPHeaders = [
            "Accept": "application/json",
            "Cookie": objectValue as! String
        ]
        
        Alamofire.request(SERVICE_URL+advancedSearch, method: .post, parameters: paramsSearch, headers: headerss).responseJSON {
            (response) in
            
            let dic = (response.result.value as! NSDictionary)
            if let baseModel = JSONDeserializer<ResponseEntry>.deserializeFrom(dict: dic){
                print("baseModel.code=== \(baseModel.code)")
                if(baseModel.code != "200"){
                    let alertController = UIAlertController(title: baseModel.msg,
                                                            message: nil, preferredStyle: .alert)
                    //  显示提示框
                    self.present(alertController, animated: true, completion: nil)
                    //  两秒钟后自动消失
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                        self.presentedViewController?.dismiss(animated: false, completion: nil)
                    }
                } else {
                    
                    self.indentList = baseModel.data!
                    //                    DispatchQueue.main.async { [weak self] in
                    self.tableView.reloadData()
                    //                        print("goodName === \(self.indentList[0].goodName) ")
                    //                    }
                    
                }
            }
            
        }
    }
    
    func convertModel1(_ jsonStr: String) {
        if let model = JSONDeserializer<ResponseEntry>.deserializeFrom(json: jsonStr){
            print("convertModel1 ==\(model.code)  \(model.msg)  \(String(describing: model.data))")
            
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       self.performSegue(withIdentifier: "ShowMapView", sender: "mainview")
    }
  
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ShowMapView"{
            let row = tableView.indexPathForSelectedRow!.row
            let destination = segue.destination as! UINavigationController
//        let controller = (destination.viewControllers.first as! IndentMessageViewController)
//
//        controller.idStr = (sender as? String)!
            let controller = (destination.viewControllers.first as! IndentMessageViewController)
            controller.idStr = "mainview \(row)"
        }
    }
}
