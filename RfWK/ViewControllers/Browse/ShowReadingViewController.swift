//
//  ShowReadingViewController.swift
//  RfWK
//
//  Created by Florian Nöhring on 17.05.20.
//  Copyright © 2020 Florian Nöhring. All rights reserved.
//

import UIKit

class ShowReadingViewController: UIViewController {

    var reading: Reading!
    var tableContent = TableContent<SubjectReading>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let kanjiReadings = reading.kanjiReadings!
        let vocabularyReadings = reading.vocabularyReadings!
        
        tableView.delegate = self
        tableView.dataSource = self
        
        prepareTableContent(kanjiReadings: kanjiReadings.allObjects as! [KanjiReading],
                            vocabularyReadings: vocabularyReadings.allObjects as! [VocabularyReading])
        
        navigationItem.backButtonTitle = reading.reading!

        buildView()
    }
    
    private func prepareTableContent(kanjiReadings: [KanjiReading], vocabularyReadings: [VocabularyReading]) {
        if kanjiReadings.hasElements {
            tableContent.content.append(SectionContent(title: "Kanji", items: kanjiReadings, segue: "toShowKanjiSegue"))
        }
        
        if vocabularyReadings.hasElements {
            tableContent.content.append(SectionContent(title: "Vocabulary", items: vocabularyReadings, segue: "toShowVocabularySegue"))
        }
    }
    
    let topSection: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layoutMargins = UIEdgeInsets(top: 4.0, left: 4.0, bottom: 4.0, right: 4.0)
        return view
    }()
    
    lazy var readingLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = Constants.font(font: .japaneseSerif, size: .largeTitle)
        view.text = reading.reading
        return view
    }()

    let tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.register(SubjectReadingTableViewCell.self, forCellReuseIdentifier: "SubjectReadingCell")
        return view
    }()
    
    let colorBanner: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "Banner.Reading")
        return view
    }()
    
    func buildView() {
        self.view.addSubview(colorBanner)
        self.view.addSubview(topSection)
        topSection.addSubview(readingLabel)
        self.view.addSubview(tableView)
        
        let safeArea = self.view.safeAreaLayoutGuide
            
        NSLayoutConstraint.activate([

            colorBanner.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            colorBanner.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            colorBanner.topAnchor.constraint(equalTo: safeArea.topAnchor),
            colorBanner.heightAnchor.constraint(equalToConstant: Constants.colorBannerWidth),
            
            topSection.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            topSection.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            topSection.topAnchor.constraint(equalTo: colorBanner.bottomAnchor),
            
            readingLabel.leadingAnchor.constraint(equalTo: topSection.layoutMarginsGuide.leadingAnchor),
            readingLabel.topAnchor.constraint(equalTo: topSection.layoutMarginsGuide.topAnchor),
            readingLabel.trailingAnchor.constraint(equalTo: topSection.layoutMarginsGuide.trailingAnchor),
            readingLabel.bottomAnchor.constraint(equalTo: topSection.layoutMarginsGuide.bottomAnchor),
            
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: topSection.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
        ])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? ShowKanjiViewController,
            let kanji = sender as? Kanji {
            destination.kanji = kanji
            
        } else if let destination = segue.destination as? ShowVocabViewController,
            let vocabulary = sender as? Vocabulary {
            destination.vocabulary = vocabulary
        }
    }
    
    @IBAction func home(sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}

extension ShowReadingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let segue = tableContent.segueIdentifier(for: indexPath.section) {
            if let kanjiReading = tableContent.item(at: indexPath) as? KanjiReading {
                performSegue(withIdentifier: segue, sender: kanjiReading.kanji!)
            } else if let vocabularyReading = tableContent.item(at: indexPath) as? VocabularyReading {
                performSegue(withIdentifier: segue, sender: vocabularyReading.vocabulary!)
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableContent.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableContent.content[section].title
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableContent.numberOfRowsIn(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubjectReadingCell", for: indexPath) as! SubjectReadingTableViewCell
        
        let subjectReading = tableContent.item(at: indexPath)
        if let kanjiReading = subjectReading as? KanjiReading {
            let kanji = kanjiReading.kanji!
            cell.readingLabel.text = kanji.characters
            cell.readingTypeLabel.text = kanjiReading.type
            cell.meaningLabel.text = kanji.meanings().joined(separator: ", ")
            cell.colorStripe.backgroundColor = UIColor(named: "Banner.Kanji")
        } else if let vocabularyReading = subjectReading as? VocabularyReading {
            let vocabulary = vocabularyReading.vocabulary!
            cell.readingLabel.text = vocabulary.characters
            cell.meaningLabel.text = vocabulary.slug
            cell.meaningLabel.text = vocabulary.meanings().joined(separator: ", ")
            cell.colorStripe.backgroundColor = UIColor(named: "Banner.Vocabulary")
        }
        
        return cell
    }
}
