//
//  IndentTabController.swift
//  OilAnt
//
//  Created by 王瑞 on 2018/11/8.
//  Copyright © 2018年 王瑞. All rights reserved.
//

import UIKit

class IndentTabController: UIViewController,PageTitleViewDelegate,PageContentViewDelegate {
    
    func pageContentView(contentView: PageContentView, progress: CGFloat, startIndex: Int, tagertIndex: Int) {
        pageTitleView.setTitleViewProgress(progress: progress, startIndex: startIndex, targetIndex: tagertIndex)
    }
    
    func pageTitleView(titleView: PageTitleView, sleectedIndex index: Int) {
        pageContentView.setCurrentIIndex(currentIIndex: index)
    }
    
    lazy var titles = ["进行中","已完成","已取消"]
    
    private lazy var pageTitleView:PageTitleView = {[weak self] in
        let pageTitleView = PageTitleView(frame: CGRect(x: 0, y: 65, width: UIScreen.main.bounds.width, height: 44), titles: titles)
        pageTitleView.delegate = self
        return pageTitleView
    }()
    
    private lazy var pageContentView: PageContentView = {[weak self] in
        let height = UIScreen.main.bounds.height - 85 - 44
        let contentFrame = CGRect(x: 0, y: 85 + 44, width: UIScreen.main.bounds.width, height: height)
        //注意:这个集合用UIviewController
        var childVcs = [UIViewController]()
        //添加子控制器,和标题的相同次数,这里我直接循环添加了进行演示,控制器的view内容,直接用随机颜色进行演示.实际使用中,需将要添加的控制器类先定义好,然后初始化分别添加.
        
        
        for _ in 0..<titles.count {
            // 注意这里的写法!!!加载sb用这玩意
            let vc  = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "IndentTableViewController")
            //            vc.view.backgroundColor = UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1.0)
            childVcs.append(vc)
        }
        let pageContentView = PageContentView(frame: contentFrame, childViewControllers: childVcs, parentViewController: self!)
        pageContentView.delegate = self
        return pageContentView
        }()
//    private lazy var pageContentView: PageContentView = {[weak self] in
//        let height = UIScreen.main.bounds.height - 65 - 44
//        let contentFrame = CGRect(x: 0, y: 65 + 44, width: UIScreen.main.bounds.width, height: height)
//        var childVcs = [IndentTableViewController]()
//        //添加子控制器,和标题的相同次数,这里我直接循环添加了进行演示,控制器的view内容,直接用随机颜色进行演示.实际使用中,需将要添加的控制器类先定义好,然后初始化分别添加.
//
//        let vc  = IndentTableViewController()
//        for _ in 0..<titles.count {
//            vc.view.backgroundColor = UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1.0)
//            childVcs.append(vc)
//        }
//        let pageContentView = PageContentView(frame: contentFrame, childViewControllers: childVcs, parentViewController: self!)
//        pageContentView.delegate = self
//        return pageContentView
//     }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor.orange
        //
        self.navigationItem.title = "我的订单"
        
        setup()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func setup() {
        view.addSubview(pageTitleView)
        view.addSubview(pageContentView)
        
    }
    
    
}

