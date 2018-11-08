//
//  PageTitleView.swift
//  页面导航
//
//  Created by mxw on 2018/11/7.
//  Copyright © 2018 mxw. All rights reserved.
//

import UIKit

protocol PageTitleViewDelegate: class {
    func pageTitleView(titleView: PageTitleView,sleectedIndex index: Int)
}

class PageTitleView: UIView {
    //底下线的高度
    let scrollLineHeight: CGFloat = 2
    //文字下面的滚动条
    private lazy var scrollLine: UIView = {
        let scrollLine = UIView()
        scrollLine.backgroundColor = UIColor.orange
        return scrollLine
    }()
    //label的数组,用来确定滚动的frame
    private lazy var  titleLabels:[UILabel] = []
    //目前的label的下标
    private var currentIndex: Int = 0
    private var titles:[String]
    private var  normalColor: (CGFloat,CGFloat,CGFloat) = (85,85,85)
    private var selectCorlor: (CGFloat,CGFloat,CGFloat) = (255,128,0)

    weak var delegate: PageTitleViewDelegate?
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        scrollView.isScrollEnabled = true
        scrollView.scrollsToTop = false
        return scrollView
    }()

    init(frame: CGRect,titles:[String]) {
        self.titles = titles
        super.init(frame: frame)
        addSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

//添加子控件
extension PageTitleView {

    func addSubviews() {
        //加个scrollView
        addSubview(scrollView)
        scrollView.frame = bounds

        //添加标题的label
        setupTitleLabels()
        //添加底线
        setupBottomLineView()
        scrollView.contentSize = CGSize(width:CGFloat(titleLabels.count) * titleLabels[0].frame.size.width, height: bounds.height)

    }
    private func setupTitleLabels() {
        var labelWidth:CGFloat = 0
        if titles.count >= 5 {
            labelWidth = frame.width / CGFloat(5)
        }else {
            labelWidth = frame.width / CGFloat(titles.count)
        }

        let labelHeight = frame.height - scrollLineHeight

        for (index,title) in titles.enumerated() {
            let label = UILabel()
            label.text = title
            label.textAlignment = .center
            //重要属性,将index赋值给tag,以后可以根据tag来获取到label的index
            label.tag = index
            label.font = UIFont.systemFont(ofSize: 16)
            label.textColor = UIColor.darkGray

            //设置frame
            let labelX = labelWidth * CGFloat(index)
            label.frame = CGRect(x: labelX, y: 0, width: labelWidth, height: labelHeight)
            //添加上去
            scrollView.addSubview(label)
            //保存到数组
            titleLabels.append(label)
            //添加手势(实现label的点击效果,也可以不使用label来实现,直接使用按钮来实现)
            label.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(titleLabelClicked(tap:)))
            label.addGestureRecognizer(tap)

        }

    }
    private func setupBottomLineView() {
        let bottomLineHeight:CGFloat = 0.5
        let bottomLine = UIView(frame: CGRect(x: 0, y: frame.height - bottomLineHeight, width: frame.width, height: bottomLineHeight))
        addSubview(bottomLine)
        //添加滚动线
        scrollView.addSubview(scrollLine)
        //设置farma
        let firstLabel = titleLabels[0]
        firstLabel.textColor = UIColor.orange
        scrollLine.frame = CGRect(x: firstLabel.frame.origin.x, y: frame.height - scrollLineHeight, width: firstLabel.frame.size.width, height: scrollLineHeight)

    }

    //MARK: -- 点击label的逻辑
    @objc private func titleLabelClicked(tap: UITapGestureRecognizer) {
        //让现在选中的变成橙色,原来的变灰色
        guard let currentLabel =  tap.view as? UILabel else {return}
        let oldLabel = titleLabels[currentIndex]
        //将新的label的下标保存到当前的下标
        currentIndex = currentLabel.tag
        if currentIndex != oldLabel.tag {
            currentLabel.textColor = UIColor.orange
            oldLabel.textColor = UIColor.darkGray
        }

        let scrollLineX = CGFloat(currentIndex) * scrollLine.frame.width

        self.scrollLine.frame.origin.x = scrollLineX
        //标题居中
        setTitleToCenter()


        delegate?.pageTitleView(titleView: self, sleectedIndex: currentIndex)



    }
    //MARK: 对外暴露的API
    func setTitleViewProgress(progress:CGFloat,startIndex: Int,targetIndex: Int)  {
        let startLabel = titleLabels[startIndex]
        let targetLabel = titleLabels[targetIndex]
        //处理滑块
        let moveX = (targetLabel.frame.origin.x - startLabel.frame.origin.x) * progress
        scrollLine.frame.origin.x = startLabel.frame.origin.x + moveX
        //颜色渐变
        let colorRang = (selectCorlor.0 - normalColor.0,selectCorlor.1 - normalColor.1,selectCorlor.2 - normalColor.2)
        UIView.animate(withDuration: 0.3) {
            startLabel.textColor = UIColor(red: (self.selectCorlor.0 - colorRang.0 * progress)/255.0, green: (self.selectCorlor.1 - colorRang.1 * progress)/255.0, blue: (self.selectCorlor.2 - colorRang.2 * progress)/255.0, alpha: 1.0)
            targetLabel.textColor = UIColor(red: (self.normalColor.0 + colorRang.0 * progress)/255.0, green: (self.normalColor.1 + colorRang.1 * progress)/255.0, blue: (self.normalColor.2 + colorRang.2 * progress)/255.0, alpha: 1.0)
        }

        //标题居中
        setTitleToCenter()
        currentIndex = targetIndex


    }
    //MARK:标题居中效果的逻辑
    func setTitleToCenter(){
        var offsetX = titleLabels[currentIndex].center.x - UIScreen.main.bounds.width * 0.5
        if offsetX < 0 {
            offsetX = 0
        }
        let maxOffsetX = scrollView.contentSize.width - UIScreen.main.bounds.width
        if offsetX > maxOffsetX {
            offsetX = maxOffsetX
        }

        scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
    }


}
