//
//  MainTabBarViewController.swift
//  Lanimation
//
//  Created by Miguel Alcantara on 16/11/2019.
//  Copyright © 2019 miguelalc. All rights reserved.
//

import UIKit

class MainTabBarViewController: UIViewController {

    private lazy var _viewControllersList: [LNDBaseViewController] = {
        var list = [LNDBaseViewController]()
        
        (0..<5).forEach { index in
            let vc = ViewController()
            vc.vcId = index == 2 ? -1 : index
            vc.delegate = self
            list.append(vc)
        }
        
        return list
    }()
    
    private lazy var lndTabBar: LNDTabBar! = {
        let tabBar = LNDTabBar()
        
        tabBar.setTabItems(for: _viewControllersList)
        
        return tabBar
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupVC()
        setupTabBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showCoachmarks()
        lndTabBar.updateConstraints()
    }
    
    private func setupTabBar() {
        guard let tabBar = lndTabBar else { return }
        view.addSubview(tabBar)
        tabBar.translatesAutoresizingMaskIntoConstraints = false
        tabBar.bottomAnchor.constraint(equalToSystemSpacingBelow: view.bottomAnchor, multiplier: 1).isActive = true
        tabBar.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        tabBar.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
        tabBar.heightAnchor.constraint(greaterThanOrEqualToConstant: 95).isActive = true
    }
    
    private func setupVC() {
        guard let firstVC = _viewControllersList.first else { return }
        firstVC.showIn(parentVC: self)
    }
}

extension MainTabBarViewController: VCDelegate {
    
    func showCoachmarks() {
        let vc = LNDCoachmarkHandlerViewController()
        vc.modalPresentationStyle = .custom
        vc.delegate = self
        vc.transitioningDelegate = self
        let items = lndTabBar.getTabItems()
            .enumerated()
            .map { LNDCoachmarkHandlerViewItemViewModel(view: $0.element, title: "Title \($0.offset)", description: "Description \($0.offset)")}
        vc.setViewModel(for: LNDCoachmarkHandlerViewViewModel(views: items))
        present(vc, animated: true, completion: nil)
    }
    
}

extension MainTabBarViewController: UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return CoachmarkCustomPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
}

extension MainTabBarViewController: LNDCoachmarkHandlerViewDelegate {
    func didEndAnimation(for view: UIView) {
        view.animateColor(color: UIColor.white.withAlphaComponent(0.5))
    }
}
