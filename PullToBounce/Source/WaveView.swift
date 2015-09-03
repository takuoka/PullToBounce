//
//  PullToWaveView.swift
//  BezierPathAnimation
//
//  Created by Takuya Okamoto on 2015/08/11.
//  Copyright (c) 2015年 Uniface. All rights reserved.
//

import UIKit

class WaveView: UIView, UIGestureRecognizerDelegate {

    var didEndPull: (()->())?
    var bounceDuration:CFTimeInterval!
    var waveLayer:CAShapeLayer!

    init(frame:CGRect, bounceDuration:CFTimeInterval = 0.4, color:UIColor = UIColor.whiteColor()) {
        self.bounceDuration = bounceDuration
        super.init(frame:frame)

        waveLayer = CAShapeLayer(layer: self.layer)
        waveLayer.lineWidth = 0
        waveLayer.path = wavePath(amountX: 0.0, amountY: 0.0)
        waveLayer.strokeColor = color.CGColor
        waveLayer.fillColor = color.CGColor
        self.layer.addSublayer(waveLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func wave(y:CGFloat) {
        self.waveLayer.path = self.wavePath(amountX: 0, amountY: y)
    }
    
    func didRelease(amountX amountX: CGFloat,amountY: CGFloat) {
        self.boundAnimation(positionX: amountX, positionY: amountY)
        didEndPull?()
    }
    
    func boundAnimation(positionX positionX: CGFloat,positionY: CGFloat) {
        self.waveLayer.path = self.wavePath(amountX: 0, amountY: 0)
        let bounce = CAKeyframeAnimation(keyPath: "path")
        bounce.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        let values = [
            self.wavePath(amountX: positionX, amountY: positionY),
            self.wavePath(amountX: -(positionX * 0.7), amountY: -(positionY * 0.7)),
            self.wavePath(amountX: positionX * 0.4, amountY: positionY * 0.4),
            self.wavePath(amountX: -(positionX * 0.3), amountY: -(positionY * 0.3)),
            self.wavePath(amountX: positionX * 0.15, amountY: positionY * 0.15),
            self.wavePath(amountX: 0.0, amountY: 0.0)
        ]
        bounce.values = values
        bounce.duration = bounceDuration
        bounce.removedOnCompletion = true
        bounce.fillMode = kCAFillModeForwards
        bounce.delegate = self
        self.waveLayer.addAnimation(bounce, forKey: "return")
    }
    
    func wavePath(amountX amountX:CGFloat, amountY:CGFloat) -> CGPathRef {
        let w = self.frame.width
        let h = self.frame.height
        let centerY:CGFloat = 0
        let bottomY = h
        
        let topLeftPoint = CGPointMake(0, centerY)
        let topMidPoint = CGPointMake(w / 2 + amountX, centerY + amountY)
        let topRightPoint = CGPointMake(w, centerY)
        let bottomLeftPoint = CGPointMake(0, bottomY)
        let bottomRightPoint = CGPointMake(w, bottomY)
        
        let bezierPath = UIBezierPath()
        bezierPath.moveToPoint(bottomLeftPoint)
        bezierPath.addLineToPoint(topLeftPoint)
        bezierPath.addQuadCurveToPoint(topRightPoint, controlPoint: topMidPoint)
        bezierPath.addLineToPoint(bottomRightPoint)
        return bezierPath.CGPath
    }
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        waveLayer.path = wavePath(amountX: 0.0, amountY: 0.0)
    }
}