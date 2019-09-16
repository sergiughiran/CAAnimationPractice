//
//  LoadingIndicatorView.swift
//  CAReplicatorAnimation
//
//  Created by Ghiran Sergiu-Robert on 09/09/2019.
//  Copyright © 2019 Personal. All rights reserved.
//

import UIKit

final class LoadingIndicatorView: UIView {
    
    // MARK: - Private Properties
    
    private var arc: CAShapeLayer!
    
//    private lazy var strokeEndAnimation: CABasicAnimation = {
//        let animation = CABasicAnimation(keyPath: "strokeEnd")
//        animation.fromValue = 0.05
//        animation.toValue = 0.8
//        animation.duration = 1
//        animation.autoreverses = true
//        animation.repeatCount = Float.greatestFiniteMagnitude
//        return animation
//    }()

    private lazy var strokeEndAnimation: CAKeyframeAnimation = {
        let animation = CAKeyframeAnimation(keyPath: "strokeEnd")
        animation.duration = 2
        animation.keyTimes = [0, 0.15, 0.35, 0.5, 0.65, 0.85, 1]
        animation.values = [0.05, 0.1, 0.7, 0.8, 0.7, 0.1, 0.05]
        animation.calculationMode = .linear
        animation.repeatCount = Float.greatestFiniteMagnitude
        return animation
    }()
    
    private lazy var rotateAnimation: CAKeyframeAnimation = {
        let animation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
//        animation.keyTimes = []
        animation.keyTimes = [0, 0.03, 0.1, 0.13, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1]
//
//        let closeAngle = 14 * Float.pi / 5
//        let slowCloseAngle = 0
//        let expandAngle = 8 * Float.pi / 5
//        let slowExpandingAngle
        let expandAngle = Float.pi
        let closeAngle = 3 * Float.pi
        let slowClose = 2 * Float.pi / 5
        let slowExpand = 4 * Float.pi / 5
        
        animation.values = [0, expandAngle, expandAngle + slowClose, expandAngle + slowClose + closeAngle, 2 * expandAngle + closeAngle + slowClose, 3 * expandAngle + 2 * closeAngle, 3 * (expandAngle + closeAngle), 0, 0, 0, 0]
        animation.calculationMode = CAAnimationCalculationMode.linear
        animation.duration = 10
        animation.repeatCount = Float.greatestFiniteMagnitude
        return animation
    }()
    
    private lazy var colorAnimation: CAKeyframeAnimation = {
        let animation = CAKeyframeAnimation(keyPath: "strokeColor")
        animation.duration = 9
        animation.keyTimes = [0, 0.33, 0.66, 1]
        animation.values = [#colorLiteral(red: 0.9764705882, green: 0.3411764706, blue: 0.2196078431, alpha: 1).cgColor, #colorLiteral(red: 0.3490196078, green: 0.8039215686, blue: 0.5647058824, alpha: 1).cgColor, #colorLiteral(red: 0.05098039216, green: 0.231372549, blue: 0.4, alpha: 1).cgColor, #colorLiteral(red: 0.9764705882, green: 0.3411764706, blue: 0.2196078431, alpha: 1).cgColor]
        animation.repeatCount = Float.greatestFiniteMagnitude
        return animation
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initLayer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initLayer()
    }
    
    // MARK: - Logic
    
    private func initLayer() {
        arc = CAShapeLayer()
        arc.bounds = frame
        arc.fillColor = UIColor.clear.cgColor
        arc.lineWidth = 3
        arc.path = UIBezierPath(ovalIn: frame).cgPath
        arc.position = CGPoint(x: frame.width / 2, y: frame.height / 2)
        layer.addSublayer(arc)

        arc.add(strokeEndAnimation, forKey: "strokeEnd")
        arc.add(rotateAnimation, forKey: "transform.rotation")
        arc.add(colorAnimation, forKey: "strokeColor")
    }
}
