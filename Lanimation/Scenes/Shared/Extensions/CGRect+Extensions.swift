//
//  CGRect+Extensions.swift
//  Lanimation
//
//  Created by Miguel Alcantara on 17/11/2019.
//  Copyright © 2019 miguelalc. All rights reserved.
//

import UIKit

extension CGRect {
    
    func getCenter() -> CGPoint {
        let x = origin.x + width / 2
        let y = origin.y + height / 2
        
        return CGPoint(x: x, y: y)
    }
    
}
