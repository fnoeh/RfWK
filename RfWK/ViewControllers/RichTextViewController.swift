//
//  RichTextViewController.swift
//  RfWK
//
//  Created by Florian Nöhring on 02.10.20.
//  Copyright © 2020 Florian Nöhring. All rights reserved.
//

import UIKit

class RichTextViewController: UIViewController {

    var url: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupContent()
    }
    
    private func setupViews() {
        self.view.addSubview(closeButton)
        self.view.addSubview(textView)
        
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            closeButton.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor),
            
            textView.topAnchor.constraint(equalTo: closeButton.bottomAnchor),
            textView.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor),
            textView.leadingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor),
        ])
    }
    
    private func setupContent() {
        if let rtf = self.url {
            do {
                let attributedStringWithRTF: NSAttributedString = try NSAttributedString(url: rtf, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.rtf], documentAttributes: nil)

                textView.attributedText = attributedStringWithRTF
                textView.textColor = UIColor(named: "UI.Text")
            } catch let error {
                print("Error during load rtf: \(error.localizedDescription)")
                textView.text = error.localizedDescription
            }
        } else {
            textView.text = "No text to present"
        }
    }
    
    let closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Close", for: .normal)
        button.addTarget(self, action: #selector(close(sender:)), for: .touchUpInside)
        button.setTitleColor(UIColor(named: "ColoredLink"), for: .normal)
        return button
    }()
    
    @IBAction func close(sender: Any?) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    var textView: UITextView = {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isEditable = false
        return view
    }()
}
