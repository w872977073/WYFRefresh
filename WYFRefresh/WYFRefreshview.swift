//
//  WYFRefreshview.swift
//  WYFRefresh
//
//  Created by wyf on 2017/8/29.
//  Copyright © 2017年 FanFanKJ. All rights reserved.
//

import UIKit

class WYFRefreshview: UIView {

    var  refreshState:WYFRefreshState = .Nomal {
        
        didSet{
            
            // 箭头在刷新的时候是隐藏的
            tipImageview.isHidden = refreshState == .WillRefresh
            
            // 在不同状态下显示不同的提示文字
            switch refreshState {
            case .Nomal:
                tipLabel.text = "下拉刷新"
                indicator.stopAnimating()
                UIView.animate(withDuration: 0.25, animations: { 
                    self.tipImageview.transform = CGAffineTransform.identity
                })
            case .Puling:
                tipLabel.text = "松手开始刷新"
                UIView.animate(withDuration: 0.25, animations: {
                    
                    self.tipImageview.transform = CGAffineTransform(rotationAngle:.pi)
                })
            case .WillRefresh:
                tipLabel.text = "正在刷新"
                indicator.startAnimating()
            }
        }
    }

    /// 提示器图片
    @IBOutlet weak var tipImageview: UIImageView!
    
    /// 指示器
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    /// 提示标签
    @IBOutlet weak var tipLabel: UILabel!
    
    class func refreshview()->WYFRefreshview{
        
        let nib = UINib(nibName: "WYFRefreshView", bundle: nil)
        
        return nib.instantiate(withOwner: nil, options: nil)[0] as! WYFRefreshview
    }
}
