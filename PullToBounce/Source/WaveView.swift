//
//  PullToWaveView.swift
//  BezierPathAnimation
//
//  Created by Takuya Okamoto on 2015/08/11.
//  Copyright (c) 2015年 Uniface. All rights reserved.
//

import UIKit

class WaveView: UIView, UIGestureRecognizerDelegate, CAAnimationDelegate {

    var didEndPull: (()->())?
    var bounceDuration:CFTimeInterval!
    var waveLayer:CAShapeLayer!

    init(frame:CGRect, bounceDuration:CFTimeInterval = 0.4, color:UIColor = UIColor.white) {
        self.bounceDuration = bounceDuration
        super.init(frame:frame)

        waveLayer = CAShapeLayer(layer: self.layer)
        waveLayer.lineWidth = 0
        waveLayer.path = wavePath(amountX: 0.0, amountY: 0.0)
        waveLayer.strokeColor = color.cgColor
        waveLayer.fillColor = color.cgColor
        self.layer.addSublayer(waveLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func wave(_ y:CGFloat) {
        self.waveLayer.path = self.wavePath(amountX: 0, amountY: y)
    }
    
    func didRelease(amountX: CGFloat,amountY: CGFloat) {
        self.boundAnimation(positionX: amountX, positionY: amountY)
        didEndPull?()
    }
    
    func boundAnimation(positionX: CGFloat,positionY: CGFloat) {
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
        bounce.isRemovedOnCompletion = true
        bounce.fillMode = kCAFillModeForwards
        bounce.delegate = self
        self.waveLayer.add(bounce, forKey: "return")
    }
    
    func wavePath(amountX:CGFloat, amountY:CGFloat) -> CGPath {
        let w = self.frame.width
        let h = self.frame.height
        let centerY:CGFloat = 0
        let bottomY = h
        
        let topLeftPoint = CGPoint(x: 0, y: centerY)
        let topMidPoint = CGPoint(x: w / 2 + amountX, y: centerY + amountY)
        let topRightPoint = CGPoint(x: w, y: centerY)
        let bottomLeftPoint = CGPoint(x: 0, y: bottomY)
        let bottomRightPoint = CGPoint(x: w, y: bottomY)
        
        let bezierPath = UIBezierPath()
        bezierPath.move(to: bottomLeftPoint)
        bezierPath.addLine(to: topLeftPoint)
        bezierPath.addQuadCurve(to: topRightPoint, controlPoint: topMidPoint)
        bezierPath.addLine(to: bottomRightPoint)
        return bezierPath.cgPath
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        waveLayer.path = wavePath(amountX: 0.0, amountY: 0.0)
    }
}
