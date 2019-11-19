//
//  LNDNavigationBar.swift
//  Lanimation
//
//  Created by Miguel Alcantara on 17/11/2019.
//  Copyright © 2019 miguelalc. All rights reserved.
//

import UIKit

// MARK: Protocols

protocol LNDNavigationBarDelegate: class {
    func tappedClose()
    func tappedNext()
}

protocol LNDNavigationBarProtocol {
    func setNextButtonTitle(with text: String)
    func enableRightButton(enable: Bool)
}


// MARK: LND Navigation Bar Implementation

class LNDNavigationBar: LNDBaseView, LNDNavigationBarProtocol {
    
    // MARK: Properties
    
    weak var delegate: LNDNavigationBarDelegate?
    
    // MARK: Subviews
    
    private lazy var _leftButton: UIButton = {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(tappedLeftButton), for: .touchUpInside)
        button.setTitle("Close", for: .init())
        button.tintColor = .white
        return button
    }()
    
    private lazy var _rightButton: UIButton = {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(tappedRightButton), for: .touchUpInside)
        button.titleLabel?.textColor = .white
        return button
    }()
    
    // MARK: Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    convenience init(rightButtonText: String) {
        self.init(frame: .zero)
        setNextButtonTitle(with: rightButtonText)
    }
    
    // MARK: Protocol functions
    
    func setNextButtonTitle(with text: String) {
        _rightButton.setTitle(text, for: .init())
    }
    
    func enableRightButton(enable: Bool) {
        _rightButton.isUserInteractionEnabled = enable
    }
    
    // MARK: Private helper functions
    
    private func setupViews() {
        setupLeftButton()
        setupRightButton()
    }
    
    private func setupLeftButton() {
        addSubview(_leftButton)
        
        _leftButton.translatesAutoresizingMaskIntoConstraints = false
        _leftButton.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: 20).isActive = true
        _leftButton.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor).isActive = true
        _leftButton.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.75).isActive = true
    }
    
    private func setupRightButton() {
        addSubview(_rightButton)
        
        _rightButton.translatesAutoresizingMaskIntoConstraints = false
        _rightButton.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: -20).isActive = true
        _rightButton.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor).isActive = true
        _rightButton.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.75).isActive = true
    }
        
    @objc
    private func tappedLeftButton() {
        delegate?.tappedClose()
    }
    
     @objc
     private func tappedRightButton() {
         delegate?.tappedNext()
     }

}
