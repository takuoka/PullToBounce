//
//  PullToBounseScrollViewWrapper.swift
//  Bounse
//
//  Created by Takuya Okamoto on 2015/08/12.
//  Copyright (c) 2015年 Uniface. All rights reserved.
//

// Inspired by https://dribbble.com/shots/1797373-Pull-Down-To-Refresh

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}



open class PullToBounceWrapper: UIView {

    var pullDist: CGFloat = 80
    var bendDist: CGFloat = 40
    var stopPos:CGFloat {
        get {
            return pullDist + bendDist
        }
    }

    open var didPullToRefresh: (()->())?
    
    var bounceView: BounceView!
    open var scrollView: UIScrollView?

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
        if scrollView.frame == CGRect.zero {
            assert(false, "Wow, scrollView.frame is CGRectZero. Please set frame size.")
        }
        super.init(frame: scrollView.frame)

        self.pullDist = pullDistance
        self.bendDist = bendDistance
        self.didPullToRefresh = didPullToRefresh
        
        let moveUpDist = pullDist/2 + ballSize/2
			
        bounceView = BounceView(
            frame: scrollView.frame
						, bounceDuration: bounceDuration
						, ballSize: ballSize
						, ballMoveTimingFunc: ballMoveTimingFunc
						, moveUpDuration: moveUpDuration
						, moveUpDist: moveUpDist
            , color: scrollView.backgroundColor
        )
        self.addSubview(bounceView)
        
        self.scrollView = scrollView
//        scrollView.frame = self.frame
        scrollView.backgroundColor = UIColor.clear
        self.addSubview(scrollView)
        scrollView.addObserver(self, forKeyPath: contentOffsetKeyPath, options: .initial, context: &KVOContext)
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
                scrollView?.isScrollEnabled = false
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
    
    open func stopLoadingAnimation() {
        bounceView.endingAnimation {
            self.scrollView?.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            self.scrollView?.isScrollEnabled = true
        }
    }
    
    // MARK: ScrollView KVO
    fileprivate var KVOContext = "PullToRefreshKVOContext"
    fileprivate let contentOffsetKeyPath = "contentOffset"
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (context == &KVOContext && keyPath == contentOffsetKeyPath && object as? UIScrollView == scrollView) {
            scrollViewDidScroll()
        }
        else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
}
