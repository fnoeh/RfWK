//
//  Button.swift
//  RfWK
//
//  Created by Florian Nöhring on 20.09.20.
//  Copyright © 2020 Florian Nöhring. All rights reserved.
//

import UIKit

class Button: UIButton {

    let cornerRadius = CGFloat(6.0)

    required init(title: String) {
        super.init(frame: .null)
        self.setTitle(title, for: .normal)
        setColorsAndCorners()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setColorsAndCorners()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setColorsAndCorners()
    }

    func setColorsAndCorners() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
        self.backgroundColor = UIColor(named: "UI.Button.Normal")
    }
    
    override open var isHighlighted: Bool {
        didSet {
            backgroundColor = UIColor(named: isHighlighted ? "UI.Button.Active" : "UI.Button.Normal")
        }
    }

    override open var isEnabled: Bool {
        didSet {
            backgroundColor = UIColor(named: isEnabled ? "UI.Button.Normal" : "UI.Button.Disabled")
        }
    }
}
