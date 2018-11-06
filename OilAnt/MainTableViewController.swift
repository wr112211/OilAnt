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


class MainTableViewController: UITableViewController {

    private var indentList = [IndentEntry]()
    
    let userDefault = UserDefaults.standard

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return indentList.count
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
        
        print("tableView===  \(tableView)")
        print(self)
        
        let params = [
            "mobile": "18211005247",
            "password" : "123456"
        ]
        
        // 4.请求头
        let headers: HTTPHeaders = [
            "Accept": "application/json"
        ]
        LoginViewController.requestPOST(SERVICE_URL+LOGIN,params, headers: headers, success: { (result) in
            
            print("result===  \(result)")
            let cstorage = HTTPCookieStorage.shared
            if let cookies = cstorage.cookies {
                //                for cookie:HTTPCookie in cookies {
                //                    //                    print("name：\(cookie.name)", "value：\(cookie.value)")
                //
                ////                    let userDefault = UserDefaults.standard
                //
                //                    self.userDefault.set("\(cookie.name)=\(cookie.value)", forKey: "session")
                //
                //                }
                self.requestList()
            }
        })
        { (error) in
            
        }
        //        self.requestList()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let row = tableView.indexPathForSelectedRow!.row
        let destination = segue.destination as! IndentMessageViewController
        
        destination.idStr = String(row);
    }
}
