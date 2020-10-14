//
//  BrowseMeaningsViewController.swift
//  RfWK
//
//  Created by Florian Nöhring on 11.05.20.
//  Copyright © 2020 Florian Nöhring. All rights reserved.
//

import UIKit

class BrowseTranslationsViewController: UIViewController {

    var translationHandler: TranslationHandler<Translation> = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let result = TranslationHandler<Translation>(context: context)!
        return result
    }()
    
    @IBOutlet weak var tableView: UITableView!
    
    var translations: [Translation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationItem.backButtonTitle = "Meanings"

        do {
            translations = try translationHandler.all()
        } catch {
            print("Error during fetch translation: \(error.localizedDescription)")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewcontroller = segue.destination as? ShowTranslationViewController,
            let cell = sender as? UITableViewCell,
            let indexPath = tableView.indexPath(for: cell) {
            
            viewcontroller.translation = translations[indexPath.row]
        }
    }
}

extension BrowseTranslationsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return translations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TranslationCell", for: indexPath)
        
        let translation = translations[indexPath.row]
        cell.textLabel?.text = translation.meaning!
        
        return cell
    }
}

