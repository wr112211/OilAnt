//
//  IndentMessageViewController.swift
//  OilAnt
//
//  Created by 王瑞 on 2018/11/6.
//  Copyright © 2018年 王瑞. All rights reserved.
//

import UIKit

class IndentMessageViewController: UIViewController, MAMapViewDelegate, AMapSearchDelegate, AMapNaviDriveViewDelegate,AMapNaviDriveManagerDelegate{

    var driveView : AMapNaviDriveView!
    var idStr = ""
    var mapView: MAMapView!
    var search: AMapSearchAPI!
    var pin : MyPinAnnotation!
    var pinView: MAAnnotationView!
    var nearBySearch = true
    var start,end : CLLocationCoordinate2D!
    var walkManager: AMapNaviWalkManager!

    @IBOutlet weak var panelView: UIView!

    //返回按钮点击响应
    @objc func backToPrevious(){
        print("backToPrevious")
        if(mapView != nil){
            view.willRemoveSubview(mapView)
        }
        navigationController?.popToRootViewController(animated: true)

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        print(idStr)
        
        tabBarController!.tabBar.isHidden = true
        
        let leftBarBtn = UIBarButtonItem(title: "返回", style: .plain, target: self,
                                         action: #selector(backToPrevious))
        self.navigationItem.leftBarButtonItem = leftBarBtn

        navigationItem.largeTitleDisplayMode = .never

        mapView = MAMapView(frame: view.bounds)
        view.addSubview(mapView)

//        view.bringSubviewToFront(panelView)

        mapView.delegate = self

        mapView.zoomLevel = 15
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        //请在 deinit 函数中执行 AMapNaviDriveManager.destroyInstance() 来销毁单例
        
        AMapNaviDriveManager.sharedInstance().delegate = self
        
        let startPoint = AMapNaviPoint.location(withLatitude: 39.993135, longitude: 116.474175)!
        let endPoint = AMapNaviPoint.location(withLatitude: 30.908791, longitude: 116.321257)!

        //设置车辆信息
        let info = AMapNaviVehicleInfo.init()
        info.vehicleId = "京N66Y66"; //设置车牌号
        info.type = 1;              //设置车辆类型,0:小车; 1:货车. 默认0(小车).
        info.size = 4;              //设置货车的类型(大小)
        info.width = 3;             //设置货车的宽度,范围:(0,5],单位：米
        info.height = 3.9;          //设置货车的高度,范围:(0,10],单位：米
        info.length = 15;           //设置货车的长度,范围:(0,25],单位：米
        info.weight = 50;           //设置货车的总重量,范围:(0,100]
        info.load = 45;             //设置货车的核定载重,范围:(0,100],核定载重应小于总重量
        info.axisNums = 6;          //设置货车的轴数（用来计算过路费及限重）
        let success = AMapNaviDriveManager.sharedInstance().setVehicleInfo(info)
        
        AMapNaviDriveManager.sharedInstance().calculateDriveRoute(
            withStart: [startPoint],
            end: [endPoint],
            wayPoints: nil,
            drivingStrategy: AMapNaviDrivingStrategy(rawValue: 17)!)
       
        
//        //起点
//        if annotation.coordinate.latitude == self.startPointAnimation.coordinate.latitude &&  annotation.coordinate.longitude == self.startPointAnimation.coordinate.longitude {
//            annotationView?.image = UIImage.init(named: "startPoint")
//        }
//        //终点
//        if annotation.coordinate.latitude == self.endPointAnimation.coordinate.latitude && annotation.coordinate.longitude == self.endPointAnimation.coordinate.longitude{
//            annotationView?.image = UIImage.init(named: "endPoint")
//        }
//  
    }
    
    
//    func driveManager(onCalculateRouteSuccess driveManager: AMapNaviDriveManager) {
//        NSLog("CalculateRouteSuccess")
//        //禁行信息
//        if ((driveManager.naviRoute?.forbiddenInfo.count) != 0) {
//            for info in (driveManager.naviRoute?.forbiddenInfo)! {
//                NSLog("禁行信息：类型： \(info.type)，车型： \(info.vehicleType)，道路名： \(info.roadName)，禁行时间段： \(info.timeDescription)，经纬度： \(info.coordinate)")
//            }
//        }
//        
//        //限行设施
//        if ((driveManager.naviRoute?.roadFacilityInfo.count) != 0) {
//            for info in (driveManager.naviRoute?.roadFacilityInfo)! {
//                NSLog("限行信息：类型： \(info.type.rawValue)，道路名： \(info.roadName)，经纬度： \(info.coordinate)")
//            }
//        }
//        
//    }
    
    func initDriveView() {
        driveView = AMapNaviDriveView(frame: view.bounds)
        driveView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        driveView.delegate = self
        
        view.addSubview(driveView)
    }
    
    deinit {
        AMapNaviDriveManager.sharedInstance().stopNavi()
        AMapNaviDriveManager.sharedInstance().removeDataRepresentative(driveView)
        AMapNaviDriveManager.sharedInstance().delegate = nil
        
        let success = AMapNaviDriveManager.destroyInstance()
        NSLog("单例是否销毁成功 : \(success)")
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
