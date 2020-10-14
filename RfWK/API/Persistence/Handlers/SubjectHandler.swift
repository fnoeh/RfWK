//
//  SubjectHandler.swift
//  RfWK
//
//  Created by Florian Nöhring on 14.12.19.
//  Copyright © 2019 Florian Nöhring. All rights reserved.
//

import Foundation
import CoreData

class SubjectHandler<T: Subject> : Handler<T> {

    lazy var radicalEntity: NSEntityDescription = NSEntityDescription.entity(forEntityName: "Radical", in: context)!
    lazy var kanjiEntity: NSEntityDescription = NSEntityDescription.entity(forEntityName: "Kanji", in: context)!
    lazy var vocabularyEntity: NSEntityDescription = NSEntityDescription.entity(forEntityName: "Vocabulary", in: context)!
    
    // TODO: extract into dedicated factory class
    func subject(from wkSubject: WKSubject) -> Subject {
        let result: Subject
        
        switch wkSubject.object {
        case "radical":
            result = Radical(entity: radicalEntity, insertInto: context)
        case "kanji":
            result = Kanji(entity: kanjiEntity, insertInto: context)
        case "vocabulary":
            result = Vocabulary(entity: vocabularyEntity, insertInto: context)
        default:
            fatalError("Unexpected type '\(wkSubject.object)' when parsing subject. Expected one of [radical, kanji, vocabulary].")
        }
        
        result.id = Int16(wkSubject.id)
        result.level = Int16(wkSubject.data.level)
        result.slug = wkSubject.data.slug
        result.document_url = URL(string: wkSubject.data.document_url)
        result.characters = wkSubject.data.characters
        result.meaning_mnemonic = wkSubject.data.meaning_mnemonic
        result.meaning_hint = wkSubject.data.meaning_hint
        result.reading_mnemonic = wkSubject.data.reading_mnemonic
        result.reading_hint = wkSubject.data.reading_hint
        
        return result
    }
    
    func allWithLevel(in range: PartialRangeFrom<Int>) throws -> [Subject] {
        let fetchRequest: NSFetchRequest<Subject> = Subject.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "self.level >= %d", range.lowerBound)
        
        do {
            return try self.context.fetch(fetchRequest)
        } catch let error as NSError  {
            print("Error in SubjectHandler.allWithLevel(in range) - \(error.localizedDescription)")
            throw error
        }
    }
}
