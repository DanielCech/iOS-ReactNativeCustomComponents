//
//  ScanFlowController.swift
//  Treez.io
//
//  Created by Dan on 26.09.2017.
//  Copyright (c) 2017 STRV. All rights reserved.
//

import UIKit
import React
import Photos

enum ScanFlow {
    case idCard
    case patientPhoto
    case doctorReferenceLetter
}

class ScanFlowController: NSObject {
    
    var callback: RCTResponseSenderBlock?
    weak var presentingController: UIViewController?
    
    fileprivate var _imagePickerController: ImagePickerController?
    fileprivate var _scanFlow: ScanFlow!
    fileprivate var _idCardScanFileURL: URL?
    fileprivate var _originalImageOrientation: UIImageOrientation?
    fileprivate var _deviceOrientation: UIDeviceOrientation?
    
    func startScanFlow(_ flow: ScanFlow) {
        
        _scanFlow = flow
        
        _askForCameraPermissions { [weak self] success in
            guard let `self` = self else { return }
            
            if success {
                var pickerConfiguration = Configuration()
                pickerConfiguration.allowMultiplePhotoSelection = false
                
                self._imagePickerController = ImagePickerController()
                self._imagePickerController?.configuration = pickerConfiguration
                self._imagePickerController?.scanFlow = flow
                self._imagePickerController?.delegate = self
                
                let navigationController = UINavigationController(rootViewController: self._imagePickerController!)
                
                DispatchQueue.main.async {
                    self.presentingController?.present(navigationController, animated: true, completion: nil)
                }
            }
            else {
                DispatchQueue.main.async { [weak self] in
                    self?._presentOpenSettingsURL(title: "Error", message: "Unable to access camera")
                }
            }
        }
    }
    
    fileprivate func _askForCameraPermissions(completion: @escaping (_ success: Bool) -> Void) {
//        let cameraMediaType =
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch cameraAuthorizationStatus {
        case .denied:
            completion(false)
        case .authorized:
            completion(true)
        case .restricted:
            completion(false)
            
        case .notDetermined:
            // Prompting user for the permission to use the camera.
            AVCaptureDevice.requestAccess(for: .video) { granted in
                completion(granted)
            }
        }
    }
    
    fileprivate func _presentOpenSettingsURL(title: String, message: String?, cancel: ((UIAlertAction) -> Swift.Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: cancel))
        alert.addAction(UIAlertAction(title: "Open Settings", style: .default, handler: { _ in
            UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
        }))
        presentingController?.present(alert, animated: true, completion: nil)
    }
    
    fileprivate func _overlayView(flow: ScanFlow) -> UIView {
        let wrapperView = UIView(frame: CGRect(x: 0, y: 0, width: DCToolbox.screenWidth(), height: DCToolbox.screenHeight() * 0.7))
        
        let patientFocusOverlayView = PatientFocusOverlayView(frame: .zero)
        patientFocusOverlayView.translatesAutoresizingMaskIntoConstraints = false
        wrapperView.addSubview(patientFocusOverlayView)
        
        patientFocusOverlayView.centerXAnchor.constraint(equalTo: wrapperView.centerXAnchor).isActive = true
        patientFocusOverlayView.centerYAnchor.constraint(equalTo: wrapperView.centerYAnchor, constant: -DCToolbox.screenHeight() / 12.0).isActive = true
        patientFocusOverlayView.leftAnchor.constraint(equalTo: wrapperView.leftAnchor, constant: DCToolbox.screenWidth() / 10.0).isActive = true
        patientFocusOverlayView.widthAnchor.constraint(equalTo: patientFocusOverlayView.heightAnchor, multiplier: 1).isActive = true
        
        return wrapperView
    }
    
    fileprivate func _processIDCard(navController: UINavigationController?, image: UIImage) {
        let modifiedImage: UIImage
        if (_originalImageOrientation == .right) && (_deviceOrientation == .faceUp) {
            modifiedImage = ImageUtils.imageRotatedByMInus90(oldImage: image)
        }
        else {
            modifiedImage = image
        }
        
        let cropController = IDCardCropViewController()
        cropController.image = modifiedImage
        cropController.delegate = self
        cropController.modalTransitionStyle = .crossDissolve
        
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = kCATransitionFade
        navController?.view.layer.add(transition, forKey: nil)
        
        navController?.pushViewController(cropController, animated: false)
    }
}

extension ScanFlowController: ImagePickerDelegate {
    
    func imagePicker(pickerController: ImagePickerController?, didTakePhoto image: UIImage) {
        guard let imagePicker = pickerController, let overlayFrame = imagePicker.overlayFrame else { return }
        
        _originalImageOrientation = image.imageOrientation
        _deviceOrientation = UIDevice.current.orientation
        
        let croppedImage = ImageUtils.cropToOverlayFrame(image: image, imageScreenFrame: imagePicker.cameraController.view.bounds, cropScreenFrame: overlayFrame, scanFlow: _scanFlow!)
        
        imagePicker.showCroppedImage(image: croppedImage)
    }
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        guard let croppedImage = imagePicker.croppedImage else { return }
        
        let fileName: String
        
        switch _scanFlow! {
        case .idCard:
            fileName = "id_card.jpg"
        case .patientPhoto:
            fileName = "patient_photo.jpg"
        case .doctorReferenceLetter:
            fileName = "reference_letter.jpg"
        }
        
        guard let data = UIImageJPEGRepresentation(croppedImage, 0.8) else {
            self.callback?([["error": "invalid image data"], NSNull()]);
            return
        }
        
        let fileURL = DCToolbox.getDocumentsDirectory().appendingPathComponent(fileName)
        try? data.write(to: fileURL)
        
        if self._scanFlow == .idCard {
            _idCardScanFileURL = fileURL
            //print("image.size \(croppedImage.size), image.orientation \(croppedImage.imageOrientation)")
            self._processIDCard(navController: imagePicker.navigationController, image: croppedImage)
        }
        else {
            let url = (fileURL.absoluteString) as NSString
            self.callback?([NSNull(), url])
            
            presentingController?.dismiss(animated: true)
        }
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        presentingController?.dismiss(animated: true, completion: nil)
    }
    
}

extension ScanFlowController: IGRPhotoTweakViewControllerDelegate {
    
    func photoTweaksController(_ controller: IGRPhotoTweakViewController, didFinishWithCroppedImage croppedImage: UIImage) {
        guard let idScanURL = _idCardScanFileURL else { return }
        
        guard let data = UIImageJPEGRepresentation(croppedImage, 0.8) else {
            self.callback?([["error": "invalid image data"], NSNull()]);
            return
        }
        
        let idScanFacePhotoURL = DCToolbox.getDocumentsDirectory().appendingPathComponent("id_card_face.jpg")
        try? data.write(to: idScanFacePhotoURL)
        
        let idScanURLString = (idScanURL.absoluteString) as NSString
        let idScanFaceURLString = (idScanFacePhotoURL.absoluteString) as NSString
        
        self.callback?([NSNull(), ["idCard": idScanURLString, "idFace": idScanFaceURLString]])
        
        presentingController?.dismiss(animated: true, completion: nil)
    }
    
    func photoTweaksControllerDidCancel(_ controller: IGRPhotoTweakViewController) {
        presentingController?.dismiss(animated: true, completion: nil)
    }
}

