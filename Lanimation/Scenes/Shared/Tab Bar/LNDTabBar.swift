//
//  LNDTabBar.swift
//  Lanimation
//
//  Created by Miguel Alcantara on 16/11/2019.
//  Copyright © 2019 miguelalc. All rights reserved.
//

import UIKit

// MARK: Protocols

protocol LNDTabBarProtocol {
    func getTabItems() -> [LNDTabBarItem]
    func setTabItems(with views: [UIView])
}

// MARK: Tab Bar Implementation

class LNDTabBar: LNDBaseView {
    
    // MARK: Properties
    
    private var containerStackView: UIStackView!
    private var iconImage: [UIImage] = []
    
    // MARK: Initializers
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    init() {
        super.init(frame: .zero)
        setupViews()
    }
    
    // MARK: Protocol functions
    
    func setTabItems(with views: [LNDTabBarItem]) {
        views.forEach { containerStackView.addArrangedSubview($0) }
    }
    
    func getTabItems() -> [LNDTabBarItem] {
        return containerStackView.arrangedSubviews.compactMap { $0 as? LNDTabBarItem }
    }
    
    // MARK: Private functions
    
    private func setupViews() {
        backgroundColor = .darkGray
        
        setupContainerStackView()
    }
    
    private func setupContainerStackView() {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        
        addSubview(stackView)
        
        stackView.anchorToSuperview()
        
        containerStackView = stackView
    }
    
}
