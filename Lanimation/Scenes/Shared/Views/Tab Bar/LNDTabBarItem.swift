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

protocol LNDTabBarItemDelegate: class {
    func didTapButton(with tag: Int)
}

// MARK: Tab Bar Item implementation

class LNDTabBarItem: UIControl, LNDTabBarItemProtocol  {
    
    // MARK: Properties
    
    weak var delegate: LNDTabBarItemDelegate?
    
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
    
    var contentView: UIView {
        let view = _contentContainerView
        view.layer.cornerRadius = _buttonLabel == nil ? min(_buttonImageView.bounds.width, _buttonImageView.bounds.height) / 2 : 10
        return view
    }
    
    // MARK: Subviews
    
    private lazy var _contentContainerView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = _buttonLabel == nil ? _buttonImageView.bounds.width / 2 : 10
        return view
    }()
    
    // MARK: Initializers
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    init(image: UIImage, text: String?) {
        super.init(frame: .zero)
        _image = image
        _text = text
        setupView()
    }
    
    // MARK: Functions
    
    // MARK: Private functions
    
    private func setupView() {
        setupContentView()
        setupContainerStackView()
        
        addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    private func setupContentView() {
        addSubview(_contentContainerView)
        
        _contentContainerView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        _contentContainerView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        _contentContainerView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: _buttonLabel == nil ? 1 : 0.8).isActive = true
        _contentContainerView.widthAnchor.constraint(equalTo: heightAnchor).isActive = true
    }
    
    private func setupContainerStackView() {
        let stackView = UIStackView(arrangedSubviews: _containerViews)
        
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        
        _contentContainerView.addSubview(stackView)
        stackView.anchorToSuperview()
        stackView.centerYAnchor.constraint(equalTo: _contentContainerView.centerYAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: _contentContainerView.centerXAnchor).isActive = true
        stackView.heightAnchor.constraint(equalTo: _contentContainerView.heightAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: _contentContainerView.widthAnchor).isActive = true
        
    }
    
    private func createButtonImageView() -> UIImageView {
        let imageView = UIImageView(image: _image)
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }
    
    private func createButtonLabel(with text: String?) -> UILabel {
        let label = UILabel(frame: .zero)
        label.text = text
        label.textAlignment = .center
        
        return label
    }
    
    @objc
    private func didTapButton() {
        delegate?.didTapButton(with: tag)
    }

}
