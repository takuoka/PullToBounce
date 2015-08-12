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
        self.view.backgroundColor = UIColor(red: 0.207843, green: 0.611765, blue: 0.890196, alpha: 1)
        let page = UIView()
        page.frame = self.view.frame
        page.frame.y += 20 + 44
        self.view.addSubview(page)
        
        let tableView = UITableView()
        tableView.frame = self.view.frame

        //🌟 Usage
        let wrapper = PullToBounceScrollViewWrapper(scrollView: tableView)
        page.addSubview(wrapper)
        
        
        wrapper.didPullToRefresh = {
            NSTimer.schedule(delay: 3) { timer in
                wrapper.stopLoadingAnimation()
            }
        }
    }
}
