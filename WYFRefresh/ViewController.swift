//
//  ViewController.swift
//  WYFRefresh
//
//  Created by wyf on 2017/8/27.
//  Copyright © 2017年 FanFanKJ. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    lazy  var refreshControl:WYFRefreshContro = WYFRefreshContro()
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.addSubview(refreshControl)
        
        refreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
        
        loadData()
    }

    @objc func loadData() {
        
        print("开始刷新")
        refreshControl.begaiRefreshing()        
        DispatchQueue.main.asyncAfter(deadline:DispatchTime.now() + 3 ) {
            
            print("结束刷新")
            
            self.refreshControl.endRefreshing()
        }
    }

}

