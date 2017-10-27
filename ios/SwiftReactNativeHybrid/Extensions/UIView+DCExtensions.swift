//
//  UIFont+Heracles.swift
//  Treez.io
//
//  Created by Dan on 07.01.15.
//  Copyright (c) 2017 STRV. All rights reserved.
//

import Foundation
import UIKit
import ObjectiveC

// Declare a global var to produce a unique address as the assoc object handle
var hidingObjectHandle: UInt8 = 0
var showingObjectHandle: UInt8 = 1
var positionDateHandle: UInt8 = 3

extension UIView {

    func hideWithFade(_ hide: Bool, animated: Bool = true, duration: TimeInterval = 0.3, completion: (() -> Void)? = nil)
	{
		if hide == isHidden {
			return
		}
        
        if !animated {
            isHidden = hide
            return
        }
        
        layer.removeAnimation(forKey: "transition")
        
        UIView.transition(with: self, duration: duration, options: .transitionCrossDissolve,
            animations: { [weak self] () -> Void in
                self?.isHidden = hide
            }, completion: { _ in
                completion?()
            })
    }
    
    func pushTransition(_ duration: CFTimeInterval) {
        let animation: CATransition = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            kCAMediaTimingFunctionEaseInEaseOut)
        animation.type = kCATransitionFade
        animation.duration = duration
        self.layer.add(animation, forKey: "changeTextTransition")
    }

    func addCornerRadiusAnimation(from: CGFloat, to: CGFloat, duration: CFTimeInterval)
    {
        let animation = CABasicAnimation(keyPath:"cornerRadius")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.fromValue = from
        animation.toValue = to
        animation.duration = duration
        self.layer.add(animation, forKey: "cornerRadius")
        self.layer.cornerRadius = to
    }
    
}
