//
//  BrowseVocabViewController.swift
//  RfWK
//
//  Created by Florian Nöhring on 08.05.20.
//  Copyright © 2020 Florian Nöhring. All rights reserved.
//

import UIKit

class BrowseVocabViewController: UIViewController {

    var vocabHandler: SubjectHandler<Vocabulary> = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let result = SubjectHandler<Vocabulary>(context: context)!
        return result
    }()
    
    var vocabulary: [Vocabulary] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        navigationItem.backButtonTitle = "Vocabulary"

        do {
            vocabulary = try vocabHandler.all(sortDescriptors: [
                NSSortDescriptor(key: "level", ascending: true),
                NSSortDescriptor(key: "id", ascending: true)
            ])
        } catch {
            print("Error during fetch Vocabulary: \(error.localizedDescription)")
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewcontroller = segue.destination as? ShowVocabViewController,
            let cell = sender as? BrowseKanjiTableViewCell,
            let indexPath = tableView.indexPath(for: cell) {
            
            viewcontroller.vocabulary = vocabulary[indexPath.row]
        }
    }
}

extension BrowseVocabViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vocabulary.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VocabularyCell", for: indexPath) as! BrowseKanjiTableViewCell
        
        let vocab = vocabulary[indexPath.row]
        let translations: [String] = vocab.subjectTranslations!.allObjects.map { ($0 as! SubjectTranslation).translation!.meaning! }
        
        cell.characters.text = vocab.characters
        cell.level.text = String(vocab.level)
        cell.meanings.text = translations.joined(separator: ", ")
        
        let vocabularyReadings = vocab.readings!.allObjects as! [VocabularyReading]
        let readings: [Reading] = vocabularyReadings.map { $0.reading! }
        
        cell.readings.text = readings.map { $0.reading! }.joined(separator: ", ")
        
        return cell
    }
}

