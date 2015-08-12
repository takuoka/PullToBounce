//
//  ViewController.swift
//  PullToBounce
//
//  Created by Takuya Okamoto on 2015/08/12.
//  Copyright (c) 2015年 Uniface. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "example"
        self.view.backgroundColor = UIColor.whiteColor()

        
        let scrollExampleBtn = UIButton()
        scrollExampleBtn.frame = CGRect(x: 0, y: 0, width: 200, height: 100)
        scrollExampleBtn.center = self.view.center
        scrollExampleBtn.frame.y = scrollExampleBtn.frame.y / 3 + (scrollExampleBtn.frame.height/2)
        scrollExampleBtn.backgroundColor = UIColor.orangeColor().colorWithAlphaComponent(0.8)
        scrollExampleBtn.setTitle("UIScrollView", forState: .Normal)
        scrollExampleBtn.addTarget(self, action: "onTapScrollExpampleButton", forControlEvents: UIControlEvents.TouchUpInside)
        scrollExampleBtn.layer.cornerRadius = scrollExampleBtn.frame.height / 2
        self.view.addSubview(scrollExampleBtn)
        
        let tableViewExampleBtn = UIButton()
        tableViewExampleBtn.frame = CGRect(x: 0, y: 0, width: 200, height: 100)
        tableViewExampleBtn.center = self.view.center
        tableViewExampleBtn.backgroundColor = UIColor.blueColor().colorWithAlphaComponent(0.8)
        tableViewExampleBtn.setTitle("UITableView", forState: .Normal)
        tableViewExampleBtn.addTarget(self, action: "onTapTableExpampleButton", forControlEvents: UIControlEvents.TouchUpInside)
        tableViewExampleBtn.layer.cornerRadius = tableViewExampleBtn.frame.height / 2
        self.view.addSubview(tableViewExampleBtn)
        
        let collectionViewExampleBtn = UIButton()
        collectionViewExampleBtn.frame = CGRect(x: 0, y: 0, width: 200, height: 100)
        collectionViewExampleBtn.center = self.view.center
        collectionViewExampleBtn.frame.y = collectionViewExampleBtn.frame.y * (4/3) + (collectionViewExampleBtn.frame.height/2)
        collectionViewExampleBtn.backgroundColor = UIColor.purpleColor().colorWithAlphaComponent(0.8)
        collectionViewExampleBtn.setTitle("UICollectionView", forState: .Normal)
        collectionViewExampleBtn.addTarget(self, action: "onTapCollectionExpampleButton", forControlEvents: UIControlEvents.TouchUpInside)
        collectionViewExampleBtn.layer.cornerRadius = collectionViewExampleBtn.frame.height / 2
        self.view.addSubview(collectionViewExampleBtn)

        NSTimer.schedule(delay: 0.1) { timer in
            self.onTapTableExpampleButton()
        }
    }

    func onTapScrollExpampleButton() {
        let vc = ScrollViewExample()
        self.navigationController?.pushViewController(vc, animated: true)
//        self.presentViewController(vc, animated: true, completion: nil)
    }

    func onTapTableExpampleButton() {
        let vc = TableViewExample()
//        self.navigationController?.pushViewController(vc, animated: true)
        self.presentViewController(vc, animated: true, completion: nil)
    }

    func onTapCollectionExpampleButton() {
        let vc = CollectionViewExample()
        self.presentViewController(vc, animated: true, completion: nil)
    }

}

