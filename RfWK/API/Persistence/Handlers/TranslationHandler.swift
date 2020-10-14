//
//  TranslationHandler.swift
//  RfWK
//
//  Created by Florian Nöhring on 14.12.19.
//  Copyright © 2019 Florian Nöhring. All rights reserved.
//

import Foundation
import CoreData

class TranslationHandler<T: Translation> : Handler<T> {
    
    func translationsWithoutSubjectTranslation() throws -> [Translation] {
        let fetchRequest: NSFetchRequest<Translation> = Translation.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "self.subjectTranslations.@count == 0")
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Error during TranslationHandler.translationsWithoutSubjectTranslation() - \(error.localizedDescription)")
            throw error
        }
    }
}
