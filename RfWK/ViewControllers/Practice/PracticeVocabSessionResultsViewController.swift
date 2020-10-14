//
//  PracticeVocabSessionResultsViewController.swift
//  RfWK
//
//  Created by Florian Nöhring on 13.06.20.
//  Copyright © 2020 Florian Nöhring. All rights reserved.
//

import UIKit

class PracticeVocabSessionResultsViewController: UIViewController {

    static let cellIdentifier = "PracticeVocabSessionResultCell"
    var practiceVocabSetupVC: UIViewController!
    var reviews: [TranslationReview] = []
    var correctCount: Int = 0
    var totalCount: Int = 0
    var correctPercentage: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        viewRespectsSystemMinimumLayoutMargins = false
        tableView.delegate = self
        tableView.dataSource = self
        
        setupViews()
        assignValues()
    }

    func setupViews() {
        self.view.addSubview(resultView)
        resultView.addSubview(correctCountView)
        resultView.addSubview(correctPercentageView)
        self.view.addSubview(tableView)
        self.view.addSubview(actionView)
        actionView.addSubview(newSessionActionView)
        actionView.addSubview(endActionView)
        
        NSLayoutConstraint.activate([
            resultView.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor),
            resultView.leadingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leadingAnchor),
            resultView.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor),
            
            correctCountView.leadingAnchor.constraint(equalTo: resultView.layoutMarginsGuide.leadingAnchor),
            correctCountView.trailingAnchor.constraint(equalTo: resultView.layoutMarginsGuide.trailingAnchor),
            correctCountView.topAnchor.constraint(equalTo: resultView.layoutMarginsGuide.topAnchor),
            
            correctPercentageView.leadingAnchor.constraint(equalTo: resultView.layoutMarginsGuide.leadingAnchor),
            correctPercentageView.trailingAnchor.constraint(equalTo: resultView.layoutMarginsGuide.trailingAnchor),
            correctPercentageView.topAnchor.constraint(equalToSystemSpacingBelow: correctCountView.bottomAnchor, multiplier: 1.0),
            correctPercentageView.bottomAnchor.constraint(equalTo: resultView.layoutMarginsGuide.bottomAnchor),
            
            tableView.leadingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: resultView.bottomAnchor),
            
            actionView.topAnchor.constraint(equalTo: tableView.bottomAnchor),
            actionView.leadingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leadingAnchor),
            actionView.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor),
            actionView.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor),
            
            endActionView.topAnchor.constraint(equalTo: actionView.layoutMarginsGuide.topAnchor),
            endActionView.bottomAnchor.constraint(equalTo: actionView.layoutMarginsGuide.bottomAnchor),
            endActionView.leadingAnchor.constraint(equalTo: actionView.layoutMarginsGuide.leadingAnchor),
            
            newSessionActionView.topAnchor.constraint(equalTo: actionView.layoutMarginsGuide.topAnchor),
            newSessionActionView.bottomAnchor.constraint(equalTo: actionView.layoutMarginsGuide.bottomAnchor),
            newSessionActionView.trailingAnchor.constraint(equalTo: actionView.layoutMarginsGuide.trailingAnchor),
        ])
    }
    
    func assignValues() {
        totalCount = reviews.count
        correctCount = reviews.filter({ (review) in return review.result! == .correct }).count
        correctPercentage = totalCount == 0 ? 0 : Int(correctCount * 100 / totalCount)
        
        self.correctCountView.text = "\(String(self.correctCount)) of \(String(self.totalCount)) correct"
        self.correctPercentageView.text = String(self.correctPercentage) + "%"
    }
    
    // MARK: - Views
    
    var resultView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layoutMargins = UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 8)
        return view
    }()
    
    var correctCountView: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()

    var correctPercentageView: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(PracticeVocabSessionResultTableViewCell.self, forCellReuseIdentifier: PracticeVocabSessionResultsViewController.cellIdentifier)
        return tableView
    }()
    
    var actionView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return view
    }()
    
    var newSessionActionView: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("New session", for: .normal)
        button.setTitleColor(button.tintColor, for: .normal)
        button.addTarget(self, action: #selector(newSessionAction(sender:)), for: .touchUpInside)
        return button
    }()

    var endActionView: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("End", for: .normal)
        button.setTitleColor(button.tintColor, for: .normal)
        button.addTarget(self, action: #selector(endAction(sender:)), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Actions
    
    @IBAction func newSessionAction(sender: Any?) {
        navigationController!.setNavigationBarHidden(false, animated: false)
        navigationController!.popToViewController(practiceVocabSetupVC, animated: true)
    }
    
    @IBAction func endAction(sender: Any?) {
        navigationController!.setNavigationBarHidden(false, animated: false)
        navigationController!.popToRootViewController(animated: true)
    }
}

extension PracticeVocabSessionResultsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PracticeVocabSessionResultsViewController.cellIdentifier, for: indexPath) as! PracticeVocabSessionResultTableViewCell
        cell.setReview(reviews[indexPath.row])
        return cell
    }
}
