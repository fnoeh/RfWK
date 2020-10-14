//
//  SubjectReadingTableViewCell.swift
//  RfWK
//
//  Created by Florian Nöhring on 30.05.20.
//  Copyright © 2020 Florian Nöhring. All rights reserved.
//

import UIKit

class SubjectReadingTableViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    let readingLabelWrapper: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layoutMargins = UIEdgeInsets(top: 0.0, left: 8.0, bottom: 0.0, right: 8.0)
        return view
    }()
    
    let readingLabel: UILabel! = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        label.font = Constants.font(font: .japaneseSerif, size: .veryLarge)
        return label
    }()
    
    let readingTypeLabel: UILabel! = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemGray
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        return label
    }()
    
    let colorStripe: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let meaningLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        label.numberOfLines = 0
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        self.accessoryType = .disclosureIndicator
        
        contentView.addSubview(colorStripe)
        contentView.addSubview(readingLabelWrapper)
        readingLabelWrapper.addSubview(readingLabel)
        contentView.addSubview(meaningLabel)
        contentView.addSubview(readingTypeLabel)
        
        NSLayoutConstraint.activate([
            colorStripe.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            colorStripe.topAnchor.constraint(equalTo: contentView.topAnchor),
            colorStripe.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            colorStripe.widthAnchor.constraint(equalToConstant: Constants.colorStripeWidth),
            
            readingLabelWrapper.leadingAnchor.constraint(equalTo: colorStripe.trailingAnchor),
            readingLabelWrapper.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            readingLabelWrapper.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
            
            readingLabel.leadingAnchor.constraint(equalTo: readingLabelWrapper.layoutMarginsGuide.leadingAnchor),
            readingLabel.trailingAnchor.constraint(equalTo: readingLabelWrapper.layoutMarginsGuide.trailingAnchor),
            readingLabel.topAnchor.constraint(equalTo: readingLabelWrapper.layoutMarginsGuide.topAnchor),
            readingLabel.bottomAnchor.constraint(equalTo: readingLabelWrapper.layoutMarginsGuide.bottomAnchor),
            
            meaningLabel.leadingAnchor.constraint(equalTo: readingLabelWrapper.trailingAnchor),
            meaningLabel.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            meaningLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                        
            readingTypeLabel.leadingAnchor.constraint(equalTo: meaningLabel.leadingAnchor),
            readingTypeLabel.topAnchor.constraint(equalTo: meaningLabel.bottomAnchor),
            readingTypeLabel.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
        ])
    }
}
