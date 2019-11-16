//
//  MainTabBarViewController.swift
//  Lanimation
//
//  Created by Miguel Alcantara on 16/11/2019.
//  Copyright © 2019 miguelalc. All rights reserved.
//

import UIKit

//class MainTabBarViewController: UIViewController {
//
//    private lazy var _viewControllersList = [ViewController(), SecondViewController()]
//    private var lndTabBar: LNDTabBar!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//        setupTabBar()
//    }
//
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        let vc = LNDCoachmarkHandlerViewController()
//        vc.showCoachmark(for: lndTabBar.getTabItems())
//        present(vc, animated: true, completion: nil)
//    }
//
//    private func setupTabBar() {
//        let tabBar = LNDTabBar()
//        view.addSubview(tabBar)
//        tabBar.translatesAutoresizingMaskIntoConstraints = false
//        tabBar.bottomAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.bottomAnchor, multiplier: 1).isActive = true
//        tabBar.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 1).isActive = true
//        tabBar.heightAnchor.constraint(equalToConstant: 60).isActive = true
//        tabBar.setTabItems(with: _viewControllersList.compactMap { $0.lndTabItem })
//
//        lndTabBar = tabBar
//    }
//}

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let viewController1 = ViewController.init()
        viewController1.tabBarItem = UITabBarItem(tabBarSystemItem: .mostRecent, tag: 1)
        let viewController2 = SecondViewController.init()
        viewController2.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 2)
        
        setViewControllers([viewController1, viewController2], animated: true)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let vc = LNDCoachmarkHandlerViewController()
        var views = [UIView]()
        let view1 = UIView(frame: CGRect.init(x: 50, y: 300, width: 50, height: 50))
        view1.layer.cornerRadius = 5
        views.append(view1)
        let view2 = UIView(frame: CGRect.init(x: 250, y: 350, width: 50, height: 50))
        view2.layer.cornerRadius = 25
        views.append(view2)
        vc.modalPresentationStyle = .overFullScreen
        vc.showCoachmark(for: views)
        present(vc, animated: true, completion: nil)
    }
    
}
