//
//  PullToBounseScrollViewWrapper.swift
//  Bounse
//
//  Created by Takuya Okamoto on 2015/08/12.
//  Copyright (c) 2015年 Uniface. All rights reserved.
//

import UIKit


class PullToBounceScrollViewWrapper: UIView {

    var pullDist: CGFloat = 80
    var bendDist: CGFloat = 40
    var stopPos:CGFloat {
        get {
            return pullDist + bendDist
        }
    }
    
    var didPullToRefresh: (()->())?
    
    var bounceView: BounceView!
    var scrollView: UIScrollView?
    
    init(
        scrollView: UIScrollView,
        bounceDuration: CFTimeInterval = 0.8,
        ballSize:CGFloat = 28,//32,
        ballMoveTimingFunc:CAMediaTimingFunction = CAMediaTimingFunction(controlPoints:0.49,0.13,0.29,1.61),
        moveUpDuration:CFTimeInterval = 0.25,
        pullDist: CGFloat = 80,
        bendDist: CGFloat = 40
        )
    {
        if scrollView.frame == CGRectZero {
            assert(false, "Wow, scrollView.frame is CGRectZero. Please set frame size.")
        }
        super.init(frame: scrollView.frame)

        self.pullDist = pullDist
        self.bendDist = bendDist

        let moveUpDist = pullDist/2 + ballSize/2
        
        bounceView = BounceView(
            frame: scrollView.frame
            , color: scrollView.backgroundColor
            , moveUpDuration: moveUpDuration
            , ballMoveTimingFunc: ballMoveTimingFunc
            , bounceDuration: bounceDuration
            , ballSize: ballSize
            , moveUpDist: moveUpDist
        )
        self.addSubview(bounceView)
        
        self.scrollView = scrollView
//        scrollView.frame = self.frame
        scrollView.backgroundColor = UIColor.clearColor()
        self.addSubview(scrollView)
        scrollView.addObserver(self, forKeyPath: contentOffsetKeyPath, options: .Initial, context: &KVOContext)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        scrollView?.removeObserver(self, forKeyPath: contentOffsetKeyPath, context: &KVOContext)
    }
    
    func scrollViewDidScroll() {
        if scrollView?.contentOffset.y < 0 {
            let y = scrollView!.contentOffset.y * -1
            if y < pullDist {
                bounceView.frame.y = y
                bounceView.wave(0)
                scrollView?.alpha = (pullDist - y)/pullDist
            }
            else if y < stopPos {
                bounceView.wave(y - pullDist)
                scrollView?.alpha = 0
            }
            else if y > stopPos {
                scrollView?.scrollEnabled = false
                scrollView?.setContentOffset(CGPoint(x: scrollView!.contentOffset.x, y: -stopPos), animated: false)
                bounceView.frame.y = pullDist
                bounceView.wave(stopPos - pullDist)
                bounceView.didRelease(stopPos - pullDist)
                self.didPullToRefresh?()
                scrollView?.alpha = 0
            }
        } else {
            bounceView.frame.y = 0
            scrollView?.alpha = 1
        }
    }
    
    func stopLoadingAnimation() {
        bounceView.endingAnimation {
            self.scrollView?.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            self.scrollView?.scrollEnabled = true
        }
    }
    
    // MARK: ScrollView KVO
    private var KVOContext = "PullToRefreshKVOContext"
    private let contentOffsetKeyPath = "contentOffset"
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<()>) {
        if (context == &KVOContext && keyPath == contentOffsetKeyPath && object as? UIScrollView == scrollView) {
            scrollViewDidScroll()
        }
        else {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
}