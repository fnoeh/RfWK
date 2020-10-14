//
//  StoreFacade.swift
//  RfWK
//
//  Created by Florian Nöhring on 24.04.20.
//  Copyright © 2020 Florian Nöhring. All rights reserved.
//

import Foundation
import CoreData

class EntityStoreFacade {
    
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func removeAll() throws {
        do {
            try self.removeAllSequentially()
        } catch {
            throw error
        }
    }
    
    func removeAllSequentially() throws {
        do {
            
            let subjectsFetchRequest:     NSFetchRequest<Subject>           = NSFetchRequest(entityName: "Subject")
            let translationsFetchRequest: NSFetchRequest<Translation>       = NSFetchRequest(entityName: "Translation")
            let readingsFetchRequest:     NSFetchRequest<Reading>           = NSFetchRequest(entityName: "Reading")
            let kanjiReadingRequest:      NSFetchRequest<KanjiReading>      = NSFetchRequest(entityName: "KanjiReading")
            let vocabularyReadingRequest: NSFetchRequest<VocabularyReading> = NSFetchRequest(entityName: "VocabularyReading")
            
            subjectsFetchRequest.includesPropertyValues = false
            translationsFetchRequest.includesPropertyValues = false
            readingsFetchRequest.includesPropertyValues = false
            kanjiReadingRequest.includesPropertyValues = false
            vocabularyReadingRequest.includesPropertyValues = false
            
            let subjects:     [Subject]     = try context.fetch(Subject.fetchRequest())
            let translations: [Translation] = try context.fetch(Translation.fetchRequest())
            let readings:     [Reading]     = try context.fetch(Reading.fetchRequest())
            let kanjiReadings: [KanjiReading] = try context.fetch(KanjiReading.fetchRequest())
            let vocabularyReadings: [VocabularyReading] = try context.fetch(VocabularyReading.fetchRequest())
            
            subjects.forEach { context.delete($0) }
            translations.forEach { context.delete($0) }
            readings.forEach { context.delete($0) }
            kanjiReadings.forEach { context.delete($0) }
            vocabularyReadings.forEach { context.delete($0) }
            
            try context.save()
        } catch {
            throw error
        }
    }
    
    func remove(from range: PartialRangeFrom<Int>) throws {
        let subjectHandler = SubjectHandler(context: context)!
        let readingHandler = ReadingHandler(context: context)!
        let translationHandler = TranslationHandler(context: context)!
        
        do {
            // step 1 - delete subjects and associated SubjectTranslations and associated SubjectReadings
            let subjectsToBeDeleted: [Subject] = try subjectHandler.allWithLevel(in: range)
            for subject in subjectsToBeDeleted {
                context.delete(subject)
            }
            
            // step 2a - delete Readings without SubjectReading
            let readingsToBeDeleted = try readingHandler.readingsWithoutSubjectReading()
            for reading in readingsToBeDeleted {
                context.delete(reading)
            }
            
            // step 2b - delete Translations without SubjectTranslation
            let translationsToBeDeleted = try translationHandler.translationsWithoutSubjectTranslation()
            for translation in translationsToBeDeleted {
                context.delete(translation)
            }
            
            try context.save()
        } catch let error as NSError {
            print("Error during EntityStoreFacade.remove(from range) - \(error.localizedDescription)")
            throw error
        }
    }
}
