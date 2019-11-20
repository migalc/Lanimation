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
            var imageName = getIconName(for: 2)
            if vcId >= 0 {
                title = "View \(vcId+1)"
                imageName = getIconName(for: vcId)
            }
            
            var image: UIImage!
            if #available(iOS 13.0, *) {
                image = UIImage(systemName: imageName)!
            } else {
                image = UIImage(named: imageName)!
            }
            setTabItem(with: image, text: title)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupView()
        
    }
    
    func getIconName(for index: Int) -> String {
        var list = [String]()
        if #available(iOS 13.0, *) {
            list = ["pencil", "square.and.pencil", "airplayaudio", "arkit", "safari"]
        } else {
            list = ["Legend", "Legend", "Legend", "Legend", "Legend"]
        }
        
        return list[index]
    }
    
    private func setupView() {
        view.backgroundColor = .gray
        let button = UIButton(type: .roundedRect)
        button.setTitle("Show coachmarks", for: .init())
        button.addTarget(self, action: #selector(showCoachmarks), for: .touchUpInside)
        view.addSubview(button)
        button.anchorToSuperview()
    }
    
    @objc
    func showCoachmarks() {
        delegate?.showCoachmarks()
    }

}

