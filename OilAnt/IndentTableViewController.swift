//
//  IndentTableViewController.swift
//  OilAnt
//
//  Created by 王瑞 on 2018/11/6.
//  Copyright © 2018年 王瑞. All rights reserved.
//

import UIKit
import Alamofire
import HandyJSON

let getCarrysByProcess = "/carry/getCarrysByProcess";//我的订单分类
class IndentTableViewController: UITableViewController {
    
    private var indentList = [IndentEntry]()
    
    let userDefault = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.navigationController?.navigationBar.barTintColor = UIColor.orange
        
        self.navigationItem.title = "我的订单"
        
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
    }
    func requestList(){
        
        // 3. 参数、编码
        // 官方解释：Alamofire supports three types of parameter encoding including: URL, JSON and PropertyList. It can also support any custom encoding that conforms to the ParameterEncoding protocol.
        let params = [
            "mobile": 15037165971,
            "password" : 123456
        ]
        //        if (TextUtils.isEmpty(p)) {
        //            if (mCurrentState.equals(AppConfig.IndentStateStr.Working)) {
        //
        //                if (Utils.sharedPreferencesGet(getContext(), AppConfig.ROLE).equals("1")) {
        //                    pro = "1/2/3/4/5";
        //                } else {
        //                    pro = "2/3/4/5";
        //                }
        //            } else if (mCurrentState.equals(AppConfig.IndentStateStr.Finished)) {
        //                pro = "6";
        //            } else if (mCurrentState.equals(AppConfig.IndentStateStr.Canceled)) {
        //                pro = "-1";
        //            }
        //        } else {
        //            pro = p;
        //        }
        let paramsSearch = [
            "processes": "1/2/3/4/5",
            "pageNumber": "0"
        ]
        
        // 4.请求头
        let headers: HTTPHeaders = [
            "Accept": "application/json",
            "Cookie":""
        ]
        
        let objectValue:Any? = self.userDefault.object(forKey: "session")
        //            print("\(objectValue as! String)")
        // 4.请求头
        let headerss: HTTPHeaders = [
            "Accept": "application/json",
            "Cookie": objectValue as! String
        ]
        print(objectValue as! String)
        Alamofire.request(SERVICE_URL+getCarrysByProcess, method: .post, parameters: paramsSearch, headers: headerss).responseJSON {
            (response) in
            let dic = (response.result.value as! NSDictionary)
            if let baseModel = JSONDeserializer<ResponseEntry>.deserializeFrom(dict: dic){
            
                if(baseModel.code != "200"){
                    let alertController = UIAlertController(title: baseModel.msg,
                    message: nil, preferredStyle: .alert)
                    //  显示提示框
                    self.present(alertController, animated: true, completion: nil)
                    //  两秒钟后自动消失
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                        self.presentedViewController?.dismiss(animated: false, completion: nil)
                    }
                }
                self.indentList = baseModel.data!
                self.tableView.reloadData()
                print("goodName === \(self.indentList[0].goodName) ")
            }
            
        }
    }
   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
           return indentList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        let id = String(describing: IndentStateCell.self)
        let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath) as! IndentStateCell
        
        let  indent  = indentList[indexPath.row]
        cell.dictrct.text = " \(indent.startDistrict) 至 \(indent.finishDistrict) "
        switch indent.process {
            //        case "0"  :
            //                cell.stateLable.text=""
            case "1":
                cell.stateLabel.text="待接单"
            case "2":
                cell.stateLabel.text="待运输"
            case "3":
                cell.stateLabel.text="运输中"
            case "4":
                cell.stateLabel.text="待收货"
            case "5":
                cell.stateLabel.text="待支付"
            case "6":
                cell.stateLabel.text="已完成"
            case "7":
                cell.stateLabel.text="已完成"
            case "-1":
                cell.stateLabel.text="已取消"
            default :
                cell.stateLabel.text="运输中"
        }
        cell.goodname.text = indent.goodName
        cell.priceLabel.text = indent.unitPrice
        cell.dateLabel.text =  "发货时间 \(indent.deliveryToDate) - \(indent.deliveryEndDate) "
        
        
        return cell
    }
   

    func convertModel1(_ jsonStr: String) {
        if let model = JSONDeserializer<ResponseEntry>.deserializeFrom(json: jsonStr){
            print("convertModel1 ==\(model.code)  \(model.msg)  \(String(describing: model.data))")
            
        }
    }
    
    func convertModel3(_ jsonStr: String) {
        guard let model =  ResponseEntry.deserialize(from: jsonStr) else {return}
        print(model.code)
        print(model.data)
    }
    
    //    func convertModel2() {
    //        let jsonStr = "{\"list\":[{\"id\":1,\"name\":\"hello\",\"score\":1.1},{\"id\":2,\"name\":\"kkkkk\",\"score\":2.2}]}"
    //        if let model = JSONDeserializer<TestHandyJsonList>.deserializeFrom(json: jsonStr){
    //            print("\(model.list.count)  \(model.list[0].id)  \(model.list[0].name)  \(String(describing: model.list[0].score)) ")
    //        }
    //    }
    //
    
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
                                    //                                    print(response.description)
                                    
                                    //                                    let head = (response.response!.allHeaderFields)
                                    //                                    print(head)
                                    //
                                    //                                    let sessionStr = (response.response!.allHeaderFields)["Set-Cookie"]
                                    //
                                    //                                    if(sessionStr != nil){
                                    //                                        let sss = sessionStr as! String
                                    //
                                    //    //                                    print("sss==="+sss)
                                    //                                        if(sss.contains("funny")){
                                    //                                            let i = sss.range(of: "Path=/,")
                                    //                                            let j = sss.range(of: "; Path=/;")
                                    //                                            let subStr = sss.substring(with: (i?.upperBound)!..<(j?.lowerBound)!)
                                    //
                                    //                                            let userDefault = UserDefaults.standard
                                    //
                                    //                                            userDefault.set(subStr, forKey: "session")
                                    //
                                    //                                        }
                                    //                                    }
                                    success(response.result.value)
                                    failure(response.result.error)
        }
    }        // Do any additional setup after loading the view.
    
    
    
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
    
   
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ShowMapView", sender: "indentview")
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let row = tableView.indexPathForSelectedRow!.row
        let destination = segue.destination as! UINavigationController
//                let controller = (destination.viewControllers.first as! IndentMessageViewController)
        //
        //        controller.idStr = (sender as? String)!
        if segue.identifier == "ShowMapView"{
            let controller = (destination.viewControllers.first as! IndentMessageViewController)

             controller.idStr = "indentview \(row)"
        }
    }
    
    /*
     * 配置你的网络环境
     */
    enum  NetworkEnvironment{
        case Development
        case Test
        case Distribution
    }
    
    
    let CurrentNetWork : NetworkEnvironment = .Test
    
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
