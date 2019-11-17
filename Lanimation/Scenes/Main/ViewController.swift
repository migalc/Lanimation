//
//  ViewController.swift
//  Lanimation
//
//  Created by Miguel Alcantara on 16/11/2019.
//  Copyright © 2019 miguelalc. All rights reserved.
//

import UIKit

protocol VCDelegate: class {
    func showCoachmarks()
}

class ViewController: LNDBaseViewController {
    
    weak var delegate: VCDelegate?
    
    var vcId: Int = -1 {
        didSet {
            var image = iconsImageNameList[2]
            if vcId >= 0 {
                title = "View \(vcId+1)"
                image = iconsImageNameList[vcId]
            }
            
            setTabItem(with: UIImage(systemName: image)!, text: title)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupView()
        
    }
    
    private let iconsImageNameList: [String] = ["pencil", "square.and.pencil", "airplayaudio", "arkit", "safari"]
    
    private func setupView() {
        view.backgroundColor = .systemPurple
        let button = UIButton(frame: .zero)
        button.titleLabel?.text = "Show coachmarks"
        button.addTarget(self, action: #selector(showCoachmarks), for: .touchUpInside)
        view.addSubview(button)
        
        button.anchorToSuperview()
    }
    
    @objc
    func showCoachmarks() {
        delegate?.showCoachmarks()
    }

}

