//
//  IndentMessageViewController.swift
//  OilAnt
//
//  Created by 王瑞 on 2018/11/6.
//  Copyright © 2018年 王瑞. All rights reserved.
//

import UIKit

class IndentMessageViewController: UIViewController, MAMapViewDelegate, AMapSearchDelegate, AMapNaviWalkManagerDelegate{

    
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
