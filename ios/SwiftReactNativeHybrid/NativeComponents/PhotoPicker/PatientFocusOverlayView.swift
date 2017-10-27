//
//  PatientFocusOverlayView.swift
//  Treez.io
//
//  Created by Dan on 28.09.2017.
//  Copyright (c) 2017 STRV. All rights reserved.
//

import UIKit

class PatientFocusOverlayView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect)
    {
        let rectanglePath = UIBezierPath(rect: bounds.insetBy(dx: Constants.lineWidth, dy: Constants.lineWidth))
        Constants.overlayColor.setStroke()
        rectanglePath.lineWidth = 3.0
        rectanglePath.stroke()
        
        let horizontalMargin = bounds.size.width / 5.0
        let verticalMargin = bounds.size.width / 10.0
        
        let ovalPath = UIBezierPath(ovalIn: CGRect(x: horizontalMargin, y: verticalMargin, width: bounds.size.width - 2 * horizontalMargin, height: bounds.size.height - 2 * verticalMargin))
        Constants.overlayColor.setStroke()
        ovalPath.lineWidth = 3.0
        ovalPath.stroke()
    }

}
