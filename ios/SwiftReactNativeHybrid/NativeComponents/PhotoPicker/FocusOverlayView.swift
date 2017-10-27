//
//  FocusOverlayView.swift
//  Treez.io
//
//  Created by Dan on 27.09.2017.
//  Copyright (c) 2017 STRV. All rights reserved.
//

import UIKit

class FocusOverlayView: UIView {

    let overlayColor = Constants.overlayColor
    
    private var _topLeftTopView: UIView!
    private var _topLeftLeftView: UIView!
    
    private var _topRightTopView: UIView!
    private var _topRightRightView: UIView!
    
    private var _bottomLeftBottomView: UIView!
    private var _bottomLeftLeftView: UIView!
    
    private var _bottomRightBottomView: UIView!
    private var _bottomRightRightView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        _setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    fileprivate func _setupLayout() {
        _topLeftTopView = UIView(frame: .zero)
        _topLeftTopView.translatesAutoresizingMaskIntoConstraints = false
        _topLeftTopView.backgroundColor = overlayColor
        addSubview(_topLeftTopView)
        
        _topLeftLeftView = UIView(frame: .zero)
        _topLeftLeftView.translatesAutoresizingMaskIntoConstraints = false
        _topLeftLeftView.backgroundColor = overlayColor
        addSubview(_topLeftLeftView)
        
        _topRightTopView = UIView(frame: .zero)
        _topRightTopView.translatesAutoresizingMaskIntoConstraints = false
        _topRightTopView.backgroundColor = overlayColor
        addSubview(_topRightTopView)
        
        _topRightRightView = UIView(frame: .zero)
        _topRightRightView.translatesAutoresizingMaskIntoConstraints = false
        _topRightRightView.backgroundColor = overlayColor
        addSubview(_topRightRightView)
        
        _bottomLeftBottomView = UIView(frame: .zero)
        _bottomLeftBottomView.translatesAutoresizingMaskIntoConstraints = false
        _bottomLeftBottomView.backgroundColor = overlayColor
        addSubview(_bottomLeftBottomView)
        
        _bottomLeftLeftView = UIView(frame: .zero)
        _bottomLeftLeftView.translatesAutoresizingMaskIntoConstraints = false
        _bottomLeftLeftView.backgroundColor = overlayColor
        addSubview(_bottomLeftLeftView)
        
        _bottomRightBottomView = UIView(frame: .zero)
        _bottomRightBottomView.translatesAutoresizingMaskIntoConstraints = false
        _bottomRightBottomView.backgroundColor = overlayColor
        addSubview(_bottomRightBottomView)
        
        _bottomRightRightView = UIView(frame: .zero)
        _bottomRightRightView.translatesAutoresizingMaskIntoConstraints = false
        _bottomRightRightView.backgroundColor = overlayColor
        addSubview(_bottomRightRightView)
        
        ////////////////////////////////////////////////////////////////////////////
        
        _topLeftTopView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        _topLeftTopView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        _topLeftTopView.heightAnchor.constraint(equalToConstant: Constants.focusViewLineWidth).isActive = true
        _topLeftTopView.widthAnchor.constraint(equalToConstant: Constants.focusViewLineLenght).isActive = true
        
        _topLeftLeftView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        _topLeftLeftView.topAnchor.constraint(equalTo: topAnchor, constant: Constants.focusViewLineWidth).isActive = true
        _topLeftLeftView.heightAnchor.constraint(equalToConstant: Constants.focusViewLineLenght - Constants.focusViewLineWidth).isActive = true
        _topLeftLeftView.widthAnchor.constraint(equalToConstant: Constants.focusViewLineWidth).isActive = true
        
        _topRightTopView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        _topRightTopView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        _topRightTopView.heightAnchor.constraint(equalToConstant: Constants.focusViewLineWidth).isActive = true
        _topRightTopView.widthAnchor.constraint(equalToConstant: Constants.focusViewLineLenght).isActive = true
        
        _topRightRightView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        _topRightRightView.topAnchor.constraint(equalTo: topAnchor, constant: Constants.focusViewLineWidth).isActive = true
        _topRightRightView.heightAnchor.constraint(equalToConstant: Constants.focusViewLineLenght - Constants.focusViewLineWidth).isActive = true
        _topRightRightView.widthAnchor.constraint(equalToConstant: Constants.focusViewLineWidth).isActive = true
        
        
        _bottomLeftBottomView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        _bottomLeftBottomView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        _bottomLeftBottomView.heightAnchor.constraint(equalToConstant: Constants.focusViewLineWidth).isActive = true
        _bottomLeftBottomView.widthAnchor.constraint(equalToConstant: Constants.focusViewLineLenght).isActive = true
        
        _bottomLeftLeftView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        _bottomLeftLeftView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.focusViewLineWidth).isActive = true
        _bottomLeftLeftView.heightAnchor.constraint(equalToConstant: Constants.focusViewLineLenght - Constants.focusViewLineWidth).isActive = true
        _bottomLeftLeftView.widthAnchor.constraint(equalToConstant: Constants.focusViewLineWidth).isActive = true
        
        _bottomRightBottomView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        _bottomRightBottomView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        _bottomRightBottomView.heightAnchor.constraint(equalToConstant: Constants.focusViewLineWidth).isActive = true
        _bottomRightBottomView.widthAnchor.constraint(equalToConstant: Constants.focusViewLineLenght).isActive = true
        
        _bottomRightRightView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        _bottomRightRightView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.focusViewLineWidth).isActive = true
        _bottomRightRightView.heightAnchor.constraint(equalToConstant: Constants.focusViewLineLenght - Constants.focusViewLineWidth).isActive = true
        _bottomRightRightView.widthAnchor.constraint(equalToConstant: Constants.focusViewLineWidth).isActive = true
        
    }

}
