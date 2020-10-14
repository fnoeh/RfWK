//
//  SubjectAssociationsFacade.swift
//  RfWK
//
//  Created by Florian Nöhring on 30.12.19.
//  Copyright © 2019 Florian Nöhring. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class SubjectAssociationsFacade {
    
    let modelEntityConverter: ModelEntityConverter
    let context: NSManagedObjectContext
    let progressDelegate: ProgressDelegate?
    
    init(context: NSManagedObjectContext, progressDelegate: ProgressDelegate?) {
        self.context = context
        self.progressDelegate = progressDelegate
        modelEntityConverter = ModelEntityConverter(context: context)
    }
    
    func buildAndAssociate(wkSubjects: [WKSubject]) throws {
        let totalSubjects = wkSubjects.count
        var processedSubjects = 0
        do {
            for wkSubject in wkSubjects {
                processedSubjects += 1
                
                let data = wkSubject.data
                if let subject = try modelEntityConverter.subject(from: wkSubject) {
                    try context.save()
                    
                    if let kanji = subject as? Kanji {
                        for wkReading in data.readings ?? [] {
                            let reading: Reading = try modelEntityConverter.reading(from: wkReading)
                            try context.save()
                            _ = try modelEntityConverter.kanjiReading(between: reading, and: kanji, from: wkReading)
                            try context.save()
                        }
                    } else if let vocabulary = subject as? Vocabulary {
                        for wkReading in data.readings ?? [] {
                            let reading: Reading = try modelEntityConverter.reading(from: wkReading)
                            try context.save()
                            _ = try modelEntityConverter.vocabularyReading(between: reading, and: vocabulary, from: wkReading)
                            try context.save()
                        }
                    }
                    
                    _ = try modelEntityConverter.subjectTranslations(for: subject, from: data.meanings, and: data.auxiliary_meanings)
                    try context.save()
                }
                
                let progress = Float(processedSubjects) / Float(totalSubjects)
                progressDelegate?.progress(progress)
            }
        } catch {
            throw error
        }
    }
}
