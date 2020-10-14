//
//  ButtonGroup.swift
//  RfWK
//
//  Created by Florian Nöhring on 21.09.20.
//  Copyright © 2020 Florian Nöhring. All rights reserved.
//

import UIKit

class ButtonGroup: UIView {

    static let cornerRadius = CGFloat(12.0)
    
    var title: String?
    var buttons: [Button] = []
    
    required init(title: String?, buttons: [Button] = []) {
        self.title = title
        self.buttons = buttons
        super.init(frame: .null)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        self.addSubview(buttonArea)
        
        if title != nil {
            self.addSubview(titleLabel)
            titleLabel.text = title
            
            self.addConstraints([
                titleLabel.topAnchor.constraint(equalTo: self.topAnchor),
                titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: ButtonGroup.cornerRadius),
                titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                buttonArea.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            ])
        }
        
        buttonArea.addSubview(scrollView)
        scrollView.addSubview(scrollContentView)
        scrollContentView.addSubview(stackView)
        
        let sameHeightConstraint = scrollView.heightAnchor.constraint(equalTo: scrollContentView.heightAnchor)
        let sameWidthConstraint = scrollView.widthAnchor.constraint(equalTo: scrollContentView.widthAnchor)
        sameWidthConstraint.priority = UILayoutPriority(rawValue: 250)

        for button in buttons {
            stackView.addArrangedSubview(button)
        }
        
        self.addConstraints([
            buttonArea.topAnchor.constraint(greaterThanOrEqualTo: self.topAnchor),
            buttonArea.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            buttonArea.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            buttonArea.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            scrollView.topAnchor.constraint(equalTo: buttonArea.topAnchor, constant: ButtonGroup.cornerRadius/2),
            scrollView.leadingAnchor.constraint(equalTo: buttonArea.leadingAnchor, constant: ButtonGroup.cornerRadius/2),
            scrollView.trailingAnchor.constraint(equalTo: buttonArea.trailingAnchor, constant: -ButtonGroup.cornerRadius/2),
            scrollView.bottomAnchor.constraint(equalTo: buttonArea.bottomAnchor, constant: -ButtonGroup.cornerRadius/2),
            
            scrollContentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            scrollContentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            scrollContentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            scrollContentView.trailingAnchor.constraint(lessThanOrEqualTo: scrollView.trailingAnchor),
            
            stackView.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor),
            stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            
            sameHeightConstraint,
            sameWidthConstraint,
        ])
    }
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(named: "UI.Text.Gray")
        label.font = UIFont.systemFont(ofSize: 16)
        
        return label
    }()
    
    var buttonArea: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "UI.ButtonGroup.Background")
        view.layer.cornerRadius = ButtonGroup.cornerRadius
        view.clipsToBounds = true
        
        return view
    }()
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    
    var scrollContentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var stackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.spacing = 10
        
        return view
    }()
}
