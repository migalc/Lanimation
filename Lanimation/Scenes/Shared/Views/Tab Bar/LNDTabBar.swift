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
    func getTabItems() -> [UIView]
    func setTabItems(with views: [UIView])
}

protocol LNDTabBarDelegate: class {
    func didTapButton(with tag: Int)
}

// MARK: Tab Bar Implementation

class LNDTabBar: LNDBaseView {
    
    // MARK: Properties
    
    weak var delegate: LNDTabBarDelegate?
    private var _containerStackView: UIStackView!
    private lazy var _viewControllers: [LNDBaseViewController] = []
    private let _heightConstant: CGFloat = 60
    
    // MARK: Initializers
    
    override func layoutSubviews() {
        super.layoutSubviews()
        heightAnchor.constraint(equalToConstant: _heightConstant + safeAreaInsets.bottom).isActive = true
    }

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
    
    func setTabItems(for viewControllers: [LNDBaseViewController]) {
        _viewControllers = viewControllers
        setTabItems(with: viewControllers.map { $0.lndTabItem })
    }
    
    func getTabItems() -> [UIView] {
        return _containerStackView.arrangedSubviews
            .compactMap { ($0 as? LNDTabBarItem)?.contentView }
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
        stackView.distribution = .fillEqually
        
        addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: _heightConstant).isActive = true
        _containerStackView = stackView
    }
    
    private func setTabItems(with views: [LNDTabBarItem]) {
        _containerStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        views.forEach {
            $0.delegate = self
            _containerStackView.addArrangedSubview($0)
        }
    }
    
}

// MARK: Extensions

extension LNDTabBar: LNDTabBarItemDelegate {
    
    func didTapButton(with tag: Int) {
        delegate?.didTapButton(with: tag)
    }
    
}
