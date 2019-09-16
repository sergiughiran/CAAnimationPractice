//
//  RoundableView.swift
//  CAReplicatorAnimation
//
//  Created by Ghiran Sergiu-Robert on 16/08/2019.
//  Copyright © 2019 Personal. All rights reserved.
//

import UIKit

@IBDesignable
final class RoundableView: UIView {
    @IBInspectable
    var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
}
