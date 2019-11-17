//
//  LNDCoachmarkHandlerViewController.swift
//  Lanimation
//
//  Created by Miguel Alcantara on 16/11/2019.
//  Copyright © 2019 miguelalc. All rights reserved.
//

import UIKit

// MARK: - Protocols

protocol LNDCoachmarkHandlerView {
    func showCoachmark(for views: [UIView])
}

// MARK: - Coachmark View Implementation

class LNDCoachmarkHandlerViewController: LNDBaseViewController, LNDCoachmarkHandlerView {
    
    // MARK: - Properties
    
    private var _currentIndex: Int = -1
    
    private var _previousView: UIView {
        return _views[max(0, _currentIndex)]
    }
    private var _nextView: UIView {
        return _views[min(_views.count-1, _currentIndex)]
    }
    
    // MARK: - Subviews
    
    private lazy var _views: [UIView] = {
        return [UIView]()
    }()
    
    private lazy var _layerView: LNDCoachmarkOverlayView! = {
        return createLayerView() as! LNDCoachmarkOverlayView
    }()
    
    private lazy var _layerContainerView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        return view
    }()
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        view.backgroundColor = .clear
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        moveToNext()
    }
    
    // MARK: - Protocol functions
    
    func showCoachmark(for views: [UIView]) {
        _views = views
    }
    
    // MARK: - Private helper functions
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        moveToNext()
    }
    
    private func setupViews() {
        setupContainerView()
        setupLayerView()
    }
    
    private func setupContainerView() {
        view.addSubview(_layerContainerView)
        _layerContainerView.translatesAutoresizingMaskIntoConstraints = false
        _layerContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        _layerContainerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        _layerContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        _layerContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5).isActive = true
        
        _layerContainerView.layer.cornerRadius = 25
    }
    
    private func setupLayerView() {
        _layerContainerView.addSubview(_layerView)
        _layerView.layer.cornerRadius = _layerContainerView.layer.cornerRadius
        _layerView.translatesAutoresizingMaskIntoConstraints = false
        _layerView.bottomAnchor.constraint(equalTo: _layerContainerView.bottomAnchor).isActive = true
        _layerView.widthAnchor.constraint(equalTo: _layerContainerView.widthAnchor).isActive = true
        _layerView.centerXAnchor.constraint(equalTo: _layerContainerView.centerXAnchor).isActive = true
        _layerView.centerYAnchor.constraint(equalTo: _layerContainerView.centerYAnchor).isActive = true
        
    }
    
    private func createLayerView() -> UIView {
        return LNDCoachmarkOverlayView(color: UIColor.blue.withAlphaComponent(0.9), transparentViewSize: .zero)
    }
    
    private func moveToNext() {
        _currentIndex += 1
        guard _currentIndex < _views.count else {
//            _currentIndex = 0
//            animateToNextView()
            dismiss(animated: true) {
                print("completed")
            }
            return
        }
        animateToNextView()
    }
    
    private func animateToNextView() {
        _layerView.moveTo(rect: _nextView.convert(_nextView.bounds, to: _layerView),
                          radius: _nextView.layer.cornerRadius)
    }
    
}
