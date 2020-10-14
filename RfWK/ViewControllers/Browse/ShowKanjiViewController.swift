//
//  ShowKanjiViewController.swift
//  RfWK
//
//  Created by Florian Nöhring on 01.05.20.
//  Copyright © 2020 Florian Nöhring. All rights reserved.
//

import UIKit

class ShowKanjiViewController: UIViewController {

    var kanji: Kanji!
    var readingsTableContent = TableContent<KanjiReading>()
    
    @IBOutlet weak var characters: UILabel!
    @IBOutlet weak var meaning: UILabel!
    @IBOutlet weak var id: UILabel!
    @IBOutlet weak var level: UILabel!
    
    @IBOutlet weak var readingsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        readingsTableView.delegate = self
        readingsTableView.dataSource = self
        
        prepareReadingsForTableContent()
        
        characters.text = kanji.characters
        meaning.text = kanji.subjectTranslations!.allObjects.map { ($0 as! SubjectTranslation).translation!.meaning! }.joined(separator: ", ")
        id.text = "ID \(kanji.id)"
        level.text = "Level \(kanji.level)"
        
        navigationItem.backButtonTitle = kanji.characters!
    }
    
    private func prepareReadingsForTableContent() {
        let readingsByType = kanji.readingsByType()
        
        if let onyomiReadings = readingsByType[KanjiReadingType.onyomi] {
            readingsTableContent.content.append(SectionContent(title: "On’yomi readings", items: onyomiReadings, segue: "toShowReadingSegue"))
        }
        
        if let kunyomiReadings = readingsByType[KanjiReadingType.kunyomi] {
            readingsTableContent.content.append(SectionContent(title: "Kun’yomi readings", items: kunyomiReadings, segue: "toShowReadingSegue"))
        }
        
        if let nanoriReadings = readingsByType[KanjiReadingType.nanori] {
            readingsTableContent.content.append(SectionContent(title: "Nanori readings", items: nanoriReadings, segue: "toShowReadingSegue"))
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? InAppBrowserViewController {
            destination.url = kanji?.document_url
        } else if let destination = segue.destination as? ShowReadingViewController {
            if let kanjiReading = sender as? KanjiReading,
                let reading = kanjiReading.reading {
                destination.reading = reading
            }
        }
    }
    
    @IBAction func home(sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}

extension ShowKanjiViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let segue = readingsTableContent.segueIdentifier(for: indexPath.section) {
            let selection = readingsTableContent.item(at: indexPath)
            performSegue(withIdentifier: segue, sender: selection)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return readingsTableContent.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return readingsTableContent.content[section].title
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return readingsTableContent.numberOfRowsIn(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReadingCell", for: indexPath)
        let kanjiReading = readingsTableContent.item(at: indexPath)
        cell.textLabel!.text = kanjiReading.displayableReading()
        cell.textLabel!.font = Constants.font(font: .japaneseSerif, size: .japaneseTableContent)
        return cell
    }
 }
