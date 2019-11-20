//
//  SecondViewController.swift
//  Lanimation
//
//  Created by Miguel Alcantara on 16/11/2019.
//  Copyright © 2019 miguelalc. All rights reserved.
//

import UIKit

class SecondViewController: LNDBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        title = "View 2"
        view.backgroundColor = .red
        tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 2)
        
        if #available(iOS 13.0, *) {
            setTabItem(with: UIImage(systemName: "pencil")!, text: title)
        } else {
            // Fallback on earlier versions
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
