//
//  ImageUtils.swift
//  SwiftReactNativeHybrid
//
//  Created by Dan on 28.09.2017.
//  Copyright (c) 2017 STRV. All rights reserved.
//

import Foundation

internal struct ImageUtils {
    
    static func correctOrientationOf(image:UIImage) -> UIImage
    {
        
        UIGraphicsBeginImageContext(image.size)
        image.draw(at: .zero)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage ?? image
    }
    
    /**
     Draw the image within the given bounds (i.e. resizes)
     
     - parameter image:  Image to draw within the given bounds
     - parameter bounds: Bounds to draw the image within
     
     - returns: Resized image within bounds
     */
    static func drawImageInBounds(_ image: UIImage, bounds : CGRect) -> UIImage {
        return drawImageWithClosure(size: bounds.size) { (size: CGSize, context: CGContext) -> () in
            image.draw(in: bounds)
        };
    }
    
    /**
     Crop the image within the given rect (i.e. resizes and crops)
     
     - parameter image: Image to clip within the given rect bounds
     - parameter rect:  Bounds to draw the image within
     
     - returns: Resized and cropped image
     */
    static func crop(image: UIImage, withRect rect: CGRect) -> UIImage {
        return drawImageWithClosure(size: rect.size) { (size: CGSize, context: CGContext) -> () in
            let drawRect = CGRect(x: -rect.origin.x, y: -rect.origin.y, width: image.size.width, height: image.size.height)
            context.clip(to: CGRect(x: 0, y: 0, width: rect.size.width, height: rect.size.height))
            image.draw(in: drawRect)
        };
    }
    
    /**
     Closure wrapper around image context - setting up, ending and grabbing the image from the context.
     
     - parameter size:    Size of the graphics context to create
     - parameter closure: Closure of magic to run in a new context
     
     - returns: Image pulled from the end of the closure
     */
    static func drawImageWithClosure(size: CGSize!, closure: (_ size: CGSize, _ context: CGContext) -> ()) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        closure(size, UIGraphicsGetCurrentContext()!)
        let image : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    static func isPortraitImage(_ image: UIImage) -> Bool {
        return (image.size.height > image.size.width)
    }
    
    static func imageRotatedByDegrees(oldImage: UIImage, deg degrees: CGFloat) -> UIImage {
        let size = oldImage.size
        
        UIGraphicsBeginImageContext(size)
        
        let bitmap: CGContext = UIGraphicsGetCurrentContext()!
        //Move the origin to the middle of the image so we will rotate and scale around the center.
        bitmap.translateBy(x: size.width / 2, y: size.height / 2)
        //Rotate the image context
        bitmap.rotate(by: (degrees * CGFloat(CGFloat.pi / 180)))
        //Now, draw the rotated/scaled image into the context
        bitmap.scaleBy(x: 1.0, y: -1.0)
        
        let origin = CGPoint(x: -size.width / 2, y: -size.width / 2)
        
        bitmap.draw(oldImage.cgImage!, in: CGRect(origin: origin, size: size))
        
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    static func imageRotatedByMInus90(oldImage: UIImage) -> UIImage {
//        let size = CGSize(width: oldImage.size.height, height: oldImage.size.width)
//
//        UIGraphicsBeginImageContext(size)
//
//        let bitmap: CGContext = UIGraphicsGetCurrentContext()!
//        //Move the origin to the middle of the image so we will rotate and scale around the center.
//        bitmap.translateBy(x: size.width / 2, y: size.height / 2)  //!
//        //Rotate the image context
//        bitmap.rotate(by: (-90 * CGFloat(CGFloat.pi / 180)))
//        //Now, draw the rotated/scaled image into the context
//        bitmap.scaleBy(x: 1.0, y: -1.0)
//
//        let origin = CGPoint(x: -size.height / 2, y: -size.height / 2)
//
//        bitmap.draw(oldImage.cgImage!, in: CGRect(origin: origin, size: size))
//
//        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
//        UIGraphicsEndImageContext()
//        return newImage
        
        let testImage = UIImage(cgImage: oldImage.cgImage!, scale: oldImage.scale, orientation: .left)
        
        return testImage.fixOrientation()
    }
    
    static func portraitImage(from image: UIImage) -> UIImage {
        if ImageUtils.isPortraitImage(image) {
            return image
        }
        else {
            switch image.imageOrientation {
            case .left: // 90 deg CCW
                return ImageUtils.imageRotatedByDegrees(oldImage: image, deg: -90)
                
            case .right: // 90 deg CW
                return ImageUtils.imageRotatedByDegrees(oldImage: image, deg: 90)
                
            default:
                return image
            }
        }
    }
    
    static func cropToOverlayFrame(image: UIImage, imageScreenFrame: CGRect, cropScreenFrame: CGRect, scanFlow: ScanFlow) -> UIImage {

        let modifiedFrame: CGRect
        switch scanFlow {
        case .idCard, .doctorReferenceLetter:
            modifiedFrame = cropScreenFrame.insetBy(dx: Constants.focusViewLineWidth, dy: Constants.focusViewLineWidth)
        case .patientPhoto:
            modifiedFrame = cropScreenFrame
        }
        
        var magicalConstant: CGFloat = 1
        if (scanFlow == .idCard) && ImageUtils.isPortraitImage(image) && (image.imageOrientation == .right) {
            magicalConstant = 0.95
        }
        
        print("image size: \(image.size), imageScreenFrame: \(imageScreenFrame.size), cropScreenFrame \(cropScreenFrame), modifiedFrame \(modifiedFrame), imageOrientation: \(image.imageOrientation)")
        
        let imageWidth = image.size.width
        let imageHeight = image.size.height
        let screenWidth = imageScreenFrame.size.width
        let screenHeight = imageScreenFrame.size.height
        let cropWidth = modifiedFrame.size.width
        let cropHeight = modifiedFrame.size.height
        
        func standardPortraitCropping() -> UIImage {
            let cropX = imageWidth/2 - imageWidth/screenWidth * (cropWidth / 2)
            let cropY = imageHeight/2 - imageWidth/screenWidth * (cropHeight / 2) * magicalConstant
            
            return ImageUtils.crop(image: image, withRect:
                CGRect(
                    x: cropX,
                    y: cropY,
                    width: (imageWidth/screenWidth) * cropWidth,
                    height: (imageWidth/screenWidth) * cropHeight))
        }
        
        func patientLandscapeCropping() -> UIImage {
            let cropX = imageWidth/2 - imageHeight/screenWidth * (cropWidth / 2)
            let cropY = imageHeight/2 - imageHeight/screenWidth * (cropHeight / 2)
            
            return ImageUtils.crop(image: image, withRect:
                CGRect(
                    x: cropX,
                    y: cropY,
                    width: (imageHeight/screenWidth) * cropWidth,
                    height: (imageHeight/screenWidth) * cropHeight))
        }
        
        func idCardLandscapeCropping() -> UIImage {
            let cropX = imageWidth/2 - imageHeight/screenWidth * (cropHeight / 2) * 0.95  // Magical constant :-)
            let cropY = imageHeight/2 - imageHeight/screenWidth * (cropWidth / 2)
            
            return ImageUtils.crop(image: image, withRect:
                CGRect(
                    x: cropX,
                    y: cropY,
                    width: (imageHeight/screenWidth) * cropHeight,
                    height: (imageHeight/screenWidth) * cropWidth))
        }
        
        switch scanFlow {
        case .doctorReferenceLetter:
            return standardPortraitCropping()
            
        case .patientPhoto:
            if ImageUtils.isPortraitImage(image) {
                return standardPortraitCropping()
            }
            else {
                return patientLandscapeCropping()
            }
        case .idCard:
            if ImageUtils.isPortraitImage(image) {
                return standardPortraitCropping()
            }
            else {
                return idCardLandscapeCropping()
            }
        }
    }
}

