//
//  PullToBounseScrollViewWrapper.swift
//  Bounse
//
//  Created by Takuya Okamoto on 2015/08/12.
//  Copyright (c) 2015年 Uniface. All rights reserved.
//

// Inspired by https://dribbble.com/shots/1797373-Pull-Down-To-Refresh

import UIKit


public class PullToBounceWrapper: UIView {

    var pullDist: CGFloat = 80
    var bendDist: CGFloat = 40
    var stopPos:CGFloat {
        get {
            return pullDist + bendDist
        }
    }

    public var didPullToRefresh: (()->())?
    
    var bounceView: BounceView!
    public var scrollView: UIScrollView?

    /**
    Please addSubView this insted of your scrollView.
    The only required parameter is scrollView.
    And you can customize animation by other parameters.
    */
    public init(
        scrollView: UIScrollView,
        bounceDuration: CFTimeInterval = 0.8,
        ballSize:CGFloat = 36,
        ballMoveTimingFunc:CAMediaTimingFunction = CAMediaTimingFunction(controlPoints:0.49,0.13,0.29,1.61),
        moveUpDuration:CFTimeInterval = 0.25,
        pullDistance: CGFloat = 96,
        bendDistance: CGFloat = 40,
        didPullToRefresh: (()->())? = nil
        )
    {
        if scrollView.frame == CGRectZero {
            assert(false, "Wow, scrollView.frame is CGRectZero. Please set frame size.")
        }
        super.init(frame: scrollView.frame)

        self.pullDist = pullDistance
        self.bendDist = bendDistance
        self.didPullToRefresh = didPullToRefresh
        
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
    
    public required init?(coder aDecoder: NSCoder) {
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
    
    public func stopLoadingAnimation() {
        bounceView.endingAnimation {
            self.scrollView?.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            self.scrollView?.scrollEnabled = true
        }
    }
    
    // MARK: ScrollView KVO
    private var KVOContext = "PullToRefreshKVOContext"
    private let contentOffsetKeyPath = "contentOffset"
    public override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<()>) {
        if (context == &KVOContext && keyPath == contentOffsetKeyPath && object as? UIScrollView == scrollView) {
            scrollViewDidScroll()
        }
        else {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
}