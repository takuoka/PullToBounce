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
        self.view.backgroundColor = UIColor.customBlue
        let bodyView = UIView()
        bodyView.frame = self.view.frame
        bodyView.frame.y += 20 + 44
        self.view.addSubview(bodyView)
        
        let tableView = SampleTableView(frame: self.view.frame, style: UITableViewStyle.plain)

        //🌟 Usage
        let tableViewWrapper = PullToBounceWrapper(scrollView: tableView)
        bodyView.addSubview(tableViewWrapper)

        tableViewWrapper.didPullToRefresh = {
            Timer.schedule(delay: 2) { timer in
                tableViewWrapper.stopLoadingAnimation()
            }
        }

        makeMock()
    }

    func makeMock() {
        let headerView = UIView()
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 64)
        headerView.backgroundColor = UIColor.lightBlue
        self.view.addSubview(headerView)
        
        let headerLine = UIView()
        headerLine.frame = CGRect(x: 0, y: 0, width: 120, height: 8)
        headerLine.layer.cornerRadius = headerLine.frame.height/2
        headerLine.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        headerLine.center = CGPoint(x: headerView.frame.center.x, y: 20 + 44/2)
        headerView.addSubview(headerLine)
    }

    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
}
