//
//  ViewController.swift
//  Lanimation
//
//  Created by Miguel Alcantara on 16/11/2019.
//  Copyright © 2019 miguelalc. All rights reserved.
//

import UIKit

class ViewController: LNDBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        title = "View 1"
        tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 1)
    }

}

