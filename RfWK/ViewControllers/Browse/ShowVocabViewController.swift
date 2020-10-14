//
//  ShowVocabViewController.swift
//  RfWK
//
//  Created by Florian Nöhring on 10.05.20.
//  Copyright © 2020 Florian Nöhring. All rights reserved.
//

import UIKit

class ShowVocabViewController: UIViewController {

    @IBOutlet weak var characters: UILabel!
    @IBOutlet weak var id: UILabel!
    @IBOutlet weak var level: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var vocabulary: Vocabulary!
    var tableContent = TableContent<Any>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard ( vocabulary != nil ) else { return }
    
        tableView.delegate = self
        tableView.dataSource = self
        
        prepareTableContent()
        
        characters.text = vocabulary.characters
        id.text = "ID \(vocabulary.id)"
        level.text = "Level \(vocabulary.level)"
        
        navigationItem.backButtonTitle = vocabulary.characters!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? InAppBrowserViewController {
            destination.url = vocabulary.document_url
        } else if let destination = segue.destination as? ShowReadingViewController,
            let vocabularyReading = sender as? VocabularyReading,
            let reading = vocabularyReading.reading {
            destination.reading = reading
        } else if let destination = segue.destination as? ShowTranslationViewController,
            let translation = sender as? Translation {
            destination.translation = translation
        }
    }

    private func prepareTableContent() {
        let readings = vocabulary.readings!.allObjects
        tableContent.content.append(SectionContent(title: "Readings", items: readings, segue: "toShowReadingSegue"))
        
        // TODO: find a better way than map
        let translations = vocabulary.subjectTranslations!.allObjects.map { ($0 as! SubjectTranslation).translation! } as [Translation]
        tableContent.content.append(SectionContent(title: "Meanings", items: translations, segue: "toShowTranslationSegue"))
    }
    
    @IBAction func home(sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}

extension ShowVocabViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let segue = tableContent.segueIdentifier(for: indexPath.section) {
            let selection = tableContent.item(at: indexPath)
            performSegue(withIdentifier: segue, sender: selection)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableContent.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableContent.content[section].title
    }
        
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return tableContent.numberOfRowsIn(section: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShowVocabTableCell", for: indexPath)
        let cellContent = tableContent.item(at: indexPath)
        
        if let reading = cellContent as? VocabularyReading {
            cell.textLabel!.font = Constants.font(font: .japaneseSerif, size: .japaneseTableContent)
            cell.textLabel!.text = reading.reading?.reading
        } else if let translation = cellContent as? Translation {
            cell.textLabel!.text = translation.meaning
        }
        
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}
