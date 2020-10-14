//
//  UpdateActivityView.swift
//  RfWK
//
//  Created by Florian Nöhring on 06.06.20.
//  Copyright © 2020 Florian Nöhring. All rights reserved.
//

import UIKit

class UpdateActivityView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.translatesAutoresizingMaskIntoConstraints = false
        setupView()
    }

    func setupView() {
        self.layoutMargins = UIEdgeInsets(top: 15.0, left: 15.0, bottom: 15.0, right: 15.0)
        
        self.backgroundColor = .darkGray
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = true;

        self.addSubview(activityIndicator)
        self.addSubview(activityLabel)
        self.addSubview(progressView)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            activityIndicator.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor),
            
            activityLabel.topAnchor.constraint(equalToSystemSpacingBelow: activityIndicator.bottomAnchor, multiplier: 1.0),
            activityLabel.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),
            activityLabel.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor),
            
            progressView.topAnchor.constraint(equalToSystemSpacingBelow: activityLabel.bottomAnchor, multiplier: 1.0),
            progressView.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor),
            progressView.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor),
            
            progressView.widthAnchor.constraint(greaterThanOrEqualToConstant: 140)
        ])
    }
    
    let activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.hidesWhenStopped = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.color = .white
        view.startAnimating()
        return view
    }()
    
    let activityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    let progressView: UIProgressView = {
        let view = UIProgressView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.trackTintColor = .black
        view.progressTintColor = .white
        view.progressViewStyle = .default
        return view
    }()
}
