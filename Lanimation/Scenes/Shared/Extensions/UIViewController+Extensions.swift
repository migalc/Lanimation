//
//  UIViewController+Extensions.swift
//  Lanimation
//
//  Created by Miguel Alcantara on 17/11/2019.
//  Copyright © 2019 miguelalc. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showIn(parentVC: UIViewController) {
        parentVC.view.addSubview(view)
        parentVC.addChild(self)
        didMove(toParent: parentVC)
    }
    
    func hideFromParent() {
        view.removeFromSuperview()
        removeFromParent()
        didMove(toParent: nil)
    }
    
}
