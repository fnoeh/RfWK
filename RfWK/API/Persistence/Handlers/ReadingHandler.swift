//
//  ReadingHandler.swift
//  RfWK
//
//  Created by Florian Nöhring on 14.12.19.
//  Copyright © 2019 Florian Nöhring. All rights reserved.
//

import Foundation
import CoreData

class ReadingHandler<T: Reading> : Handler<T> {
    
    lazy var readingEntity = NSEntityDescription.entity(forEntityName: "Reading", in: self.context)!

    func reading(_ reading: String) -> Reading {
        let result = NSManagedObject.init(entity: readingEntity, insertInto: context) as! Reading
        result.reading = reading
        return result
    }
    
    func readingsWithoutSubjectReading() throws -> [Reading] {
        let fetchRequest: NSFetchRequest<Reading> = Reading.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "self.kanjiReadings.@count == 0 AND self.vocabularyReadings.@count == 0")
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Error during ReadingHandler.readingsWithoutSubjectReading() : \(error.localizedDescription)")
            throw error
        }
    }
}
