//
//  VocabularyReadingHandler.swift
//  RfWK
//
//  Created by Florian Nöhring on 28.05.20.
//  Copyright © 2020 Florian Nöhring. All rights reserved.
//

import Foundation
import CoreData

class VocabularyReadingHandler<T: VocabularyReading> : Handler<T> {
    
    lazy var vocabularyReadingEntity = NSEntityDescription.entity(forEntityName: "VocabularyReading", in: self.context)!
    
    func vocabularyReading(reading: Reading,
                           vocabulary: Vocabulary,
                           primary: Bool) -> VocabularyReading {
        let result = NSManagedObject.init(entity: vocabularyReadingEntity, insertInto: context) as! VocabularyReading
        
        result.reading = reading
        result.vocabulary = vocabulary
        result.primary = primary
        
        return result
    }
}
