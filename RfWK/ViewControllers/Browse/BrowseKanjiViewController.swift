//
//  BrowseKanjiViewController.swift
//  RfWK
//
//  Created by Florian Nöhring on 29.04.20.
//  Copyright © 2020 Florian Nöhring. All rights reserved.
//

import UIKit
import CoreData


class BrowseKanjiViewController: UIViewController {

    var kanjiHandler: SubjectHandler<Kanji> = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let result: SubjectHandler<Kanji> = SubjectHandler<Kanji>(context: context)!
        
        return result
    }()
    
    var kanjis: [Kanji] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        tableView.delegate = self
        tableView.dataSource = self

        do {
            kanjis = try kanjiHandler.all(sortDescriptors: [
                NSSortDescriptor(key: "level", ascending: true),
                NSSortDescriptor(key: "id", ascending: true)
            ])
        } catch {
            print("Error during fetchKanji: \(error.localizedDescription)")
        }
        
        navigationItem.backButtonTitle = "Kanji"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let showKanjiVC = segue.destination as? ShowKanjiViewController,
                let cell = sender as? BrowseKanjiTableViewCell,
                let indexPath = tableView.indexPath(for: cell) {
            
            showKanjiVC.kanji = kanjis[indexPath.row]
        }
    }
}


extension BrowseKanjiViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return kanjis.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "KanjiCell", for: indexPath) as! BrowseKanjiTableViewCell
        
        let kanji: Kanji = kanjis[indexPath.row]
        
        let listedTranslations = kanji.subjectTranslations!.allObjects.map { ($0 as! SubjectTranslation).translation!.meaning! }.joined(separator: ", ")
                
        let kanjiReadings: [KanjiReading] = kanji.readings!.allObjects as! [KanjiReading]
        let grouped: Dictionary<String,[KanjiReading]> = Dictionary(grouping: kanjiReadings, by: { $0.type! })
        
        let onAndKunReadings = ((grouped["onyomi"] ?? []) + (grouped["kunyomi"] ?? [])).map { $0.displayableReading() }
        
        cell.characters.text = kanji.characters
        cell.level.text = String(kanji.level)
        cell.meanings.text = listedTranslations
        cell.readings.text = onAndKunReadings.joined(separator: ", ")
        
        return cell
    }
}
