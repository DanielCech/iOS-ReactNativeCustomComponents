//
//  IGRPhotoTweakView.swift
//  IGRPhotoTweaks
//
//  Created by Vitalii Parovishnyk on 2/6/17.
//  Copyright © 2017 IGR Software. All rights reserved.
//

import UIKit

@objc public class IGRPhotoTweakView: UIView {
    
    //MARK: - Public VARs
    
    public weak var customizationDelegate: IGRPhotoTweakViewCustomizationDelegate?
    
    private(set) lazy var cropView: IGRCropView! = { [unowned self] by in
        
        let cropView = IGRCropView(frame: self.scrollView.frame,
                                    cornerBorderWidth:self.cornerBorderWidth(),
                                    cornerBorderLength:self.cornerBorderLength())
        cropView.center = self.scrollView.center
    
        cropView.aspectRatioHeight = self.isPortraitImage ? 165 : 135
        cropView.aspectRatioWidth = self.isPortraitImage ? 135 : 165
        cropView.lockAspectRatio(true)
        
        cropView.layer.borderColor = self.borderColor().cgColor
        cropView.layer.borderWidth = self.borderWidth()
        self.addSubview(cropView)
        
        return cropView
    }(())
    
    private(set) lazy var photoContentView: IGRPhotoContentView! = { [unowned self] by in
        
        let photoContentView = IGRPhotoContentView(frame: self.scrollView.bounds)
        photoContentView.isUserInteractionEnabled = true
        self.scrollView.addSubview(photoContentView)
        
        return photoContentView
    }(())
    
    public var photoTranslation: CGPoint {
        get {
            let rect: CGRect = photoContentView.convert(photoContentView.bounds,
                                                             to: self)
            let point = CGPoint(x: (rect.origin.x + rect.size.width.half),
                                y: (rect.origin.y + rect.size.height.half))
            let zeroPoint = CGPoint(x: frame.width.half, y: centerY)
            
            return CGPoint(x: (point.x - zeroPoint.x), y: (point.y - zeroPoint.y))
        }
    }
    
    var isPortraitImage: Bool = true
    
    //MARK: - Private VARs
    
    internal var angle: CGFloat         = CGFloat.zero
    fileprivate var photoContentOffset  = CGPoint.zero
    
    internal lazy var scrollView: IGRPhotoScrollView! = { [unowned self] by in
        
        let maxBounds = self.maxBounds()
        self.originalSize = maxBounds.size
        
        let scrollView = IGRPhotoScrollView(frame: maxBounds)
        scrollView.center = CGPoint(x: self.frame.width.half, y: self.centerY)
        scrollView.delegate = self
        self.addSubview(scrollView)
        
        return scrollView
    }(())
    
    internal weak var image: UIImage!
    internal var originalSize = CGSize.zero
    
    internal var manualZoomed = false
    internal var manualMove   = false
    
    // masks
    internal var topMask:    IGRCropMaskView!
    internal var leftMask:   IGRCropMaskView!
    internal var bottomMask: IGRCropMaskView!
    internal var rightMask:  IGRCropMaskView!
    
    // constants
    fileprivate var maximumCanvasSize: CGSize!
    fileprivate var originalPoint: CGPoint!
    internal var centerY: CGFloat!
    
    // MARK: - Life Cicle
    
    init(frame: CGRect, image: UIImage, customizationDelegate: IGRPhotoTweakViewCustomizationDelegate!) {
        super.init(frame: frame)
        
        self.image = image
        self.customizationDelegate = customizationDelegate
        
        setupScrollView()
        setupCropView()
        setupMasks()
        
        originalPoint = convert(scrollView.center, to: self)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        originalSize = maxBounds().size
        
    }
    
    //MARK: - Public FUNCs

    public func resetView() {
        UIView.animate(withDuration: kAnimationDuration, animations: { [weak self] () -> Void in
            guard let `self` = self else { return }
            
            self.angle = 0
            self.scrollView.transform = CGAffineTransform.identity
            self.scrollView.center = CGPoint(x: self.frame.width.half, y: self.centerY)
            self.scrollView.bounds = CGRect(x: CGFloat.zero,
                                            y: CGFloat.zero,
                                            width: self.originalSize.width,
                                            height: self.originalSize.height)
            self.scrollView.minimumZoomScale = 1
            self.scrollView.setZoomScale(1, animated: false)
            
            self.cropView.frame = self.scrollView.frame
            self.cropView.center = self.scrollView.center
        })
    }
    
    public func setCrop(rect: CGRect, image: UIImage) {

        print("Crop rect: \(rect)")
        
        if isPortraitImage {
            UIView.animate(withDuration: kAnimationDuration, animations: { [weak self] () -> Void in
                guard let `self` = self else { return }
                
                self.angle = 0
                self.scrollView.transform = CGAffineTransform.identity
                self.scrollView.center = CGPoint(x: self.frame.width.half, y: self.centerY)
                self.scrollView.bounds = CGRect(x: CGFloat.zero,
                                                y: CGFloat.zero,
                                                width: self.originalSize.width,
                                                height: self.originalSize.height)
                self.scrollView.minimumZoomScale = 1
                self.scrollView.setZoomScale(1, animated: false)
                
                let cropViewWidth = self.photoContentView.bounds.size.width * 0.55
                let cropViewHeight = self.photoContentView.bounds.size.height * 0.3
                self.cropView.frame = CGRect(x: rect.midX - cropViewWidth.half, y: rect.midY - cropViewHeight.half, width: cropViewWidth, height: cropViewHeight)
                
                self.cropView.center = CGPoint(x: rect.midX, y: rect.midY)
            })
        }
        else {
            self.photoContentView.center = CGPoint(x: self.scrollView.center.x - 15, y: self.scrollView.center.y)
            
            UIView.animate(withDuration: kAnimationDuration, animations: { [weak self] () -> Void in
                guard let `self` = self else { return }
                
                self.angle = 0
                self.scrollView.transform = CGAffineTransform.identity
                self.scrollView.center = CGPoint(x: self.frame.width.half, y: self.centerY)
                self.scrollView.bounds = CGRect(x: CGFloat.zero,
                                                y: CGFloat.zero,
                                                width: self.originalSize.width,
                                                height: self.originalSize.height)
                self.scrollView.minimumZoomScale = 1
                self.scrollView.setZoomScale(1, animated: false)

                let cropViewWidth = self.photoContentView.bounds.size.width * 0.55
                let cropViewHeight = self.photoContentView.bounds.size.height * 0.3
                
                self.cropView.frame = CGRect(x: rect.midX - cropViewWidth.half, y: rect.midY - cropViewHeight.half, width: cropViewWidth, height: cropViewHeight)
                self.cropView.aspectRatioHeight = self.isPortraitImage ? 135 : 165
                self.cropView.aspectRatioWidth = self.isPortraitImage ? 165 : 135
                self.cropView.lockAspectRatio(true)
                
                let rectCenterX = self.photoContentView.center.x - (self.photoContentView.center.y - rect.midY) / (self.originalSize.height / 2) * (self.originalSize.width / 2)
                    
                let rectCenterY = self.photoContentView.center.y - (self.photoContentView.center.x - rect.midX) / (self.originalSize.width / 2) * (self.originalSize.height / 2) + 10
                
                self.cropView.center = CGPoint(x: rectCenterX, y: rectCenterY)
            })
            
        }
////            UIView.animate(withDuration: kAnimationDuration, animations: { [weak self] () -> Void in
////                guard let `self` = self else { return }
////
////                self.angle = 0
////                self.scrollView.transform = CGAffineTransform.identity
////                self.scrollView.center = CGPoint(x: self.centerY, y: self.frame.height.half)
////                self.scrollView.bounds = CGRect(x: CGFloat.zero,
////                                                y: CGFloat.zero,
////                                                width: self.originalSize.height,
////                                                height: self.originalSize.width)
////                self.scrollView.minimumZoomScale = 1
////                self.scrollView.setZoomScale(1, animated: false)
////
////                self.cropView.frame = rect
////
////                self.cropView.center = CGPoint(x: rect.midY, y: rect.midX)
////            })
//
//            UIView.animate(withDuration: kAnimationDuration, animations: { [weak self] () -> Void in
//                guard let `self` = self else { return }
//
//                self.angle = 0
//                self.scrollView.transform = CGAffineTransform.identity
//                self.scrollView.center = CGPoint(x: self.frame.width.half, y: self.centerY)
//                self.scrollView.bounds = CGRect(x: CGFloat.zero,
//                                                y: CGFloat.zero,
//                                                width: self.originalSize.width,
//                                                height: self.originalSize.height)
//                self.scrollView.minimumZoomScale = 1
//                self.scrollView.setZoomScale(1, animated: false)
//
//                self.cropView.frame = rect
//
//                self.cropView.center = CGPoint(x: rect.midX, y: rect.midY)
//            })
//        }
        
    }
    
    //MARK: - Private FUNCs
    
    fileprivate func maxBounds() -> CGRect {
        // scale the image
        maximumCanvasSize = CGSize(width: (kMaximumCanvasWidthRatio * frame.size.width),
                                        height: (kMaximumCanvasHeightRatio * frame.size.height - canvasHeaderHeigth()))
        
        centerY = maximumCanvasSize.height.half + canvasHeaderHeigth()
        
        let scaleX: CGFloat = image.size.width / maximumCanvasSize.width
        let scaleY: CGFloat = image.size.height / maximumCanvasSize.height
        let scale: CGFloat = max(scaleX, scaleY)
        
        let bounds = CGRect(x: CGFloat.zero,
                            y: CGFloat.zero,
                            width: (image.size.width / scale),
                            height: (image.size.height / scale))
        
        return bounds
    }
    
    internal func updatePosition() {
        // position scroll view
        let width: CGFloat = fabs(cos(angle)) * cropView.frame.size.width + fabs(sin(angle)) * cropView.frame.size.height
        let height: CGFloat = fabs(sin(angle)) * cropView.frame.size.width + fabs(cos(angle)) * cropView.frame.size.height
        let center: CGPoint = scrollView.center
        let contentOffset: CGPoint = scrollView.contentOffset
        let contentOffsetCenter = CGPoint(x: (contentOffset.x + scrollView.bounds.size.width.half),
                                          y: (contentOffset.y + scrollView.bounds.size.height.half))
        scrollView.bounds = CGRect(x: CGFloat.zero, y: CGFloat.zero, width: width, height: height)
        let newContentOffset = CGPoint(x: (contentOffsetCenter.x - scrollView.bounds.size.width.half),
                                       y: (contentOffsetCenter.y - scrollView.bounds.size.height.half))
        scrollView.contentOffset = newContentOffset
        scrollView.center = center
        
        // scale scroll view
        let shouldScale: Bool = scrollView.contentSize.width / scrollView.bounds.size.width <= 1.0 ||
            scrollView.contentSize.height / scrollView.bounds.size.height <= 1.0
        if !manualZoomed || shouldScale {
            let zoom = scrollView.zoomScaleToBound()
            scrollView.setZoomScale(zoom, animated: false)
            scrollView.minimumZoomScale = zoom
            manualZoomed = false
        }
        
        scrollView.checkContentOffset()
    }
}
