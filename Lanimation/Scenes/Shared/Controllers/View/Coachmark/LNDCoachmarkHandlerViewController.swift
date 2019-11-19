//
//  LNDCoachmarkHandlerViewController.swift
//  Lanimation
//
//  Created by Miguel Alcantara on 16/11/2019.
//  Copyright © 2019 miguelalc. All rights reserved.
//

import UIKit

// MARK: - Protocols

protocol LNDCoachmarkHandlerViewDelegate: class {
    func willEndAnimation(for view: UIView)
}

protocol LNDCoachmarkHandlerView {
    func setViewModel(for viewModel: LNDCoachmarkHandlerViewViewModel)
}

// MARK: - Coachmark View Implementation

class LNDCoachmarkHandlerViewController: LNDBaseViewController, LNDCoachmarkHandlerView {
    
    // MARK: - Properties
    
    weak var delegate: LNDCoachmarkHandlerViewDelegate?
    
    private lazy var _viewModel: LNDCoachmarkHandlerViewViewModel! = LNDCoachmarkHandlerViewViewModel(views: [])
    
    private lazy var _centerYLabelConstraints: [NSLayoutConstraint] = []
    private lazy var _centerXLabelConstraints: [NSLayoutConstraint] = []
    private lazy var _nextLabelsCenterXLabelConstraints: [NSLayoutConstraint] = []
    
    // MARK: - Subviews
    
    private lazy var _navigationBar: LNDNavigationBar = {
        let navigationBar = LNDNavigationBar(rightButtonText: _viewModel.navigationBarRightButtonTitle)
        navigationBar.delegate = self
        return navigationBar
    }()
    
    private lazy var _layerView: LNDCoachmarkOverlayView! = {
        let layerView = createLayerView()
        layerView.delegate = self
        return layerView
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        moveToNext()
    }
    
    // MARK: - Protocol functions
    
    func setViewModel(for viewModel: LNDCoachmarkHandlerViewViewModel) {
        _viewModel = viewModel
    }
    
    // MARK: - Private helper functions
    
    private func setupViews() {
        setupContainerView()
        setupLayerView()
        setupInitialLabels()
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        view.addSubview(_navigationBar)
        _navigationBar.translatesAutoresizingMaskIntoConstraints = false
        _navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        _navigationBar.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
        _navigationBar.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        _navigationBar.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }
    
    private func setupContainerView() {
        view.addSubview(_layerContainerView)
        _layerContainerView.translatesAutoresizingMaskIntoConstraints = false
        _layerContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        _layerContainerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        _layerContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        _layerContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1).isActive = true
        
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
        _lblCurrentTitle.alpha = 0.5
        _lblCurrentDescription.alpha = 0
        
        _centerXLabelConstraints = _nextLabelsCenterXLabelConstraints
    }
    
    private func createLayerView() -> LNDCoachmarkOverlayView {
        return LNDCoachmarkOverlayView(color: _viewModel.overlayColor,
                                       animationTotal: _viewModel.animationDuration)
    }
    
    private func addNextLabels() {
        _lblNextTitle = addTitleLabel(with: _layerView.bounds.width,
                                      title: _viewModel.getTitle())
        
        _lblNextDescription = addDescriptionLabel(with: _layerView.bounds.width,
                                                  description: _viewModel.getDescription())
        
        view.layoutIfNeeded()
    }
    
    @discardableResult
    private func addTitleLabel(with widthOffset: CGFloat = 0, heightOffset: CGFloat = 10, title: String) -> LNDLabel {
        let label = LNDLabel(text: title, tag: _viewModel.currentTitleTag)
        _layerView.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        // MIGUEL: label.centerYAnchor.constraint(equalToSystemSpacingBelow: _layerView.centerYAnchor, multiplier: 0.75) is not working, why?
        let anchorY = NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: _layerView, attribute: .centerY, multiplier: 0.75, constant: 0)
        _centerYLabelConstraints.append(anchorY)
        
        let anchorX = label.centerXAnchor.constraint(equalTo: _layerView.centerXAnchor, constant: widthOffset)
        _nextLabelsCenterXLabelConstraints.append(anchorX)
        
        NSLayoutConstraint.activate([anchorX, anchorY])
        
        return label
    }
    
    @discardableResult
    private func addDescriptionLabel(with widthOffset: CGFloat, topOffset: CGFloat = 10, description: String) -> LNDLabel {
        
        let label = LNDLabel(text: description, tag: _viewModel.currentDescriptionTag)
        _layerView.addSubview(label)
        
        let titleLabel = _layerView.subviews.first(where: { $0.tag == _viewModel.currentTitleTag })!
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let topAnchor = label.topAnchor.constraint(greaterThanOrEqualTo: titleLabel.bottomAnchor, constant: 10)
        
        let anchorY = NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: _layerView, attribute: .centerY, multiplier: 1, constant: 0)
        anchorY.priority = .defaultHigh
        
        let anchorX = label.centerXAnchor.constraint(equalTo: _layerView.centerXAnchor, constant: widthOffset)
        anchorX.isActive = true
        
        _nextLabelsCenterXLabelConstraints.append(anchorX)
        
        NSLayoutConstraint.activate([anchorX, anchorY, topAnchor])
        
        return label
    }
    
    private func moveToNext() {
        _viewModel.incrementIndex()
        guard !_viewModel.isAtStart() else {
            return startCoachmarks()
        }
        guard !_viewModel.isAtEnd() else {
            return dismissView()
        }
        handleNavigationBar()
        animateToNextView()
        animateLabels()
    }
    
    private func handleNavigationBar() {
        guard _viewModel.isLastView() else { return }
        _navigationBar.setNextButtonTitle(with: _viewModel.navigationBarRightButtonTitle)
    }
    
    private func dismissView() {
        dismiss(animated: true, completion: nil)
    }
    
    private func startCoachmarks() {
        _lblCurrentTitle.text = _viewModel.getTitle()
        _lblCurrentDescription.text = _viewModel.getDescription()
        animateInitialLabels()
        handleNavigationBar()
        animateToNextView()
    }
    
}

// MARK: Animation Functions

private extension LNDCoachmarkHandlerViewController {
    
    private func animateInitialLabels() {
        UIView.animate(withDuration: _viewModel.initialAnimationDuration) {
            self._lblCurrentTitle.alpha = 1
        }

        UIView.animate(withDuration: _viewModel.initialAnimationDuration,
                       delay: _viewModel.initialAnimationDelay,
                       options: [],
                       animations: {
            self._lblCurrentDescription.alpha = 1
        }, completion: nil)
        return
    }
    
    private func animateToNextView() {
        _layerView.moveTo(rect: _viewModel.nextView.convert(_viewModel.nextView.bounds, to: _layerView),
                          radius: _viewModel.nextView.layer.cornerRadius)
    }
    
    private func animateLabels() {
        addNextLabels()
        
        animateConstraints(for: _lblCurrentTitle, nextLabel: _lblNextTitle, completion: { [weak self] _ in
            guard let self = self else { return }
            self._lblCurrentTitle.removeFromSuperview()
            self._lblCurrentTitle = self._lblNextTitle
        })
        
        animateConstraints(for: _lblCurrentDescription, nextLabel: _lblNextDescription, delay: _viewModel.animationDuration / 4, completion: { [weak self] _ in
            guard let self = self else { return }
            self._lblCurrentDescription.removeFromSuperview()
            self._lblCurrentDescription = self._lblNextDescription
        })
        
        self._centerXLabelConstraints = self._nextLabelsCenterXLabelConstraints
    }
    
    private func animateConstraints(for currentLabel: UILabel, nextLabel: UILabel, delay: TimeInterval = 0, completion: ((Bool) -> Void)?) {
        let labelConstraints = _centerXLabelConstraints
        let nextLabelConstraints = _nextLabelsCenterXLabelConstraints
        
        _ = labelConstraints.filter { $0.firstAnchor == currentLabel.centerXAnchor }.map { constraint in constraint.constant -= _layerView.bounds.width }
        _ = nextLabelConstraints.filter { $0.firstAnchor == nextLabel.centerXAnchor }.map { constraint in constraint.constant = 0 }
        
        UIView.animate(withDuration: _viewModel.animationDuration, delay: delay, options: [.curveEaseInOut], animations: {
            self.view.layoutIfNeeded()
        }, completion: completion)
    }
}

extension LNDCoachmarkHandlerViewController: LNDCoachmarkOverlayViewDelegate {
    func willEndAnimation() {
        delegate?.willEndAnimation(for: _viewModel.nextView)
    }
    
    func toggledUserInteraction(isEnabled: Bool) {
        _navigationBar.enableRightButton(enable: isEnabled)
    }
}

extension LNDCoachmarkHandlerViewController: LNDNavigationBarDelegate {
    
    func tappedNext() {
        moveToNext()
    }
    
    func tappedClose() {
        dismissView()
    }
    
}

