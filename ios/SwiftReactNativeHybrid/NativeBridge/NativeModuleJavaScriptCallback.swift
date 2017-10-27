//
//  NativeModuleJavaScriptCallback.swift
//  SwiftReactNativeHybrid
//
//  Created by Jeremy Gale on 2017-06-13.
//  Copyright © 2017 Solium Capital Inc. All rights reserved.
//

import Foundation
import React

@objc(NativeModuleJavaScriptCallback)
class NativeModuleJavaScriptCallback: NSObject {
    
    // This key must match the value used in JavaScript
    static let swiftButtonEnabledKey = "swiftButtonEnabled"
    
    var scanFlowConntroller: ScanFlowController?
    
    func toggleSwiftButtonEnabled( _ callback: @escaping RCTResponseSenderBlock) {
        // You won't be on the main thread when called from JavaScript
        DispatchQueue.main.async {
            guard let tabBarController = UIApplication.shared.keyWindow?.rootViewController as? TabBarController,
                let firstViewController = tabBarController.viewControllers?.first as? FirstViewController else {
                    return
            }
            
            let newEnabledState = !firstViewController.incrementButton.isEnabled
            firstViewController.incrementButton.isEnabled = newEnabledState
            
            let callbackInfo = [NativeModuleJavaScriptCallback.swiftButtonEnabledKey: newEnabledState]
            callback([callbackInfo])
        }
    }
    
    ////////////////////////////////////////////////////////////////////////////
    // Barcode scanning
    
    func scanBarcode( _ callback: @escaping RCTResponseSenderBlock) {
        // You won't be on the main thread when called from JavaScript
        DispatchQueue.main.async {
            guard let tabBarController = UIApplication.shared.keyWindow?.rootViewController as? TabBarController else {
                return
            }
            
            let barcodeStoryboard = UIStoryboard(name: "BarcodeScan", bundle: nil)
            if let barcodeController = barcodeStoryboard.instantiateInitialViewController() as? BarcodeScanViewController {
                barcodeController.barcodeScannerCallback = callback
                tabBarController.present(barcodeController, animated: true, completion: nil)
            }
        }
    }
    
    ////////////////////////////////////////////////////////////////////////////
    // ID card scanning
    
    func scanIDCard( _ callback: @escaping RCTResponseSenderBlock) {
        // You won't be on the main thread when called from JavaScript
        DispatchQueue.main.async { [weak self] in
            guard let tabBarController = UIApplication.shared.keyWindow?.rootViewController as? TabBarController else {
                return
            }
            
            self?.scanFlowConntroller = ScanFlowController()
            self?.scanFlowConntroller?.callback = callback
            self?.scanFlowConntroller?.presentingController = tabBarController
            self?.scanFlowConntroller?.startScanFlow(.idCard)
        }
    }
    
    ////////////////////////////////////////////////////////////////////////////
    // Scan user face
    
    func takePatientPhoto( _ callback: @escaping RCTResponseSenderBlock) {
        // You won't be on the main thread when called from JavaScript
        DispatchQueue.main.async { [weak self] in
            guard let tabBarController = UIApplication.shared.keyWindow?.rootViewController as? TabBarController else {
                return
            }
            
            self?.scanFlowConntroller = ScanFlowController()
            self?.scanFlowConntroller?.callback = callback
            self?.scanFlowConntroller?.presentingController = tabBarController
            self?.scanFlowConntroller?.startScanFlow(.patientPhoto)
        }
    }
    
    ////////////////////////////////////////////////////////////////////////////
    // Scan doctor reference letter
    
    func scanDoctorReferenceLetter( _ callback: @escaping RCTResponseSenderBlock) {
        // You won't be on the main thread when called from JavaScript
        DispatchQueue.main.async { [weak self] in
            guard let tabBarController = UIApplication.shared.keyWindow?.rootViewController as? TabBarController else {
                return
            }
            
            self?.scanFlowConntroller = ScanFlowController()
            self?.scanFlowConntroller?.callback = callback
            self?.scanFlowConntroller?.presentingController = tabBarController
            self?.scanFlowConntroller?.startScanFlow(.doctorReferenceLetter)
        }
    }
    
    
}
