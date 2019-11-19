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
    
    // MARK: Initializers
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
    
}
