//
//  MainViewController.swift
//  RfWK
//
//  Created by Florian Nöhring on 27.08.19.
//  Copyright © 2019 Florian Nöhring. All rights reserved.
//

import UIKit
import WebKit

class MainViewController: UIViewController {

    @IBOutlet weak var accountButton: UIBarButtonItem!
    
    var browseKanjiButton: Button!
    var browseVocabularyButton: Button!
    var browseMeaningsButton: Button!
    var practiceVocabularyButton: Button!
    var searchEverythingButton: Button!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        browseKanjiButton = makeButton(title: "Kanji", target: self, action: #selector(browseKanji(sender:)))
        browseVocabularyButton = makeButton(title: "Vocabulary", target: self, action: #selector(browseVocabulary(sender:)))
        browseMeaningsButton = makeButton(title: "Meanings", target: self, action: #selector(browseMeanings(sender:)))
        
        practiceVocabularyButton = makeButton(title: "Vocabulary", target: self, action: #selector(practiceVocabulary(sender:)))
        searchEverythingButton = makeButton(title: "Coming soon", target: self, action: nil)
        
        setupViews()
    }

    func setupViews() {
        navigationItem.title = "RfWK"
        navigationItem.backButtonTitle = "Home"
        self.view.backgroundColor = UIColor(named: "UI.Background")
        
        self.view.addSubview(stackView)
        self.view.addSubview(disclaimerLink)
        
        stackView.addArrangedSubview(signInPromptView)
        stackView.addArrangedSubview(
            ButtonGroup(title: "Browse", buttons: [browseKanjiButton, browseVocabularyButton, browseMeaningsButton])
        )
        stackView.addArrangedSubview(
            ButtonGroup(title: "Practice", buttons: [practiceVocabularyButton])
        )
//        stackView.addArrangedSubview(
//            ButtonGroup(title: "Search", buttons: [searchEverythingButton])
//        )
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor),
            
            disclaimerLink.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            disclaimerLink.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor),
        ])
    }
    
    private func makeButton(title: String, target: Any, action: Selector?, closure: ((_ : Button) -> ())? = nil) -> Button {
        let button = Button(title: title)
        if action != nil {
            button.addTarget(self, action: action!, for: .touchUpInside)
        }
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        
        button.setContentCompressionResistancePriority(UILayoutPriority.required, for: .horizontal)
        button.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .horizontal)
        
        button.addConstraints([
            button.widthAnchor.constraint(greaterThanOrEqualToConstant: 100),
            button.widthAnchor.constraint(lessThanOrEqualToConstant: 220),
            button.heightAnchor.constraint(equalToConstant: 26),
        ])
        
        closure?(button)
        
        return button
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (sender as? UIButton) == disclaimerLink {
            let viewController = segue.destination as! RichTextViewController
            viewController.url = Bundle.main.url(forResource: "Disclaimer", withExtension: "rtf")
        }
    }
    
    @IBAction func browseKanji(sender: Any?) {
        self.performSegue(withIdentifier: "browseKanji", sender: self)
    }
    
    @IBAction func browseVocabulary(sender: Any?) {
        self.performSegue(withIdentifier: "browseVocabulary", sender: self)
    }
    
    @IBAction func browseMeanings(sender: Any?) {
        self.performSegue(withIdentifier: "browseMeanings", sender: self)
    }
        
    @IBAction func practiceVocabulary(sender: Any?) {
        self.performSegue(withIdentifier: "practiceVocabulary", sender: self)
    }
    
    @IBAction func disclaimer(sender: Any?) {
        self.performSegue(withIdentifier: "disclaimer", sender: sender)
    }
    
    // MARK: - Views
    
    let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.translatesAutoresizingMaskIntoConstraints = false
        view.spacing = 8
        return view
    }()
    
    let signInPromptView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let arrow = UIImageView()
        arrow.translatesAutoresizingMaskIntoConstraints = false
        arrow.image = #imageLiteral(resourceName: "Arrow")
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Constants.font(font: .script, size: .standard)
        label.text = "Before you start, add your WaniKani account here."
        label.numberOfLines = 0
        label.textAlignment = .right
        label.textColor = UIColor(named: "UI.Text.Highlighted")
        
        view.addSubview(arrow)
        view.addSubview(label)
        
        view.addConstraints([
            arrow.widthAnchor.constraint(equalToConstant: 22),
            arrow.heightAnchor.constraint(lessThanOrEqualToConstant: 30),
            
            arrow.topAnchor.constraint(equalTo: view.topAnchor),
            arrow.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            label.topAnchor.constraint(equalTo: arrow.bottomAnchor),
            label.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            
            label.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor),
        ])
        
        return view
    }()
    
    let disclaimerLink: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Disclaimer / Contact", for: .normal)
        button.setTitleColor(UIColor(named: "ColoredLink"), for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.footnote)
        button.addTarget(self, action: #selector(disclaimer(sender:)), for: .touchUpInside)
        return button
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        if UserStore().retrieve() != nil {
            browseKanjiButton.isEnabled = true
            browseVocabularyButton.isEnabled = true
            browseMeaningsButton.isEnabled = true
            practiceVocabularyButton.isEnabled = true
            searchEverythingButton.isEnabled = false // coming soon
            accountButton.image = UIImage(named: "Person.filled")
            signInPromptView.isHidden = true
        } else {
            browseKanjiButton.isEnabled = false
            browseVocabularyButton.isEnabled = false
            browseMeaningsButton.isEnabled = false
            practiceVocabularyButton.isEnabled = false
            searchEverythingButton.isEnabled = false
            accountButton.image = UIImage(named: "Person.outline")
            signInPromptView.isHidden = false
        }
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

}

