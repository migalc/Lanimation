//
//  LNDCoachmarkHandlerViewViewModel.swift
//  Lanimation
//
//  Created by Miguel Alcantara on 17/11/2019.
//  Copyright © 2019 miguelalc. All rights reserved.
//

import UIKit

// MARK: Protocols

protocol LNDCoachmarkHandlerViewItemViewModelProtocol {
    
}

protocol LNDCoachmarkHandlerViewModelProtocol {
    var nextView: UIView { get }
    var previousView: UIView { get }
    var animationDuration: Double { get }
    var initialAnimationDuration: Double { get }
    var initialAnimationDelay: Double { get }
    var currentTitleTag: Int { get }
    var currentDescriptionTag: Int { get }
    var overlayColor: UIColor { get }
    var navigationBarRightButtonTitle: String { get }
    
    func isLastView() -> Bool
    func isAtStart() -> Bool
    func isAtEnd() -> Bool
    func incrementIndex(by value: Int)
    func getTitle() -> String
    func getDescription() -> String
}

extension LNDCoachmarkHandlerViewModelProtocol {
    func incrementIndex(by value: Int = 1) { return incrementIndex(by: value) }
}

// MARK: Coachmark Handler view models implementation

struct LNDCoachmarkHandlerViewItemViewModel: LNDCoachmarkHandlerViewItemViewModelProtocol {
    let view: UIView
    let title: String
    let description: String
}

class LNDCoachmarkHandlerViewViewModel: LNDCoachmarkHandlerViewModelProtocol {
    
    // MARK: Initializers
    
    init(views: [LNDCoachmarkHandlerViewItemViewModel]) {
        _items = views
    }
    
    // MARK: Private properties
    
    private let _items: [LNDCoachmarkHandlerViewItemViewModel]
    private var _currentIndex: Int = -1
    private var _animationDuration: Double = 1
    
    // MARK: Private computed properties
    
    private var _tabViews: [UIView] { return _items.map { $0.view } }
    private var _previousView: UIView { return _tabViews[max(0, _currentIndex)] }
    private var _nextView: UIView { return _tabViews[min(_tabViews.count-1, _currentIndex)] }
    private var _currentTitleTag: Int { return max(0, _currentIndex) + 1 }
    private var _currentDescriptionTag: Int { return (max(0, _currentIndex) + 1) * 1000 }
    
    // MARK: Protocol properties
    
    var overlayColor: UIColor { return Theme.Colors.legendBlue }
    var nextView: UIView { return _nextView }
    var previousView: UIView { return _previousView }
    var animationDuration: Double { return _animationDuration }
    var initialAnimationDuration: Double { return _animationDuration / 2 }
    var initialAnimationDelay: Double { return _animationDuration / 5 }
    var currentTitleTag: Int { return _currentTitleTag }
    var currentDescriptionTag: Int { return _currentDescriptionTag }
    var navigationBarRightButtonTitle: String { return isLastView() ? "Done" : "Next" }
    
    // MARK: Protocol functions
    func isLastView() -> Bool {
        return _currentIndex == _items.count - 1
    }
    
    func isAtStart() -> Bool {
        return _currentIndex == 0
    }

    func isAtEnd() -> Bool {
        return _currentIndex == _items.count
    }
    
    func incrementIndex(by value: Int) {
        _currentIndex += value
    }
    
    func getTitle() -> String {
        guard _currentIndex >= 0 else { return "" }
        return _items[_currentIndex].title
    }
    
    func getDescription() -> String {
        guard _currentIndex >= 0 else { return "" }
        return _items[_currentIndex].description
    }
    
}

