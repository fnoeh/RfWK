//
//  PracticeVocabSessionResultTableViewCell.swift
//  RfWK
//
//  Created by Florian Nöhring on 20.06.20.
//  Copyright © 2020 Florian Nöhring. All rights reserved.
//

import UIKit

class PracticeVocabSessionResultTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        contentView.addSubview(answerLabel)
        contentView.addSubview(meaningLabel)
        
        NSLayoutConstraint.activate([
            meaningLabel.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            meaningLabel.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
            meaningLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),

            answerLabel.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            answerLabel.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
            answerLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),

            answerLabel.widthAnchor.constraint(equalTo: meaningLabel.widthAnchor),
            answerLabel.leadingAnchor.constraint(equalTo: meaningLabel.trailingAnchor),
        ])
    }
    
    // MARK: - Views
    
    lazy var answerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .white
        label.font = Constants.font(font: .japaneseSerif, size: .japaneseTableContent)
        return label
    }()
    
    lazy var meaningLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.init(name: "ChalkboardSE-Light", size: 18.0)
        return label
    }()
    
    // MARK: -
    
    func setReview(_ review: TranslationReview) {
        answerLabel.text = review.givenAnswer
        meaningLabel.text = review.translation.meaning
        
        switch review.result! {
        	case .correct:
                contentView.backgroundColor = UIColor(named: "Review.Correct")
            case .skipped, .wrong:
                contentView.backgroundColor = UIColor(named: "Review.Wrong")
        }
    }
    
    // TODO: make table rows clickable to show vocabulary
}
