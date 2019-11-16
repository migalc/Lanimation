//
//  LNDCoachmarkOverlayView.swift
//  Lanimation
//
//  Created by Miguel Alcantara on 16/11/2019.
//  Copyright © 2019 miguelalc. All rights reserved.
//

import UIKit

// MARK: Protocols

protocol LNDCoachmarkOverlayViewProtocol {
    
}

// MARK: Coachmark Overlay View

class LNDCoachmarkOverlayView: LNDBaseView, LNDCoachmarkOverlayViewProtocol {
    
    // MARK: Properties
    
    private var _overlayColor: UIColor = .clear
    private var _transparentViewSize: CGSize = .zero
    private lazy var _destinationRect: CGRect = .zero
    private lazy var _destinationRadius: CGFloat = 0
    private lazy var _originRect: CGRect = .zero
    private lazy var _originRadius: CGFloat = 0
    private lazy var _destinationPath: CGPath! = nil
    private lazy var _transparentLayer: CAShapeLayer? = nil
    
    private var _extraRadius: CGFloat = 2
    
    // MARK: Initializers
    
    convenience init(color: UIColor, transparentViewSize: CGSize) {
        self.init(frame: .zero)
        _overlayColor = color
        _transparentViewSize = transparentViewSize
        setupViews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    // MARK: Protocol Functions
    
    func moveTo(rect: CGRect, radius: CGFloat) {
        _originRect = _destinationRect
        _originRadius = _destinationRadius
        _destinationRect = rect
        _destinationRadius = radius
        
        if _transparentLayer == nil {
            _transparentLayer = CALayer.createTransparentLayer(viewRect: bounds, viewColor: _overlayColor, targetOrigin: _destinationRect.origin, targetWidth: _transparentViewSize.width, targetHeight: _transparentViewSize.height, layerOpacity: 1)
            layer.mask = _transparentLayer
        }
        
        startAnimations()
    }
    
    // MARK: Private helper Functions
    
    private func setupViews() {
        backgroundColor = _overlayColor
    }
    
    private func startAnimations() {
        let animationList = getAnimationList()
        let group = CAAnimationGroup()
        group.delegate = self
        group.animations = animationList
        group.duration = animationList.map { $0.duration }.reduce(into: 0.0, { $0 += $1 })
        group.isRemovedOnCompletion = false
        group.fillMode = .forwards
        
        _transparentLayer?.add(group, forKey: "moveAnim")
    }
    
    private func getAnimationList() -> [CAAnimation] {
        let translationAnimations = createTranslationAnimations()
        let scaleAnimations = createScaleAnimation()
        
        return [scaleAnimations, translationAnimations].flatMap { $0 }
    }
    
    private func createScaleAnimation() -> [CAAnimation] {
        let newLayer = CALayer.createTransparentLayer(viewRect: frame,
                                                       viewColor: _overlayColor,
                                                       targetOrigin: _destinationRect.origin,
                                                       targetWidth: _destinationRect.width,
                                                       targetHeight: _destinationRect.height,
                                                       cornerRadius: _destinationRadius)
        
        let scaleAnimation = CABasicAnimation(keyPath: "path")
        scaleAnimation.delegate = self
        scaleAnimation.fromValue = _destinationPath
        scaleAnimation.toValue = newLayer.path
        scaleAnimation.beginTime = 1
        scaleAnimation.duration = 0.2
        scaleAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        
        _destinationPath = newLayer.path
        
        return [scaleAnimation]
    }
    
    private func createTranslationAnimations() -> [CAAnimation] {
        let firstAnimation = createFirstTranslationAnimation()
        let secondAnimation = createSecondTranslationAnimation(from: firstAnimation)
        return [firstAnimation, secondAnimation]
    }
    
    private func createFirstTranslationAnimation() -> CABasicAnimation {
        let midPoint = CGPoint(x: (_originRect.origin.x + _destinationRect.origin.x) / 2, y: (_originRect.origin.y + _destinationRect.origin.y) / 2)

        let newLayer = CALayer.createTransparentLayer(viewRect: frame,
                                                    viewColor: _overlayColor,
                                                    targetOrigin: midPoint,
                                                    targetWidth: _transparentViewSize.width * 0.85,
                                                    targetHeight:_transparentViewSize.height * 0.85,
                                                    cornerRadius: _originRadius)
        
        let animation = CABasicAnimation(keyPath: "path")
        animation.delegate = self
        animation.fromValue = _transparentLayer?.path
        animation.toValue = newLayer.path
        animation.duration = 0.5
        animation.timingFunction = CAMediaTimingFunction(name: .easeIn)
        
        return animation
    }
    
    private func createSecondTranslationAnimation(from firstAnimation: CABasicAnimation) -> CABasicAnimation {
        let newLayer2 = CALayer.createTransparentLayer(viewRect: frame,
                                                       viewColor: _overlayColor,
                                                       targetOrigin: _destinationRect.origin.applying(CGAffineTransform.init(translationX: -_extraRadius/2, y: -_extraRadius/2)),
                                                       targetWidth: _destinationRect.width + _extraRadius,
                                                       targetHeight: _destinationRect.height + _extraRadius,
                                                       cornerRadius: _destinationRadius)
        
        let animation2 = CABasicAnimation(keyPath: "path")
        animation2.delegate = self
        animation2.fromValue = firstAnimation.toValue
        animation2.toValue = newLayer2.path
        animation2.beginTime = firstAnimation.duration
        animation2.duration = 0.5
        animation2.timingFunction = CAMediaTimingFunction(name: .easeOut)
        
        _destinationPath = newLayer2.path
        
        return animation2
    }
    
}

extension LNDCoachmarkOverlayView: CAAnimationDelegate {
    
    func animationDidStart(_ anim: CAAnimation) {
        isUserInteractionEnabled = false
        print("didStart, anim = \(anim)")
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        print("didstop, finished = \(flag)")
        isUserInteractionEnabled = true
        guard flag else { return }
        _transparentLayer?.path = _destinationPath
    }
}
