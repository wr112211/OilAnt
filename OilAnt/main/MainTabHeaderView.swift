//
//  MainTabHeaderView.swift
//  OilAnt
//
//  Created by 王瑞 on 2018/11/7.
//  Copyright © 2018年 王瑞. All rights reserved.
//

import UIKit

class MainTabHeaderView: UIView {
    @IBOutlet weak var beginLocation: UILabel!
    @IBOutlet weak var endLocation: UILabel!
    @IBOutlet weak var filterLable: UILabel!
    @IBOutlet weak var searchKey: UITextField!
    @IBOutlet weak var searchBtn: UIImageView!
   
    
    class func instantiateFromNib() -> MainTabHeaderView {
        return Bundle.main.loadNibNamed("MainTabHeaderView", owner: nil, options: nil)?.first as! MainTabHeaderView
    }
    
}
