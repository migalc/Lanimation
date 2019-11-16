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
        let layoutGuide = toSafeArea ? superview.safeAreaLayoutGuide : superview.layoutMarginsGuide
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: layoutGuide.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: layoutGuide.centerYAnchor).isActive = true
        heightAnchor.constraint(equalTo: layoutGuide.heightAnchor).isActive = true
        widthAnchor.constraint(equalTo: layoutGuide.widthAnchor).isActive = true
    }
    
    @discardableResult
    func addTransparentLayer(targetOrigin: CGPoint,
                             targetWidth: CGFloat,
                             targetHeight: CGFloat,
                             cornerRadius: CGFloat = 0,
                             layerOpacity: Float = 0.5,
                             contents: Any? = nil) -> CALayer {
        
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height), cornerRadius: 0)
        let transparentPath = UIBezierPath(roundedRect: CGRect(x: targetOrigin.x, y: targetOrigin.y, width: targetWidth, height: targetHeight), cornerRadius: cornerRadius)
        path.append(transparentPath)
        
        let fillLayer = CAShapeLayer()
        fillLayer.path = path.cgPath
        fillLayer.fillRule = CAShapeLayerFillRule.evenOdd
        fillLayer.fillColor = backgroundColor?.cgColor ?? UIColor.clear.cgColor
        fillLayer.opacity = layerOpacity

        layer.contents = contents
        layer.mask = fillLayer
        
        return fillLayer
    }
    
    func addTransparentLayer(for layer: CAShapeLayer) {
        layer.mask = layer
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
