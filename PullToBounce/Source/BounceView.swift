//
//  ENPullToBounseView.swift
//  BezierPathAnimation
//
//  Created by Takuya Okamoto on 2015/08/11.
//  Copyright (c) 2015年 Uniface. All rights reserved.
//

import UIKit

class BounceView: UIView {
    
    let ballView : BallView!
    let waveView : WaveView!
    
    init(
        frame:CGRect,
        bounceDuration: CFTimeInterval = 0.8,
        ballSize:CGFloat = 28,//32,
        ballMoveTimingFunc:CAMediaTimingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut),
        moveUpDuration:CFTimeInterval = 0.2,
        moveUpDist: CGFloat = 32 * 1.5,
        var color: UIColor! = UIColor.whiteColor()
        )
    {
        if color == nil {
            color = UIColor.whiteColor()
        }
        
        let ballViewHeight: CGFloat = 100
        
        ballView = BallView(
            frame: CGRectMake(0, -(ballViewHeight + 1), frame.width, ballViewHeight),
            circleSize: ballSize,
            timingFunc: ballMoveTimingFunc,
            moveUpDuration: moveUpDuration,
            moveUpDist: moveUpDist,
            color: color
        )
        
        waveView = WaveView(
            frame:CGRectMake(0, 0, ballView.frame.width, frame.height),
            bounceDuration: bounceDuration,
            color: color
        )
        
        super.init(frame: frame)
        
        ballView.hidden = true
        
        self.addSubview(ballView)
        self.addSubview(waveView)
        
        waveView.didEndPull = {
            NSTimer.schedule(delay: 0.2) { timer in
                self.ballView.hidden = false
                self.ballView.startAnimation()
            }
        }
    }
    
    func endingAnimation(complition:(()->())? = nil) {
        ballView.endAnimation {
            self.ballView.hidden = true
            complition?()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func wave(y: CGFloat) {
        waveView.wave(y)
    }
    
    func didRelease(y: CGFloat) {
        waveView.didRelease(amountX: 0, amountY: y)
    }
}