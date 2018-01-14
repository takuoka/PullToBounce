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
        color: UIColor! = UIColor.white
        )
    {
        var color = color
        if color == nil {
            color = UIColor.white
        }
        
        let ballViewHeight: CGFloat = 100
        
        ballView = BallView(
            frame: CGRect(x: 0, y: -(ballViewHeight + 1), width: frame.width, height: ballViewHeight),
            circleSize: ballSize,
            timingFunc: ballMoveTimingFunc,
            moveUpDuration: moveUpDuration,
            moveUpDist: moveUpDist,
            color: color!
        )
        
        waveView = WaveView(
            frame:CGRect(x: 0, y: 0, width: ballView.frame.width, height: frame.height),
            bounceDuration: bounceDuration,
            color: color!
        )
        
        super.init(frame: frame)
        
        ballView.isHidden = true
        
        self.addSubview(ballView)
        self.addSubview(waveView)
        
        waveView.didEndPull = {
            _ = Timer.schedule(delay: 0.2) { timer in
                self.ballView.isHidden = false
                self.ballView.startAnimation()
            }
        }
    }
    
    func endingAnimation(_ complition:(()->())? = nil) {
        ballView.endAnimation {
            self.ballView.isHidden = true
            complition?()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func wave(_ y: CGFloat) {
        waveView.wave(y)
    }
    
    func didRelease(_ y: CGFloat) {
        waveView.didRelease(amountX: 0, amountY: y)
    }
}
