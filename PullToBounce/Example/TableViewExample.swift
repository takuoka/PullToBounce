//
//  TableViewExample.swift
//  PullToBounce
//
//  Created by Takuya Okamoto on 2015/08/12.
//  Copyright (c) 2015年 Uniface. All rights reserved.
//

import UIKit

class TableViewExample: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.view.backgroundColor = UIColor(red: 0.207843, green: 0.611765, blue: 0.890196, alpha: 1)
        self.view.backgroundColor = UIColor(red:0.545098, green: 0.560784, blue: 0.690196, alpha: 1)
        
        
        let bodyView = UIView()
        bodyView.frame = self.view.frame
        bodyView.frame.y += 20 + 44
        self.view.addSubview(bodyView)
        
        let tableView = SampleTableView(frame: self.view.frame, style: UITableViewStyle.Plain)

        //🌟 Usage
        let wrapper = PullToBounceScrollViewWrapper(scrollView: tableView)
        bodyView.addSubview(wrapper)
        
        
        wrapper.didPullToRefresh = {
            NSTimer.schedule(delay: 3) { timer in
                wrapper.stopLoadingAnimation()
            }
        }
        
        makeMock()
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    func makeMock() {
        let headerView = UIView()
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 64)
        headerView.backgroundColor = UIColor(red:0.752941, green: 0.768627, blue: 0.839216, alpha: 1)
        self.view.addSubview(headerView)
        
        let headerLine = UIView()
        headerLine.frame = CGRect(x: 0, y: 0, width: 120, height: 8)
        headerLine.layer.cornerRadius = headerLine.frame.height/2
        headerLine.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.8)
        headerLine.center = CGPoint(x: headerView.frame.center.x, y: 20 + 44/2)
        headerView.addSubview(headerLine)
    }
}
