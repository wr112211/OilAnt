//
//  MineTableViewController.swift
//  OilAnt
//
//  Created by 王瑞 on 2018/11/6.
//  Copyright © 2018年 王瑞. All rights reserved.
//

import UIKit
import Alamofire
import HandyJSON

let mineMessage = "/user/mine";//我的信息

class MineTableViewController: UITableViewController {

    @IBOutlet weak var aboutOusBtn: UIView!
    @IBOutlet weak var userIcon: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userCompany: UILabel!
    @IBOutlet weak var myIncome: UILabel!
    @IBOutlet weak var authentication: UILabel!
    @IBOutlet weak var authenView: UIView!
    
    
    let userDefault = UserDefaults.standard
    private var indentList = [IndentEntry]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let item = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = item
        
        self.navigationController?.navigationBar.barTintColor = UIColor.orange
        
        self.navigationItem.title = "个人中心"
        
        authenView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self,  action: #selector(MineTableViewController.singleTap))
        
        tapGesture.numberOfTapsRequired = 1
        authenView.addGestureRecognizer(tapGesture)
        
        
        let objectValue:Any? = self.userDefault.object(forKey: "session")
        print("\(objectValue as! String)")
        // 4.请求头
        let headerss: HTTPHeaders = [
            "Accept": "application/json",
            "Cookie": objectValue as! String
        ]
        Alamofire.request(SERVICE_URL+mineMessage, method: .post, parameters: nil, headers: headerss).responseString {
            (response) in
            if response.result.isSuccess {
                
                if let jsonString = response.result.value {
                    if let responseModel = JSONDeserializer<BaseResponse<IndentEntry>>.deserializeFrom(json: jsonString) {
                        // model转json 为了方便在控制台查看
                        print("responseModel=code==",responseModel.code)
                        let authenticationed = responseModel.data?.authenticationed
                        let username = responseModel.data?.username
                        let company = responseModel.data?.company
                        let amount = responseModel.data?.amount
                        
                        switch(authenticationed){
                        case "0":
                            self.authentication.text="认证中"
                            break;
                        case "1":
                            self.authentication.text="认证失败"
                            break;
                        case "2":
                            self.authentication.text="已认证"
                            break;
                        default :self.authentication.text="已认证"
                        }
                        self.userName.text = username
                        self.userCompany.text = company
                        //                        self.myIncome.text = responseModel.amount
                        
                        //                        }
                        
                    }
                }
            }
            
            
            //            var authenticationed = 1;
            //            var certNo = 140427198301116816;
            //            var certStatus = 2;
            //            var company = "";
            //            //    var id = 22;
            //            var latestAuthentication = 49;
            //            var maxLoad = 50;
            //            var mobile = 18211005247;
            //            var newCarAuthed = 0;
            //            var plateNumber = "";
            //            var realname = "";
            //            var registId = "";
            //            var result = 1;
            //            var resultInfo = "";
            //            var role = 2;
            //            var username = "";
        }
    }
    
    
    
    @objc func singleTap()
    {
        print("跳转认证")
        //    let alertView = UIAlertController(title: "Infomation", message: "Single Tap", preferredStyle: MineViewController.alert)
        //    let OkAction = UIAlertAction(title: "ok",style: .default, handler: {_ in})
        //    alertView.addAction(OkAction)
        //    self.present(alertView,animated: true,completion: nil)
        self.performSegue(withIdentifier: "ShowDriverView", sender: "aaa")
    }
  
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ShowDriverView"{
            //            let controller = segue.destination as! DriverViewController
            //            controller.userAuthState = (sender as? String)!
        }
    }
    
    
    //    /*
    //     * 配置你的网络环境
    //     */
    //    enum  NetworkEnvironment{
    //        case Development
    //        case Test
    //        case Distribution
    //    }
    
    //    let CurrentNetWork : NetworkEnvironment = .Test
    
    // private func judgeNetwork(network : NetworkEnvironment = CurrentNetWork){
    //
    //     if(network == .Development){
    //
    //         LogInBase_Url = "http://dev-***.com/common-portal/"
    //         ProgressBase_Url = "http://dev-***.com:8080/isp-kongming/"
    //
    //
    //      }else if(network == .Test){
    //
    //          LogInBase_Url = "http://test-***.com/common-portal/"
    //          ProgressBase_Url = "http://test-***.com/isp-kongming/"
    //
    //      }else{
    //
    //          LogInBase_Url = "https://***.com/common-portal/"
    //         ProgressBase_Url = "https://***.com/isp-kongming/"
    //
    //     }
    //  }
}
