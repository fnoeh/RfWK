//
//  BrowseKanjiTableViewCell.swift
//  RfWK
//
//  Created by Florian Nöhring on 30.04.20.
//  Copyright © 2020 Florian Nöhring. All rights reserved.
//

import UIKit

class BrowseKanjiTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupView() {
        contentView.addSubview(leftSide)
        leftSide.addSubview(characters)
        leftSide.addSubview(level)
        
        contentView.addSubview(rightSide)
        rightSide.addSubview(meanings)
        rightSide.addSubview(readings)
            
        NSLayoutConstraint.activate([
            leftSide.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            leftSide.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            leftSide.topAnchor.constraint(greaterThanOrEqualTo: contentView.layoutMarginsGuide.topAnchor),
            leftSide.bottomAnchor.constraint(lessThanOrEqualTo: contentView.layoutMarginsGuide.bottomAnchor),
            
            characters.leadingAnchor.constraint(equalTo: leftSide.leadingAnchor),
            characters.trailingAnchor.constraint(equalTo: leftSide.trailingAnchor),
            level.leadingAnchor.constraint(equalTo: leftSide.leadingAnchor),
            level.trailingAnchor.constraint(equalTo: leftSide.trailingAnchor),
            
            characters.topAnchor.constraint(equalTo: leftSide.topAnchor),
            level.bottomAnchor.constraint(equalTo: leftSide.bottomAnchor),
            level.topAnchor.constraint(equalToSystemSpacingBelow: characters.bottomAnchor, multiplier: 0.25),
            
            rightSide.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            rightSide.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            rightSide.topAnchor.constraint(greaterThanOrEqualTo: contentView.layoutMarginsGuide.topAnchor),
            rightSide.bottomAnchor.constraint(lessThanOrEqualTo: contentView.layoutMarginsGuide.bottomAnchor),
            
            rightSide.leadingAnchor.constraint(equalToSystemSpacingAfter: leftSide.trailingAnchor, multiplier: 1.0),
            
            meanings.leadingAnchor.constraint(equalTo: rightSide.leadingAnchor),
            meanings.trailingAnchor.constraint(equalTo: rightSide.trailingAnchor),
            readings.leadingAnchor.constraint(equalTo: rightSide.leadingAnchor),
            readings.trailingAnchor.constraint(equalTo: rightSide.trailingAnchor),
            
            meanings.topAnchor.constraint(equalTo: rightSide.topAnchor),
            readings.topAnchor.constraint(equalToSystemSpacingBelow: meanings.bottomAnchor, multiplier: 0.5),
            readings.bottomAnchor.constraint(lessThanOrEqualTo: rightSide.bottomAnchor),
            meanings.bottomAnchor.constraint(lessThanOrEqualTo: rightSide.bottomAnchor),
        ])
    }
    
    var leftSide: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 900), for: .horizontal)
        view.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return view
    }()
    
    var rightSide: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 200), for: .horizontal)
        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        view.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        return view
    }()
    
    var characters: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Constants.font(font: .japaneseSerif, size: .veryLarge)
        label.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 900), for: .horizontal)
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    var level: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Constants.font(font: .system, size: .tiny)
        label.textAlignment = .center
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.textColor = UIColor(named: "UI.Text.Deemphasized")
        return label
    }()
    
    var meanings: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Constants.font(font: .system, size: .large)
        label.numberOfLines = 0
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    var readings: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Constants.font(font: .japaneseSerif, size: .small)
        label.textColor = UIColor(named: "UI.Text.Deemphasized")
        label.numberOfLines = 0
        return label
    }()
}
