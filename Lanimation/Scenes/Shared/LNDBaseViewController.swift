//
//  LNDLNDBaseViewController.swift
//  Lanimation
//
//  Created by Miguel Alcantara on 16/11/2019.
//  Copyright © 2019 miguelalc. All rights reserved.
//

import UIKit

// MARK: Protocols

// MARK: Base view controller implementation

class LNDBaseViewController: UIViewController {
    
    // MARK: Properties
    lazy var lndTabItem: LNDTabBarItem = {
        return LNDTabBarItem(image: tabImage, text: tabText)
    }()
    
    private var tabImage: UIImage = UIImage(named: "Legend")!
    private var tabText: String?
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Public functions
    
    func setTabItem(with image: UIImage, text: String? = nil) {
        tabImage = image
        tabText = text
    }
    
}
