//
//  CoachmarkCustomPresentationController.swift
//  Lanimation
//
//  Created by Miguel Alcantara on 17/11/2019.
//  Copyright © 2019 miguelalc. All rights reserved.
//

import UIKit

// MIGUEL: Adapting the presentation to fit half of the parent view. https://developer.apple.com/library/archive/featuredarticles/ViewControllerPGforiPhoneOS/DefiningCustomPresentations.html

// MARK: Custom Presentation Controller implementation

class CoachmarkCustomPresentationController: UIPresentationController {
    
    // MARK: Properties
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let container = containerView else { return .zero }
        let constrainedHeight = container.bounds.height / 2
        return CGRect(x: container.bounds.origin.x,
                      y: container.bounds.origin.y + constrainedHeight,
                      width: container.bounds.width,
                      height: constrainedHeight)
    }
    
    // MARK: Subviews
    
    private lazy var _dimmingView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor(white: 0, alpha: 0.4)
        
        return view
    }()
    
    // MARK: Initializers
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
    
    // MARK: Overridden functions
    
    override func presentationTransitionWillBegin() {
        // Get critical information about the presentation.
        let container = containerView
        let presentedVC = presentedViewController
        
        // Set the dimming view to the size of the container's
        // bounds, and make it transparent initially.
        _dimmingView.frame = container?.bounds ?? .zero
        _dimmingView.alpha = 0
        
        // Insert the dimming view below everything else.
        container?.insertSubview(_dimmingView, at: 0)
        
        // Set up the animations for fading in the dimming view.
        guard let transtionCoordinator = presentedVC.transitionCoordinator else {
            _dimmingView.alpha = 0
            return
        }
        
        transtionCoordinator.animate(alongsideTransition: { (context) in
            self._dimmingView.alpha = 0
        }, completion: nil)
    }
    
    override func dismissalTransitionWillBegin() {
        // Get critical information about the presentation.
        let presentedVC = presentedViewController
        
        // Set up the animations for fading in the dimming view.
        guard let transtionCoordinator = presentedVC.transitionCoordinator else {
            _dimmingView.alpha = 0
            return
        }
        
        transtionCoordinator.animate(alongsideTransition: { (context) in
            self._dimmingView.alpha = 0
        }, completion: nil)
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        guard !completed else { return }
        _dimmingView.removeFromSuperview()
    }

}
