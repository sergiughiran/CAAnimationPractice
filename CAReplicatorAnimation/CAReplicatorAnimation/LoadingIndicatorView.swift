//
//  LoadingIndicatorView.swift
//  CAReplicatorAnimation
//
//  Created by Ghiran Sergiu-Robert on 09/09/2019.
//  Copyright © 2019 Personal. All rights reserved.
//

import UIKit

private enum Constants {
    static let expandRotation: Float = Float.pi
    static let closeRotation: Float  = 5 * Float.pi / 2
    static let lineWidth: CGFloat    = 3
}

final class LoadingIndicatorView: UIView {
    
    // MARK: - Private Properties
    
    private var arc: CAShapeLayer!

    // This is the expand/close animetion
    // It is "infinitely" reversible
    private lazy var strokeEndAnimation: CABasicAnimation = {
        let animation = CABasicAnimation(keyPath: "strokeEnd")

        animation.fromValue = 0.05
        animation.toValue = 0.8
        animation.duration = 0.5
        animation.autoreverses = true
        animation.repeatCount = Float.greatestFiniteMagnitude

        return animation
    }()

    // This is the rotation animation
    // The equations for finding the expand/close angles were done using the trigonometric circle
    //
    // For expand the equation is simple, the circle(strokeStart) expands by `pi` degrees
    //
    // For close the equation was more dificult since we animate the `strokeEnd` and for the rotation we use the strokeStart. Basically we have to
    // also match the strokeEnd angle in order to maintain the constant `pi` rotation. This means adding 5 * pi / 2 to the existing `pi`
    private lazy var rotateAnimation: CAKeyframeAnimation = {
        let animation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        let keyTimes = [0, 0.125, 0.25, 0.375, 0.5, 0.625, 0.75, 0.875, 1]

        animation.keyTimes = keyTimes as [NSNumber]
        animation.values = rotationValues(with: Array(keyTimes.indices))
        animation.calculationMode = CAAnimationCalculationMode.linear
        animation.duration = 4
        animation.repeatCount = Float.greatestFiniteMagnitude

        return animation
    }()

    // This is the color animation between the previous close and the next expand
    // The `keyTimes` were calculated so that the color changes in the small window in which the arc is at it's smallest.
    private lazy var colorAnimation: CAKeyframeAnimation = {
        let animation = CAKeyframeAnimation(keyPath: "strokeColor")
        animation.duration = 4
        animation.keyTimes = [0, 0.23, 0.27, 0.48, 0.52, 0.73, 0.77, 1]
        animation.values = [#colorLiteral(red: 0.9764705882, green: 0.3411764706, blue: 0.2196078431, alpha: 1).cgColor, #colorLiteral(red: 0.9764705882, green: 0.3411764706, blue: 0.2196078431, alpha: 1).cgColor, #colorLiteral(red: 0.3490196078, green: 0.8039215686, blue: 0.5647058824, alpha: 1).cgColor, #colorLiteral(red: 0.3490196078, green: 0.8039215686, blue: 0.5647058824, alpha: 1).cgColor, #colorLiteral(red: 0.05098039216, green: 0.231372549, blue: 0.4, alpha: 1).cgColor, #colorLiteral(red: 0.05098039216, green: 0.231372549, blue: 0.4, alpha: 1).cgColor, #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1).cgColor, #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1).cgColor,]
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
        arc.lineWidth = Constants.lineWidth
        arc.path = UIBezierPath(ovalIn: frame).cgPath
        arc.position = CGPoint(x: frame.width / 2, y: frame.height / 2)

        layer.addSublayer(arc)

        arc.add(strokeEndAnimation, forKey: "strokeEnd")
        arc.add(rotateAnimation, forKey: "transform.rotation")
        arc.add(colorAnimation, forKey: "strokeColor")
    }

    // This is just a helper function to simplify the already crowded rotateAnimation block.
    // The thought process was pretty simple, we have to increment the expandIndex for odd numbers and the closeIndex for even ones.
    private func rotationValues(with indices: [Int]) -> [Float] {
        var expandIndex = 0
        var closeIndex = -1
        return indices.map { index in
            (index % 2 != 0) ? (expandIndex += 1) : (closeIndex += 1)
            return Float(expandIndex) * Constants.expandRotation + Float(closeIndex) * Constants.closeRotation
        }
    }
}
