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
    
    private lazy var _highlightedViewLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillRule = .evenOdd
        layer.fillColor = view?.backgroundColor?.cgColor ?? UIColor.clear.cgColor
        layer.frame = .zero
        
        return layer
    }()
    
    private var _currentIndex: Int = -1
    private lazy var _views: [UIView] = {
        return [UIView]()
    }()
    
    private lazy var _layerView: LNDCoachmarkOverlayView! = {
        return createLayerView() as! LNDCoachmarkOverlayView
    }()
    
    private var _previousView: UIView {
        return _views[max(0, _currentIndex)]
    }
    private var _nextView: UIView {
        return _views[min(_views.count-1, _currentIndex)]
    }
    
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
        view.backgroundColor = UIColor.green.withAlphaComponent(0.2)
        setupLayerView()
    }
    
    private func setupLayerView() {
        view.addSubview(_layerView)
        _layerView.anchorToSuperview()
    }
    
    var transparentPath: CGPath?
    
    private func createLayerView() -> UIView {
        return LNDCoachmarkOverlayView(color: UIColor.green.withAlphaComponent(0.5), transparentViewSize: CGSize(width: 50, height: 50))
    }
    
    private func moveToNext() {
        _currentIndex += 1
        guard _currentIndex < _views.count else {
            _currentIndex = 0
            animateToNextView()
//            dismiss(animated: true) {
//                print("completed")
//            }
            return
        }
        animateToNextView()
    }
    
    private func animateToNextView() {
        _layerView.moveTo(rect: _nextView.frame, radius: _nextView.layer.cornerRadius)
    }
    
}
