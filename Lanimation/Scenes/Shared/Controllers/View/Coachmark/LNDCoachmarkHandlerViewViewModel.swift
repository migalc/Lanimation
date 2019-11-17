//
//  LNDCoachmarkHandlerViewViewModel.swift
//  Lanimation
//
//  Created by Miguel Alcantara on 17/11/2019.
//  Copyright © 2019 miguelalc. All rights reserved.
//

import UIKit

struct LNDCoachmarkHandlerViewViewModel {
    let views: [LNDCoachmarkHandlerViewItemViewModel]
}

struct LNDCoachmarkHandlerViewItemViewModel {
    let view: UIView
    let title: String
    let description: String
}
