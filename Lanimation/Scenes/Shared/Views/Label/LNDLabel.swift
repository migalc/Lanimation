//
//  LNDLabel.swift
//  Lanimation
//
//  Created by Miguel Alcantara on 17/11/2019.
//  Copyright © 2019 miguelalc. All rights reserved.
//

import UIKit

// MARK: Protocol

protocol LNDLabelProtocol: class {
    
}

// MARK: LND Label Implementation

class LNDLabel: UILabel, LNDLabelProtocol {
    
    // MARK: Initializers

    convenience init(text: String, tag: Int) {
        self.init(frame: .zero)
        setupLabel(text: text, tag: tag)
    }
    
    // MARK: Protocol Functions
    
    // MARK: Private helper functions
    
    private func setupLabel(text: String, tag: Int) {
        self.tag = tag
        self.text = text
        self.textColor = .white
    }
    
}
