//
//  SignatureView.swift
//  treez
//
//  Created by Dan on 09.10.2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

import UIKit
import React

@objc
class SignatureView: UIView {
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    fileprivate var _drawView: SwiftyDrawView!
    
    init() {
        super.init(frame: .zero)
        
        NotificationCenter.default.addObserver(self, selector: "clearSignature", name: Notification.Name.ClearSignatureNotification, object: nil)
        
        _drawView = SwiftyDrawView(frame: .zero)
        _drawView.translatesAutoresizingMaskIntoConstraints = false
        _drawView.lineWidth = 3.0
        addSubview(_drawView)
        
        _drawView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        _drawView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        _drawView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        _drawView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func clearSignature() {
        _drawView.clearCanvas()
        
    }
    
    @objc func getSignature(_ callback: @escaping RCTResponseSenderBlock) {
        DispatchQueue.main.async {
            let signatureImage = UIImage(view: self)
            
            guard let data = UIImagePNGRepresentation(signatureImage) else {
                callback([["error": "invalid image data"], NSNull()]);
                return
            }
            
            let signatureFileURL = DCToolbox.getDocumentsDirectory().appendingPathComponent("signature.png")
            try? data.write(to: signatureFileURL)
            
            let signatureFileURLString = (signatureFileURL.absoluteString) as NSString
            
            callback([NSNull(), signatureFileURLString])
            
        }
    }
    
}
