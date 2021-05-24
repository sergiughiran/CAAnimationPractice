//
//  ViewController.swift
//  CAReplicatorAnimation
//
//  Created by Ghiran Sergiu-Robert on 16/08/2019.
//  Copyright © 2019 Personal. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var circleView: RoundableView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        circleView.layer.borderColor = #colorLiteral(red: 0.1215686275, green: 0.1294117647, blue: 0.1411764706, alpha: 1)
        circleView.layer.borderWidth = 2.0
        circleView.layer.zPosition = 1
        
        circleView.isHidden = true
        logEvent(title: "Circle view frame", value: circleView.frame.debugDescription)
        
//        setupPulseAnimation()
//        setupCircleLoadingIndicator()
        setupArcLoadingIndicator()
    }

    // MARK: - Logic
    
    // This is a replica of the Tinder loading animation
    private func setupPulseAnimation() {
        circleView.isHidden = false
        
        // Save the desired width and height for the replicator frame into constants
        let finalSize = view.frame.width
        let instanceCount = 1.0
        let animationDuration = 3.0
        let instanceDelay: Double = animationDuration / instanceCount
        
        logEvent(title: "Instance count", value: String(instanceCount))
        logEvent(title: "Animation duration", value: String(animationDuration))
        
        // Create the replicator using the above values
        let replicator = CAReplicatorLayer()
        replicator.instanceCount = Int(instanceCount)
        replicator.instanceDelay = CFTimeInterval(instanceDelay)
        replicator.instanceTransform = CATransform3DMakeTranslation(0, 0, 1)
        
        logEvent(title: "Instance delay", value: String(replicator.instanceDelay))
        // We want the frame of the replicator to be four times the size of the circleView and centered within the main view
        replicator.frame = CGRect(x: view.center.x - finalSize / 2, y: view.center.y - finalSize / 2, width: finalSize, height: finalSize)
        logEvent(title: "Replicator frame", value: replicator.frame.debugDescription)
        
        // Define the circle outline we'll be using
        let circle = CAShapeLayer()
        circle.frame.size = CGSize(width: finalSize, height: finalSize)
        circle.cornerRadius = finalSize / 2
        circle.fillColor = #colorLiteral(red: 0.2196078431, green: 0.2352941176, blue: 0.2901960784, alpha: 0.8)
        circle.strokeColor = #colorLiteral(red: 0.1215686275, green: 0.1294117647, blue: 0.1411764706, alpha: 1)
        circle.lineWidth = 2.0
        circle.path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: finalSize, height: finalSize)).cgPath
        
        // Define the scale animation that increases the size of the circle
        let pulseAnimation = CABasicAnimation(keyPath: "transform.scale")
        // 0.25 would make the circle the same size as the circleView, since the frame of the circle shape is four times that of the view
        pulseAnimation.fromValue = 0.25
        pulseAnimation.toValue = 1
        pulseAnimation.duration = CFTimeInterval(animationDuration)
        pulseAnimation.repeatCount = Float.greatestFiniteMagnitude
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        circle.add(pulseAnimation, forKey: nil)
        
        // Define the fade animation so that when the circle closes onto the end of the frame it dissapears
        let fadeAnimation = CABasicAnimation(keyPath: "opacity")
        fadeAnimation.fromValue = 1
        fadeAnimation.toValue = 0
        fadeAnimation.duration = CFTimeInterval(animationDuration)
        fadeAnimation.repeatCount = Float.greatestFiniteMagnitude
        circle.add(fadeAnimation, forKey: nil)
        
        replicator.addSublayer(circle)

        view.layer.addSublayer(replicator)
    }

    // This is a basic circle spinning indicator
    // NOTE: - Not final
    private func setupCircleLoadingIndicator() {
        let instanceCount = 20.0
        let animationDuration = 3.0
        let instanceDelay = animationDuration / instanceCount
        
        let replicator = CAReplicatorLayer()
        replicator.instanceCount = Int(instanceCount)
        replicator.instanceTransform = CATransform3DMakeRotation(2 * .pi / CGFloat(instanceCount), 0, 0, 1)
        replicator.instanceDelay = CFTimeInterval(instanceDelay)
        replicator.frame = CGRect(x: view.center.x - 50, y: view.center.y - 50, width: 100, height: 100)
        
        let shape = CAShapeLayer()
        shape.frame.size = CGSize(width: 30, height: 30)
        shape.fillColor = #colorLiteral(red: 0.2196078431, green: 0.2352941176, blue: 0.2901960784, alpha: 0.8)
        shape.path = UIBezierPath(arcCenter: .zero, radius: 10, startAngle: 0, endAngle: 2 * .pi, clockwise: true).cgPath
        
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = 1
        scaleAnimation.toValue = 0.5
        scaleAnimation.duration = CFTimeInterval(animationDuration)
        scaleAnimation.repeatCount = Float.greatestFiniteMagnitude
        shape.add(scaleAnimation, forKey: nil)
        
        let fadeAnimation = CABasicAnimation(keyPath: "opacity")
        fadeAnimation.fromValue = 1
        fadeAnimation.toValue = 0.1
        fadeAnimation.duration = CFTimeInterval(animationDuration)
        fadeAnimation.repeatCount = Float.greatestFiniteMagnitude
        shape.add(fadeAnimation, forKey: nil)
        
        replicator.addSublayer(shape)
        
        view.layer.addSublayer(replicator)
    }

    // This is a replica of the Google loading indicator
    // NOTE: - `easeInEaseOut` animation not implemented yet for expand/close
    private func setupArcLoadingIndicator() {
        let loadingIndicator = LoadingIndicatorView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        view.addSubview(loadingIndicator)
        
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        loadingIndicator.widthAnchor.constraint(equalToConstant: 30).isActive = true
        loadingIndicator.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    private func logEvent(title: String, value: String) {
        print(title + " = " + value)
    }
}
