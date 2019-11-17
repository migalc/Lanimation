//
//  LNDLabel.swift
//  Lanimation
//
//  Created by Miguel Alcantara on 17/11/2019.
//  Copyright © 2019 miguelalc. All rights reserved.
//

import UIKit

// MARK: Typealias

typealias LNDLabelAnimation = (() -> Void)

// MARK: Protocol

protocol LNDLabelProtocol: class {
    func startAnimation()
}

// MARK: LND Label Implementation

class LNDLabel: UILabel, LNDLabelProtocol {
    
    // MARK: Properties
    
    private lazy var _propertyAnimator: UIViewPropertyAnimator = {
        let animator = UIViewPropertyAnimator(duration: 1, curve: .easeInOut, animations: nil)
        
        return animator
    }()
    
    private var _animation: LNDLabelAnimation?
    private var _animationDelay: TimeInterval = 0
    
    // MARK: Initializers

    convenience init(text: String, tag: Int) {
        self.init(frame: .zero)
        setupLabel(text: text, tag: tag)
    }
    
    // MARK: Protocol Functions
    
    func setupAnimation(animation: LNDLabelAnimation?, animationDelay: TimeInterval = 0) {
        self._animation = animation
        self._animationDelay = animationDelay
        
        guard let animation = _animation else { return }
        _propertyAnimator.addAnimations(animation)
    }
    
    func startAnimation() {
        _propertyAnimator.startAnimation(afterDelay: _animationDelay)
    }
    
    // MARK: Private helper functions
    
    private func setupLabel(text: String, tag: Int) {
        self.tag = tag
        self.text = text
        self.textColor = .white
        
        
    }
    
}
