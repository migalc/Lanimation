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
    
    private var _animationTotal: Double = 0
    private var _overlayColor: UIColor = .clear
    private lazy var _destinationRect: CGRect = .zero
    private lazy var _destinationRadius: CGFloat = 0
    private lazy var _originRect: CGRect = .zero
    private lazy var _originRadius: CGFloat = 0
    private lazy var _destinationPath: CGPath! = nil
    private lazy var _transparentLayer: CAShapeLayer? = nil
    private var _scaleFactor: CGFloat = 0.85
    private var _extraRadius: CGFloat = 4
    
    private var _scaleAnimationTotal: Double {
        return 0.2
    }
    
    private var _translationAnimationTotal: Double {
        return _animationTotal - _scaleAnimationTotal
    }
    
    // MARK: Initializers
    
    convenience init(color: UIColor, animationTotal: Double) {
        self.init(frame: .zero)
        _overlayColor = color
        _animationTotal = animationTotal
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
            initializeTransparentView()
        }
        
        startAnimations()
    }
    
    // MARK: Private helper Functions
    
    private func setupViews() {
        backgroundColor = _overlayColor.withAlphaComponent(0.8)
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
        let translationAnimations = createTranslationAnimations(isInitial: _destinationRect == _originRect)
        let scaleAnimations = createScaleAnimation()
        
        return [scaleAnimations, translationAnimations].flatMap { $0 }
    }
    
    
    
    private func initializeTransparentView() {
        _originRect = _destinationRect
        _originRadius = _destinationRadius
        let originCenter: CGPoint = _originRect.getCenter()
        
        _transparentLayer = CALayer.createTransparentLayer(viewRect: frame,
                                                           viewColor: _overlayColor,
                                                           targetOrigin: originCenter,
                                                           targetWidth: 0,
                                                           targetHeight: 0,
                                                           cornerRadius: _destinationRadius,
                                                           layerOpacity: 1)
        layer.mask = _transparentLayer
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
        scaleAnimation.beginTime = _translationAnimationTotal
        scaleAnimation.duration = _scaleAnimationTotal
        scaleAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        
        _destinationPath = newLayer.path
        
        return [scaleAnimation]
    }
    
    private func createTranslationAnimations(isInitial: Bool) -> [CAAnimation] {
        let factor: CGFloat = isInitial ? 1 : _scaleFactor
        let firstAnimation = createFirstTranslationAnimation(targetSize: CGSize(width: _destinationRect.width * factor, height: _destinationRect.height * factor))
        let secondAnimation = createSecondTranslationAnimation(from: firstAnimation)
        return [firstAnimation, secondAnimation]
    }
    
    private func createFirstTranslationAnimation(targetSize: CGSize) -> CABasicAnimation {
        let newLayer = CALayer.createTransparentLayer(viewRect: frame,
                                                    viewColor: _overlayColor,
                                                    targetOrigin: calculateMidpoint(between: _originRect.origin, and: _destinationRect.origin),
                                                    targetWidth: targetSize.width ,
                                                    targetHeight: targetSize.height,
                                                    cornerRadius: _originRadius)
        
        let animation = CABasicAnimation(keyPath: "path")
        animation.delegate = self
        animation.fromValue = _transparentLayer?.path
        animation.toValue = newLayer.path
        animation.duration = _translationAnimationTotal / 2
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
        animation2.duration = _translationAnimationTotal / 2
        animation2.timingFunction = CAMediaTimingFunction(name: .easeOut)
        
        _destinationPath = newLayer2.path
        
        return animation2
    }
    
    private func calculateMidpoint(between point1: CGPoint, and point2: CGPoint) -> CGPoint {
        return CGPoint(x: (point1.x + point2.x) / 2, y: (point1.y + point2.y) / 2)
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
