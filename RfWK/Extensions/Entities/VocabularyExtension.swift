//
//  VocabularyExtension.swift
//  RfWK
//
//  Created by Florian Nöhring on 01.06.20.
//  Copyright © 2020 Florian Nöhring. All rights reserved.
//

import Foundation
import CoreData

extension Vocabulary {
    
    func associatedReadings() throws -> [Reading] {
        let context = self.managedObjectContext!
        
        let fetchVocabularyReadingIDs = NSFetchRequest<NSManagedObjectID>(entityName: "VocabularyReading")
        fetchVocabularyReadingIDs.resultType = .managedObjectIDResultType
        fetchVocabularyReadingIDs.predicate = NSPredicate.init(format: "self.vocabulary = %@", self)
        let vocabularyReadingIDs: [NSManagedObjectID] = try context.fetch(fetchVocabularyReadingIDs)
        
        let fetchReadings = NSFetchRequest<Reading>(entityName: "Reading")
        fetchReadings.predicate = NSPredicate.init(format: "ANY vocabularyReadings in %@", vocabularyReadingIDs)

        do {
            let readings = try context.fetch(fetchReadings)
            return readings
        } catch {
            throw error
        }
    }
}
