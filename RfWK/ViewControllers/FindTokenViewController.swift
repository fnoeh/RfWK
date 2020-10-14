//
//  FindTokenViewController.swift
//  RfWK
//
//  Created by Florian Nöhring on 01.09.19.
//  Copyright © 2019 Florian Nöhring. All rights reserved.
//

import UIKit

class FindTokenViewController: UIViewController {

    let imageMargin = CGFloat(20)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        scrollView.maximumZoomScale = 2.0
        
        setupViews()
    }
    
    func setupViews() {
        self.view.addSubview(scrollView)
        scrollView.addSubview(self.contentView)
        
        let contentHeightConstraint = contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        contentHeightConstraint.priority = UILayoutPriority(rawValue: 250.0)
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentHeightConstraint,
            
            stackView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
        ])
    }
    
    var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layoutMargins = UIEdgeInsets(top: 16, left: 12, bottom: 12, right: 12)
        return view
    }()
    
    lazy var stackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [
            makeTextView(text: "How to find your token", size: Constants.titleFontsize),
            makeTextView(text: "A WaniKani.com account is required to use RfWK."),
            makeTextView(text: "If you already have an account, visit WaniKani.com and sign in. Then click on your account icon in the top right and navigate to API Tokens."),
            makeImageView(image: #imageLiteral(resourceName: "WaniKani.com_API-Tokens.png")),
            makeTextView(text: "You will need a Personal Access Token used for version 2 of the WaniKani API."),
            makeTextView(text: "A Personal Access Token will look similar to this"),
            makeTextView(text: "dafc5f99-0587-4a32-92eb-2483a2334e23") { label in
                label.textAlignment = .center
                label.font = UIFont(name: "Menlo-Regular", size: Constants.smallFontsize)
                if #available(iOS 13, *) {
                    label.backgroundColor = .secondarySystemBackground
                } else {
                    label.backgroundColor = .lightGray
                }
            },
            makeTextView(text: "whereas an API Version 1 key does not contain any separators."),
            makeTextView(text: "If you do not have a Personal Access Token, you can create one with the Generate a new token button. Give it any token description, e. g. RfWK. No additional permissions are required."),
            makeImageView(image: #imageLiteral(resourceName: "PersonalAccessToken")),
            makeTextView(text: "Copy the token and paste it into RfWK.")
        ])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        
        view.spacing = 10.0
        return view
    }()
    
    private func makeImageView(image: UIImage) -> UIView {
        let wrapperView = UIView()
        wrapperView.translatesAutoresizingMaskIntoConstraints = false
        
        let imageView = UIImageView(image: image)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        wrapperView.addSubview(imageView)
        
        let aspectRatio = image.size.height / image.size.width
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: wrapperView.topAnchor, constant: imageMargin),
            imageView.bottomAnchor.constraint(equalTo: wrapperView.bottomAnchor, constant: -imageMargin),
            
            imageView.leadingAnchor.constraint(greaterThanOrEqualTo: wrapperView.leadingAnchor, constant: imageMargin),
            imageView.trailingAnchor.constraint(lessThanOrEqualTo: wrapperView.trailingAnchor, constant: -imageMargin),
            
            imageView.centerXAnchor.constraint(equalTo: wrapperView.centerXAnchor),
            
            // Display image at no more than half the size before zooming
            imageView.heightAnchor.constraint(lessThanOrEqualToConstant: image.size.height / 2.0 ),
            imageView.widthAnchor.constraint(lessThanOrEqualToConstant: image.size.width / 2.0 ),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: aspectRatio),
        ])
        
        return wrapperView
    }
    
    private func makeTextView(text: String, size: CGFloat = Constants.smallFontsize, closure: ((UILabel)->())? = nil) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = UIFont(name: "Palatino-Roman", size: size)
        
        closure?(label)
        
        return label
    }
}


extension FindTokenViewController : UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return contentView
    }
}
