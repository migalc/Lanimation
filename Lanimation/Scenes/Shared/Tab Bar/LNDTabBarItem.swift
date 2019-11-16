//
//  LNDTabBarItem.swift
//  Lanimation
//
//  Created by Miguel Alcantara on 16/11/2019.
//  Copyright © 2019 miguelalc. All rights reserved.
//

import UIKit

// MARK: Protocols

protocol LNDTabBarItemProtocol {
    
}

// MARK: Tab Bar Item implementation

class LNDTabBarItem: UIControl, LNDTabBarItemProtocol  {
    
    // MARK: Properties
    
    private var _image: UIImage = UIImage()
    private var _text: String?
    
    private lazy var _buttonImageView: UIImageView = createButtonImageView()
    private lazy var _buttonLabel: UILabel? = {
        guard let text = _text else { return nil }
        return createButtonLabel(with: text)
    }()
    
    private var _containerViews: [UIView] {
        var viewList: [UIView] = [_buttonImageView]
        if let label = _buttonLabel { viewList.append(label) }
        return viewList
    }
    
    // MARK: Subviews
    
    // MARK: Initializers
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    convenience init(image: UIImage, text: String?) {
        self.init(frame: .zero)
        _image = image
        _text = text
        setupView()
    }
    
    // MARK: Functions
    
    // MARK: Private functions
    
    private func setupView() {
        setupContainerStackView()
    }
    
    private func setupContainerStackView() {
        let stackView = UIStackView(arrangedSubviews: _containerViews)
        
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        
        addSubview(stackView)
        stackView.anchorToSuperview()
    }
    
    private func createButtonImageView() -> UIImageView {
        let imageView = UIImageView(image: _image)
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }
    
    private func createButtonLabel(with text: String?) -> UILabel {
        let label = UILabel(frame: .zero)
        label.text = text
        
        return label
    }

}
