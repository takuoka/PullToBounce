//
//  LoadingBallView.swift
//  BezierPathAnimation
//
//  Created by Takuya Okamoto on 2015/08/11.
//  Copyright (c) 2015年 Uniface. All rights reserved.
//

import UIKit

private var timeFunc : CAMediaTimingFunction!
private var upDuration: Double!

class BallView: UIView {
    
    var circleLayer: CircleLayer!
    
    init(frame:CGRect,
        circleSize:CGFloat = 40,
        timingFunc:CAMediaTimingFunction = timeFunc,
        moveUpDuration:CFTimeInterval = upDuration,
        moveUpDist:CGFloat,
        color:UIColor = UIColor.whiteColor())
    {
        timeFunc = timingFunc
        upDuration = moveUpDuration
        super.init(frame:frame)
        
        let circleMoveView = UIView()
        circleMoveView.frame = CGRectMake(0, 0, moveUpDist, moveUpDist)
        circleMoveView.center = CGPointMake(frame.width/2, frame.height + circleSize / 2)
        self.addSubview(circleMoveView)
        
        circleLayer = CircleLayer(
            size: circleSize,
            moveUpDist: moveUpDist,
            superViewFrame: circleMoveView.frame,
            color: color
        )
        circleMoveView.layer.addSublayer(circleLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startAnimation() {
        circleLayer.startAnimation()
    }
    func endAnimation(complition:(()->())? = nil) {
        circleLayer.endAnimation(complition)
    }
}




class CircleLayer :CAShapeLayer {
    
    let moveUpDist: CGFloat!
    let spiner: SpinerLayer!
    var didEndAnimation: (()->())?
    
    init(size:CGFloat, moveUpDist:CGFloat , superViewFrame:CGRect, color:UIColor = UIColor.whiteColor()) {
        self.moveUpDist = moveUpDist
        let selfFrame = CGRectMake(0, 0, superViewFrame.size.width, superViewFrame.size.height)
        self.spiner = SpinerLayer(superLayerFrame: selfFrame, ballSize: size, color: color)
        super.init()
        
        self.addSublayer(spiner)
        
        let radius:CGFloat = size / 2
        self.frame = selfFrame
        let center = CGPointMake(superViewFrame.size.width / 2, superViewFrame.size.height/2)
        let startAngle = 0 - M_PI_2
        let endAngle = M_PI * 2 - M_PI_2
        let clockwise: Bool = true
        self.path = UIBezierPath(arcCenter: center, radius: radius, startAngle: CGFloat(startAngle), endAngle: CGFloat(endAngle), clockwise: clockwise).CGPath
        self.fillColor = color.colorWithAlphaComponent(1).CGColor
        self.strokeColor = self.fillColor
        self.lineWidth = 0
        self.strokeEnd = 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startAnimation() {
        self.moveUp(moveUpDist)
        NSTimer.schedule(delay: upDuration) { timer in
            self.spiner.animation()
        }
    }
    func endAnimation(complition:(()->())? = nil) {
        spiner.stopAnimation()
        self.moveDown(moveUpDist)
        didEndAnimation = complition
    }
    
    func moveUp(distance: CGFloat) {
        let move = CABasicAnimation(keyPath: "position")
        
        move.fromValue = NSValue(CGPoint: position)
        move.toValue = NSValue(CGPoint: CGPointMake(position.x, position.y - distance))
        
        move.duration = upDuration
        move.timingFunction = timeFunc
        
        move.fillMode = kCAFillModeForwards
        move.removedOnCompletion = false
        self.addAnimation(move, forKey: move.keyPath)
    }
    
    
    func moveDown(distance: CGFloat) {
        let move = CABasicAnimation(keyPath: "position")
        
        move.fromValue = NSValue(CGPoint: CGPointMake(position.x, position.y - distance))
        move.toValue = NSValue(CGPoint: position)
        
        move.duration = upDuration
        move.timingFunction = timeFunc
        
        move.fillMode = kCAFillModeForwards
        move.removedOnCompletion = false
        move.delegate = self
        self.addAnimation(move, forKey: move.keyPath)
    }
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        didEndAnimation?()
    }
}


class SpinerLayer :CAShapeLayer {
    
    init(superLayerFrame:CGRect, ballSize:CGFloat, color:UIColor = UIColor.whiteColor()) {
        super.init()
        
        let radius:CGFloat = (ballSize / 2) * 1.2//1.45
        self.frame = CGRectMake(0, 0, superLayerFrame.height, superLayerFrame.height)
        let center = CGPointMake(superLayerFrame.size.width / 2, superLayerFrame.origin.y + superLayerFrame.size.height/2)
        let startAngle = 0 - M_PI_2
        let endAngle = (M_PI * 2 - M_PI_2) + M_PI / 8
        let clockwise: Bool = true
        self.path = UIBezierPath(arcCenter: center, radius: radius, startAngle: CGFloat(startAngle), endAngle: CGFloat(endAngle), clockwise: clockwise).CGPath
        
        self.fillColor = nil
        self.strokeColor = color.colorWithAlphaComponent(1).CGColor
        self.lineWidth = 2
        self.lineCap = kCALineCapRound
        
        self.strokeStart = 0
        self.strokeEnd = 0
        self.hidden = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animation() {
        self.hidden = false
        let rotate = CABasicAnimation(keyPath: "transform.rotation.z")
        rotate.fromValue = 0
        rotate.toValue = M_PI * 2
        rotate.duration = 1
        rotate.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        rotate.repeatCount = HUGE
        rotate.fillMode = kCAFillModeForwards
        rotate.removedOnCompletion = false
        self.addAnimation(rotate, forKey: rotate.keyPath)

        strokeEndAnimation()
    }

    func strokeEndAnimation() {
        let endPoint = CABasicAnimation(keyPath: "strokeEnd")
        endPoint.fromValue = 0
        endPoint.toValue = 1.0
        endPoint.duration = 0.8
        endPoint.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        endPoint.repeatCount = 1
        endPoint.fillMode = kCAFillModeForwards
        endPoint.removedOnCompletion = false
        endPoint.delegate = self
        self.addAnimation(endPoint, forKey: endPoint.keyPath)
    }
    
    func strokeStartAnimation() {
        let startPoint = CABasicAnimation(keyPath: "strokeStart")
        startPoint.fromValue = 0
        startPoint.toValue = 1.0
        startPoint.duration = 0.8
        startPoint.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        startPoint.repeatCount = 1
//        startPoint.fillMode = kCAFillModeForwards
//        startPoint.removedOnCompletion = false
        startPoint.delegate = self
        self.addAnimation(startPoint, forKey: startPoint.keyPath)
    }

    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        if self.hidden == false {
            let a:CABasicAnimation = anim as! CABasicAnimation
            if a.keyPath == "strokeStart" {
                strokeEndAnimation()
            }
            else if a.keyPath == "strokeEnd" {
                strokeStartAnimation()
            }
        }
    }
    
    func stopAnimation() {
        self.hidden = true
        self.removeAllAnimations()
    }
}