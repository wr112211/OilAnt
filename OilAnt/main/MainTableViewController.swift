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
import MJRefresh


let SERVICE_URL = "http://ymyapp.plan-solve.com";//testoil  //ymyapp
let advancedSearch = "/carry/combinedQuery";//首页筛选

//DelegatePush登陆成功回调刷新主页
class MainTableViewController: UITableViewController, DelegatePush {
    //DelegatePush登陆成功回调刷新主页
    func method() {
        self.requestList()
    }
    

    private var indentList = [IndentEntry]()
    
    private var indentListNet = [IndentEntry]()
    
    let userDefault = UserDefaults.standard

    var headerView: UIView!
    
    var pageNumber = 0
    
    //顶部下拉刷新
    //let top_header = MJRefreshNormalHeader()//这个是原声的样式,不能自定一图片轮播
    let top_header_style = MJRefreshGifHeader()//这个可以设置下拉刷新的图片动画效果
    //底部上拉加载
    let bottom_footer = MJRefreshAutoNormalFooter()
 
    //顶部下拉刷新时执行的函数
    @objc func headerRefresh(){
        print("下拉刷新了")
        self.pageNumber = 0
        //服务器请求数据的函数
        self.requestList()
    }
    
    //上拉加载执行的函数
    @objc func buttomFooterLoad(){
        print("上拉加载")
        //服务器请求数据的函数
        self.requestList()
    }
    
    //初始化下拉刷新/上拉加载
    func initMJRefresh(){
        //下拉刷新相关设置
        top_header_style.setRefreshingTarget(self, refreshingAction: #selector(MainTableViewController.headerRefresh))
        // Set the ordinary state of animated images
//        var idleImages = [UIImage]()
//        //添加动画图片
//        for i in 1...3 {
//            idleImages.append(UIImage(named:"b\(i)")!)
//        }
//        top_header_style.setImages(idleImages, for: .idle)
//
//        top_header_style.setImages(idleImages, for: .pulling)
//
//        top_header_style.setImages(idleImages, for: .refreshing)
        //隐藏时间
        top_header_style.lastUpdatedTimeLabel.isHidden = true
        //隐藏状态
        top_header_style.stateLabel.isHidden = true
        //将下拉刷新控件与 tableView控件绑定起来
        self.tableView.mj_header = top_header_style
    
        //初始化上拉加载
        init_bottomFooter()
    }
    
    //上拉加载初始化设置
    func init_bottomFooter(){
        //上刷新相关设置
        bottom_footer.setRefreshingTarget(self, refreshingAction: #selector(MainTableViewController.buttomFooterLoad))
        //self.bottom_footer.stateLabel.isHidden = true // 隐藏文字
        //是否自动加载（默认为true，即表格滑到底部就自动加载,这个我建议关掉,要不然效果会不好）
        bottom_footer.isAutomaticallyRefresh = false
        bottom_footer.isAutomaticallyChangeAlpha = true //自动更改透明度
        //修改文字
        bottom_footer.setTitle("上拉上拉上拉", for: .idle)//普通闲置的状态
        bottom_footer.setTitle("加载加载加载", for: .refreshing)//正在刷新的状态
        bottom_footer.setTitle("没有没有更多数据了", for: .noMoreData)//数据加载完毕的状态
        //将上拉加载的控件与 tableView控件绑定起来
        self.tableView.mj_footer = bottom_footer
    }
   
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
//        let mainView = CitySelectorViewController()
//        //跳转
//        self.navigationController?.pushViewController(mainView , animated: true)
        
        let vc = CitySelectorViewController.init()
        gy_showSide(configuration: { (config) in
            config.direction = .right
            config.animationType = .translationMask
        }, viewController: vc)
    }
    
    @objc func picTap2()
    {
        print("endLocation")
        //实例化一个将要跳转的viewController
        let mainView = CitySelectorViewController()
        //跳转
//        self.present(mainView , animated: true, completion: nil)
        self.navigationController?.pushViewController(mainView , animated: true)
        
        
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
     
        
        initMJRefresh()
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
            "pageNumber": pageNumber,
            "keyWord": "",
            //            "processes": "",
            "pageSize": "20",
            //            "finishCity" : ""
            ] as [String : Any]
        
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
                    self.tableView.mj_footer.endRefreshing()
                } else {
                    if(self.pageNumber == 0){
                        self.indentList = [IndentEntry]()
                    }
                    self.indentListNet = baseModel.data!
                    //                    DispatchQueue.main.async { [weak self] in
                    if(self.indentListNet.count > 0){
                        self.pageNumber = Int(self.pageNumber) + 1
                        self.tableView.mj_footer.endRefreshing()
                    } else {
                        //结束刷新
                        self.tableView.mj_footer.endRefreshingWithNoMoreData()
                    }
                    self.indentList = self.indentList + self.indentListNet
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
