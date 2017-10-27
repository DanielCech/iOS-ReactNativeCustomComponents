//
//  IDCardCropViewController.swift
//  Treez
//
//  Created by Dan on 2/7/17.
//  Copyright (c) 2017 STRV. All rights reserved.
//

import UIKit

class IDCardCropViewController: IGRPhotoTweakViewController {
    
    /**
     Slider to change angle.
     */
    fileprivate var _horizontalDial: HorizontalDial!
    fileprivate var _fakeNavbar: UIView!
    
    fileprivate var _cancelButton: UIButton!
    fileprivate var _cropButton: UIButton!
    var titleLabel: UILabel!
    
    //var isPortaitImage: Bool = true
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - Life Cicle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        _setupFakeNavbar()
        _setupHorizontalDial()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let faceRectangle = FaceDetector.detectFace(image: image, rectangle: photoView.bounds) {
            photoView.setCrop(rect: faceRectangle, image: image)
        }
        else {
            photoView.setCrop(rect: CGRect(x: 0, y: 0, width: 300, height: 300), image: image)
        }
        
        photoView.cropViewDidStopCrop(photoView.cropView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Rotation
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        
        coordinator.animate(alongsideTransition: { (context) in
            self.view.layoutIfNeeded()
        }) { (context) in
            //
        }
    }
    
    // MARK: - Setup UI
    
    fileprivate func _setupFakeNavbar() {
        _fakeNavbar = UIView(frame: .zero)
        _fakeNavbar.backgroundColor = .black
        _fakeNavbar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(_fakeNavbar)
        
        _fakeNavbar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        _fakeNavbar.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        _fakeNavbar.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        _fakeNavbar.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        _cancelButton = UIButton(type: .system)
        _cancelButton.translatesAutoresizingMaskIntoConstraints = false
        _cancelButton.setTitle("Cancel", for: .normal)
        _cancelButton.setTitleColor(.white, for: .normal)
        _cancelButton.titleLabel?.font = UIFont(name: "Roboto-Medium", size: 18)
        _cancelButton.addTarget(self, action: #selector(IDCardCropViewController.onTouchCancel(_:)), for: .touchUpInside)
        _fakeNavbar.addSubview(_cancelButton)
        
        _cancelButton.leadingAnchor.constraint(equalTo: _fakeNavbar.leadingAnchor, constant: 16).isActive = true
        _cancelButton.centerYAnchor.constraint(equalTo: _fakeNavbar.centerYAnchor).isActive = true
        
        _cropButton = UIButton(type: .system)
        _cropButton.translatesAutoresizingMaskIntoConstraints = false
        _cropButton.setTitle("Crop", for: .normal)
        _cropButton.setTitleColor(.white, for: .normal)
        _cropButton.titleLabel?.font = UIFont(name: "Roboto-Medium", size: 18)
        _cropButton.addTarget(self, action: #selector(IDCardCropViewController.onTouchCrop(_:)), for: .touchUpInside)
        _fakeNavbar.addSubview(_cropButton)
        
        _cropButton.trailingAnchor.constraint(equalTo: _fakeNavbar.trailingAnchor, constant: -16).isActive = true
        _cropButton.centerYAnchor.constraint(equalTo: _fakeNavbar.centerYAnchor).isActive = true
        
        titleLabel = UILabel(frame: .zero)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = .white
        titleLabel.text = "CROP PHOTO"
        titleLabel.font = UIFont(name: "Roboto-Medium", size: 18)
        _fakeNavbar.addSubview(titleLabel)
        
        titleLabel.centerXAnchor.constraint(equalTo: _fakeNavbar.centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: _fakeNavbar.centerYAnchor).isActive = true
    }
    
    fileprivate func _setupHorizontalDial() {
        _horizontalDial = HorizontalDial(frame: .zero)
        _horizontalDial.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(_horizontalDial)
        
        _horizontalDial.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        _horizontalDial.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        _horizontalDial.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        _horizontalDial.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        _horizontalDial?.migneticOption = .none
        _horizontalDial?.delegate = self
        
    }
    
    // MARK: - Actions
    
    @IBAction func onTouchCancel(_ sender: Any) {
        _cancelButton.isEnabled =  false
        self.dismissAction()
    }
    
    @IBAction func onTouchCrop(_ sender: Any) {
        _cropButton.isEnabled =  false
        cropAction()
    }
    
    open override func customCanvasHeaderHeigth() -> CGFloat {
        var height: CGFloat = 0.0
        
        if UIDevice.current.orientation.isLandscape {
            height = 40.0
        } else {
            height = 100.0
        }
        
        return height
    }
}

extension IDCardCropViewController: HorizontalDialDelegate {
    func horizontalDialDidValueChanged(_ horizontalDial: HorizontalDial) {
        let degrees = horizontalDial.value
        let radians = IGRRadianAngle.toRadians(CGFloat(degrees))
        
        self.changedAngle(value: radians)
    }
    
    func horizontalDialDidEndScroll(_ horizontalDial: HorizontalDial) {
        self.stopChangeAngle()
    }
}

