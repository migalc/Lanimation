//
//  UIView+Extensions.swift
//  Lanimation
//
//  Created by Miguel Alcantara on 16/11/2019.
//  Copyright © 2019 miguelalc. All rights reserved.
//

import UIKit

extension UIView {
    
    func anchorToSuperview(toSafeArea: Bool = true) {
        guard let superview = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.centerYAnchor).isActive = true
        heightAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.heightAnchor).isActive = true
        widthAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.widthAnchor).isActive = true
    }
    
    func animateColor(withDuration: TimeInterval = 0.5, delay: TimeInterval = 0, color: UIColor) {
        let originalColor = self.backgroundColor
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: withDuration,
                                                       delay: delay,
                                                       options: [.curveEaseInOut, .autoreverse], animations: { [weak self] in
            guard let self = self else { return }
            self.backgroundColor = color
            self.backgroundColor = originalColor
        }, completion: nil)
    }
    
}

extension CALayer {

    static func createTransparentLayer(viewRect: CGRect,
                                viewColor: UIColor,
                                targetOrigin: CGPoint,
                                targetWidth: CGFloat,
                                targetHeight: CGFloat,
                                cornerRadius: CGFloat = 0,
                                layerOpacity: Float = 0.5,
                                contents: Any? = nil) -> CAShapeLayer {
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: viewRect.size.width, height: viewRect.size.height), cornerRadius: 0)
        let transparentPath = UIBezierPath(roundedRect: CGRect(x: targetOrigin.x, y: targetOrigin.y, width: targetWidth, height: targetHeight), cornerRadius: cornerRadius)
        path.append(transparentPath)
        
        let fillLayer = CAShapeLayer()
        fillLayer.path = path.cgPath
        fillLayer.fillRule = CAShapeLayerFillRule.evenOdd
        fillLayer.fillColor = viewColor.cgColor
        fillLayer.opacity = layerOpacity

        return fillLayer
    }
    
}
