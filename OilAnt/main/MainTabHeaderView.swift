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
    
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//    }
//
//    var contentView:UIView!
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        contentView = loadXib()
//        addSubview(contentView)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        contentView = loadXib()
//        addSubview(contentView)
//
//    }
//
//    func loadXib() ->UIView {
//        let className = type(of:self)
//        let bundle = Bundle(for:className)
//        let name = NSStringFromClass(className).components(separatedBy: ".").last
//        let nib = UINib(nibName: name!, bundle: bundle)
//        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
//
//        return view
//    }
//  
    
}
