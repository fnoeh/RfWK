//
//  ShowTranslationViewController.swift
//  RfWK
//
//  Created by Florian Nöhring on 12.05.20.
//  Copyright © 2020 Florian Nöhring. All rights reserved.
//

import UIKit

class ShowTranslationViewController: UIViewController {

    var translation: Translation!
    
    @IBOutlet weak var meaning: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var tableContent = TableContent<Any>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        meaning.text = translation.meaning
        prepareTableContent()
        
        
        navigationItem.backButtonTitle = translation.meaning!
    }
    
    private func prepareTableContent() {
        let kanjis: [Kanji] = translation.kanjiTranslations().map({ $0.subject as! Kanji })
        if kanjis.hasElements {
            tableContent.content.append(SectionContent(title: "Kanji", items: kanjis, segue: "toShowKanjiSegue"))
        }
        
        let vocabularies: [Vocabulary] = translation.vocabularyTranslations().map { $0.subject as! Vocabulary }
        if vocabularies.hasElements {
            tableContent.content.append(SectionContent(title: "Vocabulary", items: vocabularies, segue: "toShowVocabularySegue"))
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? ShowKanjiViewController,
            let kanji = sender as? Kanji {
            controller.kanji = kanji
        } else if let controller = segue.destination as? ShowVocabViewController,
            let vocabulary = sender as? Vocabulary {
            controller.vocabulary = vocabulary
        }
    }
    
    @IBAction func home(sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}

extension ShowTranslationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let segue = tableContent.segueIdentifier(for: indexPath.section) {
            let selection = tableContent.item(at: indexPath)
            performSegue(withIdentifier: segue, sender: selection)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let result = tableContent.numberOfSections()
        return result
    }
        
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableContent.content[section].title
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return tableContent.numberOfRowsIn(section: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubjectCell", for: indexPath)
        let subject  = tableContent.item(at: indexPath)
        
        cell.textLabel?.font = Constants.font(font: .japaneseSerif, size: .japaneseTableContent)
        cell.detailTextLabel!.font = Constants.font(font: .japaneseSerif, size: .standard)
        cell.detailTextLabel!.textColor = UIColor.systemGray
        
        if let kanji = subject as? Kanji {
            cell.textLabel?.text = kanji.characters
            cell.detailTextLabel?.text = readings(from: kanji).joined(separator: ", ")
        } else if let vocabulary = subject as? Vocabulary {
            cell.textLabel?.text = vocabulary.characters
            cell.detailTextLabel?.text = readings(from: vocabulary).joined(separator: ", ")
        }
        
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    private func readings(from kanji: Kanji) -> [String] {
        return kanji.readings!.allObjects.map { ($0 as! KanjiReading).displayableReading() }
    }
    
    private func readings(from vocabulary: Vocabulary) -> [String] {
        return vocabulary.readings!.allObjects.map { ($0 as! VocabularyReading).reading!.reading! }
    }
}
