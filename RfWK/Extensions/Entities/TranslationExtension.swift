//
//  TranslationExtension.swift
//  RfWK
//
//  Created by Florian Nöhring on 02.06.20.
//  Copyright © 2020 Florian Nöhring. All rights reserved.
//

import Foundation
import CoreData

extension Translation {
    
    func kanjiTranslations(_ context: NSManagedObjectContext? = nil) -> [SubjectTranslation] {
        return subjectTranslations(subjectType: .kanji, context: context)
    }
    
    
    func vocabularyTranslations(_ context: NSManagedObjectContext? = nil) -> [SubjectTranslation] {
        return subjectTranslations(subjectType: .vocabulary, context: context)
    }
    
    
    private enum SubjectType: String {
        case radical
        case kanji
        case vocabulary
    }
    
    private func subjectTranslations(subjectType: SubjectType, context: NSManagedObjectContext? = nil) -> [SubjectTranslation] {
        let fetchRequest: NSFetchRequest<SubjectTranslation> = SubjectTranslation.fetchRequest()
        fetchRequest.predicate = NSPredicate.init(format: "self.subject.object == %@ and self.translation == %@", String(describing: subjectType), self)
        let result: [SubjectTranslation] = try! (context ?? self.managedObjectContext!).fetch(fetchRequest)
        return result
    }
}
