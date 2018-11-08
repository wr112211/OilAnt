//
//  PageContentView.swift
//  页面导航
//
//  Created by mxw on 2018/11/7.
//  Copyright © 2018 mxw. All rights reserved.
//

import UIKit

protocol PageContentViewDelegate: class {
    func pageContentView(contentView: PageContentView,progress:CGFloat,startIndex: Int,tagertIndex: Int)
}

class PageContentView: UIView,UICollectionViewDataSource,UICollectionViewDelegate {
    
    
    //构造函数,传入子控制器和父控制器
    private var childViewControllers: [UIViewController]
    private weak var parentViewController: UIViewController?
    private var startOffsetX: CGFloat = 0
    weak var delegate:PageContentViewDelegate?
    private var isForbidScrollDelgate: Bool = false
    
    lazy var collectionView:UICollectionView = { [weak self] in
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = self!.bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        return collectionView
        }()
    
    init(frame: CGRect,childViewControllers: [UIViewController],parentViewController: UIViewController) {
        self.childViewControllers = childViewControllers
        self.parentViewController = parentViewController
        super.init(frame: frame)
        // 设置子控件
        addSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: 数据源方法
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childViewControllers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let childVc = childViewControllers[indexPath.item]
        cell.contentView.subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        childVc.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childVc.view)
        return cell
    }
    //MARK: 代理方法
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isForbidScrollDelgate {
            return
        }
        //滑动的进度
        var progress:CGFloat = 0
        //开始的时候label的index
        var startIndex:Int = 0
        //目标的index
        var targetIndex:Int = 0
        //判断左滑还是右
        let currentOffsetX = scrollView.contentOffset.x
        if currentOffsetX > startOffsetX {//左滑动
            //用x的偏移量除以个宽度,这个数字会大于1,然后减去它的整数部分,剩下小数部分就是移动的比例.
            progress =  currentOffsetX / scrollView.bounds.width - floor(currentOffsetX / scrollView.bounds.width)
            //当前偏移量除以宽度,取整,就是当前的index
            startIndex = Int(currentOffsetX / scrollView.bounds.width)
            targetIndex = startIndex + 1
            if targetIndex >= childViewControllers.count - 1 {
                targetIndex = childViewControllers.count - 1
            }
            if currentOffsetX - startOffsetX == scrollView.bounds.width {
                progress = 1.0
                targetIndex = startIndex
            }
            
        }else {//右滑与左滑相反
            progress = 1 - (currentOffsetX / scrollView.bounds.width - floor(currentOffsetX / scrollView.bounds.width))
            targetIndex = Int(currentOffsetX / scrollView.bounds.width)
            startIndex = targetIndex + 1
            if startIndex >= childViewControllers.count - 1 {
                startIndex = childViewControllers.count - 1
            }
        }
        delegate?.pageContentView(contentView: self, progress: progress, startIndex: startIndex, tagertIndex: targetIndex)
        
        
        
        
    }
    //开始拖拽的时候
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isForbidScrollDelgate = false
        startOffsetX = scrollView.contentOffset.x
    }
}

extension PageContentView {
    private func addSubviews(){
        //添加子控制器
        childViewControllers.forEach { (vc) in
            parentViewController!.addChild(vc)
        }
        //添加个collectionView
        addSubview(collectionView)
        collectionView.frame = bounds
    }
}
//MARK: api
extension PageContentView {
    func setCurrentIIndex(currentIIndex: Int)  {
        isForbidScrollDelgate = true
        
        let offsetX = CGFloat(currentIIndex) * collectionView.frame.width
        collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: false)
    }
}
