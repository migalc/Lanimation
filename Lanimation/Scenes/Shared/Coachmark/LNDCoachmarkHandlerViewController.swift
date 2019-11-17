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
    func setViewModel(for viewModel: LNDCoachmarkHandlerViewViewModel)
}

// MARK: - Coachmark View Implementation

class LNDCoachmarkHandlerViewController: LNDBaseViewController, LNDCoachmarkHandlerView {
    
    // MARK: - Properties
    
    private lazy var _viewModel: LNDCoachmarkHandlerViewViewModel! = LNDCoachmarkHandlerViewViewModel(views: [])
    private var _currentIndex: Int = -1
    private var _animationDuration: Double = 1
    private var _previousView: UIView {
        return _views[max(0, _currentIndex)]
    }
    private var _nextView: UIView {
        return _views[min(_views.count-1, _currentIndex)]
    }
    
    private var _currentTitleTag: Int {
        return max(0, _currentIndex) + 1
    }
    
    private var _currentDescriptionTag: Int {
        return (max(0, _currentIndex) + 1) * 1000
    }
    
    private lazy var _centerYLabelConstraints: [NSLayoutConstraint] = []
    private lazy var _centerXLabelConstraints: [NSLayoutConstraint] = []
    private lazy var _nextLabelsCenterXLabelConstraints: [NSLayoutConstraint] = []
    
    // MARK: - Subviews
    
    private var _views: [UIView] {
        return _viewModel.views.map { $0.view }
    }
    
    private lazy var _layerView: LNDCoachmarkOverlayView! = {
        return createLayerView() as! LNDCoachmarkOverlayView
    }()
    
    private lazy var _layerContainerView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        return view
    }()
    
    private var _lblCurrentTitle: UILabel!
    private var _lblCurrentDescription: UILabel!
    private var _lblNextTitle: UILabel!
    private var _lblNextDescription: UILabel!
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        view.backgroundColor = .clear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        _lblCurrentTitle.text = _viewModel.views.first?.title
        _lblCurrentDescription.text = _viewModel.views.first?.description
        animateInitialLabels()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        moveToNext()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        view.layoutIfNeeded()
    }
    
    // MARK: - Protocol functions
    
    func setViewModel(for viewModel: LNDCoachmarkHandlerViewViewModel) {
        _viewModel = viewModel
    }
    
    // MARK: - Private helper functions
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        moveToNext()
    }
    
    private func setupViews() {
        setupContainerView()
        setupLayerView()
        setupInitialLabels()
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
    
    private func setupInitialLabels() {
        _lblCurrentTitle = addTitleLabel(with: 0, title: "")
        _lblCurrentDescription = addDescriptionLabel(with: 0, description: "")
        _lblCurrentTitle.alpha = 0
        _lblCurrentDescription.alpha = 0
        
        _centerXLabelConstraints = _nextLabelsCenterXLabelConstraints
    }
    
    private func createLayerView() -> UIView {
        return LNDCoachmarkOverlayView(color: UIColor.blue, animationTotal: _animationDuration)
    }
    
    private func addNextLabels() {
        _lblNextTitle = addTitleLabel(with: _layerView.bounds.width, title: _viewModel.views[_currentIndex].title)
        _lblNextDescription = addDescriptionLabel(with: _layerView.bounds.width, topOffset: 10, description: _viewModel.views[_currentIndex].description)
        view.layoutIfNeeded()
    }
    
    @discardableResult
    private func addTitleLabel(with widthOffset: CGFloat = 0, heightOffset: CGFloat = 0, title: String) -> LNDLabel {
        let label = LNDLabel(text: title, tag: _currentTitleTag)
        _layerView.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        let anchorY = label.centerYAnchor.constraint(equalTo: _layerView.centerYAnchor, constant: heightOffset)
        _centerYLabelConstraints.append(anchorY)
        
        let anchorX = label.centerXAnchor.constraint(equalTo: _layerView.centerXAnchor, constant: widthOffset)
        _nextLabelsCenterXLabelConstraints.append(anchorX)
        
        NSLayoutConstraint.activate([anchorX, anchorY])
        
        return label
    }
    
    @discardableResult
    private func addDescriptionLabel(with widthOffset: CGFloat, topOffset: CGFloat = 0, description: String) -> LNDLabel {
        
        let label = LNDLabel(text: description, tag: _currentDescriptionTag)
        _layerView.addSubview(label)
        
        let titleLabel = _layerView.subviews.first(where: { $0.tag == _currentTitleTag })!
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: topOffset).isActive = true
        
        let anchorX = label.centerXAnchor.constraint(equalTo: _layerView.centerXAnchor, constant: widthOffset)
        anchorX.isActive = true
        
        _nextLabelsCenterXLabelConstraints.append(anchorX)
        return label
    }
    
    private func moveToNext() {
        _currentIndex += 1
        guard _currentIndex < _views.count else {
            dismiss(animated: true) {
                print("completed")
            }
            return
        }
        animateToNextView()
        animateLabels()
    }
    
}

// MARK: Animation Functions

private extension LNDCoachmarkHandlerViewController {
    
    private func animateInitialLabels() {
        UIView.animate(withDuration: _animationDuration / 2) {
            self._lblCurrentTitle.alpha = 1
        }

        UIView.animate(withDuration: _animationDuration / 2, delay: _animationDuration / 5, options: [], animations: {
            self._lblCurrentDescription.alpha = 1
        }, completion: nil)
        return
    }
    
    private func animateToNextView() {
        _layerView.moveTo(rect: _nextView.convert(_nextView.bounds, to: _layerView),
                          radius: _nextView.layer.cornerRadius)
    }
    
    private func animateLabels() {
        guard _currentIndex > 0 else { return }
        addNextLabels()
        
        animateConstraints(for: _lblCurrentTitle, nextLabel: _lblNextTitle, completion: nil)
        animateConstraints(for: _lblCurrentDescription, nextLabel: _lblNextDescription, delay: _animationDuration / 4, completion: nil)
        
        self._lblCurrentTitle = self._lblNextTitle
        self._lblCurrentDescription = self._lblNextDescription
        self._centerXLabelConstraints = self._nextLabelsCenterXLabelConstraints
    }
    
    private func animateConstraints(for currentLabel: UILabel, nextLabel: UILabel, delay: TimeInterval = 0, completion: ((Bool) -> Void)?) {
        let labelConstraints = _centerXLabelConstraints
        let nextLabelConstraints = _nextLabelsCenterXLabelConstraints
        
        _ = labelConstraints.filter { $0.firstAnchor == currentLabel.centerXAnchor }.map { constraint in constraint.constant -= _layerView.bounds.width }
        _ = nextLabelConstraints.filter { $0.firstAnchor == nextLabel.centerXAnchor }.map { constraint in constraint.constant = 0 }
        
        UIView.animate(withDuration: _animationDuration, delay: delay, options: [.curveEaseInOut], animations: {
            self.view.layoutIfNeeded()
        }, completion: completion)
    }
}
