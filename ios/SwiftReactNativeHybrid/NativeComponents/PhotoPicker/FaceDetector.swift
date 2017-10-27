 //
 //  FaceDetector.swift
 //  Treez.io
 //
 //  Created by Dan on 10/1/17.
 //  Copyright (c) 2017 STRV. All rights reserved.
 //
 
 
 import UIKit
 
 class FaceDetector: NSObject {
    
    class func detectFace(image: UIImage, rectangle: CGRect) -> CGRect? {
        
        let ciImage: CIImage! = CIImage(image: image)
        
        let accuracy = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: accuracy)
        let faces = faceDetector?.features(in: ciImage)
        
        // Convert Core Image Coordinate to UIView Coordinate
        let ciImageSize = ciImage.extent.size
        var transform = CGAffineTransform(scaleX: 1, y: -1)
        transform = transform.translatedBy(x: 0, y: -ciImageSize.height)
        
        for face in faces as! [CIFaceFeature] {
            
            // Apply the transform to convert the coordinates
            var faceViewBounds = face.bounds.applying(transform)
            
            // Calculate the actual position and size of the rectangle in the image view
            let viewSize = rectangle.size
            let scale = min(viewSize.width / ciImageSize.width,
                            viewSize.height / ciImageSize.height)
            let offsetX = (viewSize.width - ciImageSize.width * scale) / 2
            let offsetY = (viewSize.height - ciImageSize.height * scale) / 2
            
            faceViewBounds = faceViewBounds.applying(CGAffineTransform(scaleX: scale, y: scale))
            faceViewBounds.origin.x += offsetX
            faceViewBounds.origin.y += offsetY
            
            // Take just first one
            return faceViewBounds
        }
        
        return nil
    }
 }
 
