//
//  IndentMessageViewController.swift
//  OilAnt
//
//  Created by 王瑞 on 2018/11/6.
//  Copyright © 2018年 王瑞. All rights reserved.
//

import UIKit

class IndentMessageViewController: UIViewController, MAMapViewDelegate, AMapSearchDelegate, AMapNaviWalkManagerDelegate {
    
    var idStr = ""
    var mapView: MAMapView!
    var search: AMapSearchAPI!
    var pin : MyPinAnnotation!
    var pinView: MAAnnotationView!
    var nearBySearch = true
    var start,end : CLLocationCoordinate2D!
    var walkManager: AMapNaviWalkManager!
    
    @IBOutlet weak var panelView: UIView!
    
    //
    func searchBikeNearby(){
        searchCustomerLocation(mapView.userLocation.coordinate)
    }
    
    //搜索周边小黄车请求
    func searchCustomerLocation(_ center: CLLocationCoordinate2D) {
        let request = AMapPOIAroundSearchRequest()
        request.location = AMapGeoPoint.location(withLatitude: CGFloat(center.latitude), longitude: CGFloat(center.longitude))
        request.keywords = "餐馆"
        request.radius = 500
        request.requireExtension = true
        
        search.aMapPOIAroundSearch(request)
    }
    
    // MARK: - 大头针动画
    func pinAnimtion(){
        let endFram = pinView.frame
        pinView.frame = endFram.offsetBy(dx: 0, dy: 0)
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0, options: [], animations: {
            self.pinView.frame = endFram
        }, completion: nil)
    }
    
    // MARK: - Map View Delegate
    
    func mapView(_ mapView: MAMapView!, didSelect view: MAAnnotationView!) {
        print("点击了我")
        
        start = pin.coordinate
        end = view.annotation.coordinate
        
        let startPoint = AMapNaviPoint.location(withLatitude: CGFloat(start.latitude), longitude: CGFloat(end.longitude))!
        let endPoint = AMapNaviPoint.location(withLatitude: CGFloat(end.latitude), longitude: CGFloat(end.longitude))!
        
        walkManager.calculateWalkRoute(withStart:[startPoint], end: [endPoint])
    }
    
    func mapView(_ mapView: MAMapView!, didAddAnnotationViews views: [Any]!) {
        let aViews = views as! [MAAnnotationView]
        
        for aView in aViews {
            guard aView.annotation is MAPinAnnotationView else {
                continue
            }
            
            aView.transform = CGAffineTransform(scaleX: 0, y: 0)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0, options: [], animations: {
                aView.transform = .identity
            }, completion: nil)
        }
    }
    
    //用户移动地图交互
    func mapView(_ mapView: MAMapView!, mapDisMoveByUser wasUserAction: Bool) {
        if wasUserAction {
            pin.isLockedToScreen = true
            pinAnimtion()
            searchCustomerLocation(mapView.centerCoordinate)
        }
    }
    
    //地图初始化完成后
    func mapInitComplete(_ mapView: MAMapView!) {
        pin = MyPinAnnotation()
        pin.coordinate = mapView.centerCoordinate
        pin.lockedScreenPoint = CGPoint(x:view.bounds.width/2,y:view.bounds.height/2)
        pin.isLockedToScreen = true
        
        mapView.addAnnotation(pin)
        mapView.showAnnotations([pin],animated:true)
    }
    
    //自定义大头针视图
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotationView!) -> MAAnnotationView! {
        if annotation is MAUserLocation{
            //用户定位位置
            return nil
        }
        
        if annotation is MyPinAnnotation {
            let reuseid = "anchor"
            var av = mapView.dequeueReusableAnnotationView(withIdentifier: reuseid)
            if av == nil {
                av = MAPinAnnotationView(annotation: annotation as! MAAnnotation, reuseIdentifier: reuseid)
            }
            av?.image = UIImage(named: "icon_main_location")
            av?.canShowCallout = false
            
            pinView = av
            
            return av
        }
        let reuseid = "myid"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseid) as? MAAnnotationView
        
        if annotationView == nil {
            annotationView = MAPinAnnotationView(annotation: annotation as! MAAnnotation, reuseIdentifier: reuseid)
        }
        
        //        if annotation.title == "正常可用" {
        //            annotationView?.image = UIImage(named: "icon_main_location")
        //        } else {
        //            annotationView?.image = UIImage(named: "icon_main_location")
        //        }
        //        annotationView?.canShowCallout = true
        //        annotationView?.animatesDrop = true
        
        return annotationView
    }
    
    // MARK: - Map Search Delegate
    //搜索周边完成后的处理
    func onPOISearchDone(_ request: AMapPOISearchBaseRequest!, response: AMapPOISearchResponse!) {
        guard response.count > 0 else {
            print("周边没有小黄车")
            return
        }
        var annotations : [MAPointAnnotation] = []
        for poi in response.pois{
            print(poi.name)
        }
        annotations = response.pois.map{
            let annotation = MAPointAnnotation()
            
            annotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees($0.location.latitude), longitude: CLLocationDegrees($0.location.longitude))
            
            if $0.distance < 200 {
                annotation.title = "红包区域内开锁任意i小黄车"
                annotation.subtitle = "骑行10分钟l可获得现金红包"
            } else {
                annotation.title = "正常可用"
            }
            
            return annotation
        }
        
        mapView.addAnnotations(annotations)
        
        if nearBySearch {
            mapView.showAnnotations(annotations, animated: true)
            nearBySearch = !nearBySearch
        }
    }
    
    // MARK: - AMapNaviWalkManagerDelegate 导航代理
    func walkManager(onCalculateRouteSuccess walkManager: AMapNaviWalkManager) {
        print("步行路线规划成功！")
    }
    
    func walkManager(_ walkManager: AMapNaviWalkManager, onCalculateRouteFailure error: Error) {
        print("路径规划失败", error)
    }
    
    //返回按钮点击响应
    @objc func backToPrevious(){
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(panelView)
        
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
        
        search = AMapSearchAPI()
        search.delegate = self
        
        searchBikeNearby()
        
        walkManager = AMapNaviWalkManager()
        walkManager.delegate = self
        
        
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
