//
//  WYFRefreshContro.swift
//  WYFRefresh
//
//  Created by wyf on 2017/8/27.
//  Copyright © 2017年 FanFanKJ. All rights reserved.
//

import UIKit


fileprivate let limitHeiht:CGFloat = 70

enum WYFRefreshState {
    case Nomal
    case Puling
    case WillRefresh
}
class WYFRefreshContro: UIControl {

    private weak var scrollview: UIScrollView?
    fileprivate lazy var refreshview:WYFRefreshview = WYFRefreshview.refreshview()
    
    // 纯代码情况下自定义控件
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    // 非纯代码情况下需要调用
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        fatalError("init(coder:) has not been implemented")
        
//        setupUI()
    }
    
    /// 开始刷新
    func begaiRefreshing() {
        
        guard let sv =  scrollview else {
            
            return
        }
        /**
         如果已经是刷新中了就直接返回
         */
        if self.refreshview.refreshState == .WillRefresh {
            
            return
        }
        /**
            当开始刷新的时候，改变刷新控件的状态，
            改变滚动视图的内边距为了使刷新控件可以显露出来
         
         */
        refreshview.refreshState = .WillRefresh
        clipsToBounds = false
        var inset = sv.contentInset
        inset.top = inset.top + refreshview.bounds.height
        sv.contentInset = inset

    }
    
    /// 结束刷新
    func endRefreshing()  {
        
        guard let sv =  scrollview else {
            
            return
        }
        /**
         
         如果已经结束了，再次调用结束方法就直接返回
         
         */
        if self.refreshview.refreshState != .WillRefresh {
            
            return
        }
        /**
            进入结束刷新时候，首先要改变刷新状态为正常
            要将刷新控件的内边距减小，隐藏视图
         */
        self.refreshview.refreshState = .Nomal
        self.clipsToBounds = true
        var inset = sv.contentInset
        inset.top = inset.top - self.refreshview.bounds.height
        
        UIView.animate(withDuration: 0.5, animations: {
            
            sv.contentInset = inset
            
        })

    }
    /**
      当子控件添加到父视图的时候会调用
     当父视图被移除的时候也会调用
     */
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        // 判断父视图类型
        guard let sv = newSuperview as? UIScrollView else {
            
            return
        }
        scrollview = sv
        // kvo监听滚动视图
        scrollview?.addObserver(self, forKeyPath: "contentOffset", options: [], context: nil)
    }
    
    // 所有kvo会统一调用此方法
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        // 判断父视图类型
        guard let sv =  scrollview else {
            
            return
        }
        /// height 是刷新控件的高度
        let height = -(sv.contentOffset.y + sv.contentInset.top)
        
        if height < 0  {
            
            return
        }
        
        self.frame = CGRect(x: 0, y: -height, width: sv.bounds.width, height:height)
        
        // 在拖拽情况下
        if sv.isDragging{
            
             if height > limitHeiht  && (refreshview.refreshState == .Nomal) {
                
                refreshview.refreshState = .Puling
            }else if height <= limitHeiht && (refreshview.refreshState == .Puling){
                
                refreshview.refreshState = .Nomal
            }
        }else{
            
            if refreshview.refreshState == .Puling {
                
                   begaiRefreshing()
                
//                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3, execute: {
//                    
//                    self.endRefreshing()
//
//                })
                
                sendActions(for: .valueChanged)
                
            }

        }

    }
    
    override func removeFromSuperview() {
        
        // 移除监听
        superview?.removeObserver(self, forKeyPath: "contentOffset")
        
        super.removeFromSuperview()
        
        
    }
    
}

extension WYFRefreshContro{
    // MARK: - 刷新控件视图自动布局
    func setupUI() {
        
        backgroundColor = superview?.backgroundColor
        clipsToBounds = true
        addSubview(refreshview)
        refreshview.translatesAutoresizingMaskIntoConstraints = false
        
        addConstraint(NSLayoutConstraint(item: refreshview,
                           attribute: .centerX,
                           relatedBy: .equal,
                           toItem: self,
                           attribute: .centerX,
                           multiplier: 1.0,
                           constant: 0))
        
        addConstraint(NSLayoutConstraint(item: refreshview,
                                         attribute: .bottom,
                                         relatedBy: .equal,
                                         toItem: self,
                                         attribute: .bottom,
                                         multiplier: 1.0,
                                         constant: 0))
        
        addConstraint(NSLayoutConstraint(item: refreshview,
                                         attribute: .height,
                                         relatedBy: .equal,
                                         toItem: nil,
                                         attribute: .notAnAttribute,
                                         multiplier: 1.0,
                                         constant: refreshview.bounds.height))
        
        addConstraint(NSLayoutConstraint(item: refreshview,
                                         attribute: .width,
                                         relatedBy: .equal,
                                         toItem: nil,
                                         attribute: .notAnAttribute,
                                         multiplier: 1.0,
                                         constant: refreshview.bounds.width))

        
        
    }
}
