//
//  ModelEntityConverter.swift
//  RfWK
//
//  Created by Florian Nöhring on 12.04.20.
//  Copyright © 2020 Florian Nöhring. All rights reserved.
//
// The purpose of this class is to take input of a WaniKani Model, e. g. WKSubject and turn
// it into an appropriate subject entity, for example a Vocabulary.
//

import Foundation
import CoreData

class ModelEntityConverter {
    
    let context: NSManagedObjectContext
    // lazy var radicalEntity = NSEntityDescription.entity(forEntityName: "Radical", in: context)!
    // lazy var kanjiEntity = NSEntityDescription.entity(forEntityName: "Kanji", in: context)!
    // lazy var vocabularyEntity = NSEntityDescription.entity(forEntityName: "Vocabulary", in: context)!
    // lazy var vocabularyReadingEntity = NSEntityDescription.entity(forEntityName: "VocabularyReading", in: context)!
    // lazy var kanjiReadingEntity = NSEntityDescription.entity(forEntityName: "KanjiReading", in: context)!
    // lazy var translationEntity = NSEntityDescription.entity(forEntityName: "Translation", in: context)!
    
    lazy var readingHandler = Handler<Reading>(context: context)!
    lazy var vocabularyReadingHandler = Handler<VocabularyReading>(context: context)!
    lazy var kanjiReadingHandler = Handler<KanjiReading>(context: context)!
    lazy var translationHandler = TranslationHandler<Translation>(context: context)!
    
    lazy var radicalHandler = SubjectHandler<Radical>(context: context)!
    lazy var kanjiHandler = SubjectHandler<Kanji>(context: context)!
    lazy var vocabularyHandler = SubjectHandler<Vocabulary>(context: context)!
    
    lazy var subjectTranslationHandler = SubjectTranslationHandler<SubjectTranslation>(context: context)!
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    // MARK: - Reading
    
    func reading(from wkReading: WKReading) throws -> Reading {
        do {
            return try readingHandler.findOrCreateOne(by: ["reading": wkReading.reading])
        } catch {
            throw error
        }
    }
    
    func kanjiReading(between reading: Reading, and kanji: Kanji, from wkReading: WKReading) throws -> KanjiReading {
        do {
            // TODO: the findOrCreateOne function on KanjiReadingHandler must be tested
            let result = try kanjiReadingHandler.findOrCreateOne(by: [
                "reading": reading,
                "kanji": kanji,
                "type": wkReading.type as Any
            ])
            result.primary = wkReading.primary
            
            return result
        } catch {
            throw error
        }
    }
    
    func vocabularyReading(between reading: Reading, and vocabulary: Vocabulary, from wkReading: WKReading) throws -> VocabularyReading {
        do {
            let result = try vocabularyReadingHandler.findOrCreateOne(by: ["reading": reading, "vocabulary": vocabulary])
            result.primary = wkReading.primary
            return result
        } catch {
            throw error
        }
    }
    
    // MARK: - SubjectTranslation
    
    func subjectTranslation(for subject: Subject, from wkMeaning: WKMeaning) throws -> SubjectTranslation? {
        guard (wkMeaning.accepted_answer) else { return nil }

        do {
            let translation = try translationHandler.findOrCreateOne(by: ["meaning": wkMeaning.meaning])
            let result = try subjectTranslationHandler.findOrCreateOne(by: ["subject": subject, "translation": translation])
            result.primary = wkMeaning.primary
            result.auxiliary = false
            return result
        } catch {
            throw error
        }
    }
    
    func subjectTranslation(for subject: Subject, from auxMeaning: WKAuxiliaryMeaning) throws -> SubjectTranslation? {
        guard (auxMeaning.type == "whitelist") else { return nil }

        do {
            let translation = try translationHandler.findOrCreateOne(by: ["meaning": auxMeaning.meaning])
            let result = try subjectTranslationHandler.findOrCreateOne(by: ["subject": subject, "translation": translation])
            result.primary = false
            result.auxiliary = true
            return result
        } catch {
            throw error
        }
    }
    
    func subjectTranslations(for subject: Subject, from wkMeanings: [WKMeaning], and auxMeanings: [WKAuxiliaryMeaning]) throws -> [SubjectTranslation] {
        var result: [SubjectTranslation] = []
        
        do {
            try wkMeanings.forEach { wkMeaning in
                if let subjectTranslation = try self.subjectTranslation(for: subject, from: wkMeaning) {
                    result.append(subjectTranslation)
                }
            }
            try auxMeanings.forEach { auxMeaning in
                if let subjectTranslation = try self.subjectTranslation(for: subject, from: auxMeaning) {
                    result.append(subjectTranslation)
                }
            }
        } catch {
            throw error
        }
        
        return result
    }
    

    // MARK: - Translation
    
    // Returns a Translation only if the WKMeaning is accepted_answer
    func translation(from wkMeaning: WKMeaning) throws -> Translation? {
        guard (wkMeaning.accepted_answer) else { return nil }
        
        do {
            let result = try translationHandler.findOrCreateOne(by: ["meaning": wkMeaning.meaning])
            return result
        } catch {
            throw error
        }
    }
    
    // Returns a Translation only if the WKAuxiliaryMeaning is of type whitelist
    func translation(from auxMeaning: WKAuxiliaryMeaning) throws -> Translation? {
        guard (auxMeaning.type == "whitelist") else { return nil }
        
        do {
            let result = try translationHandler.findOrCreateOne(by: ["meaning": auxMeaning.meaning])
            return result
        } catch {
            throw error
        }
    }
    
    func translations(from meanings: [WKMeaning], and aux_meanings: [WKAuxiliaryMeaning]) throws -> [Translation] {
        var result: [Translation] = []
        
        do {
            try meanings.forEach { wkMeaning in
                if let translation = try self.translation(from: wkMeaning) {
                    result.append(translation)
                }
            }
            try aux_meanings.forEach { wkAuxMeaning in
                if let translation = try self.translation(from: wkAuxMeaning) {
                    result.append(translation)
                }
            }
        } catch {
            throw error
        }
        
        return result
    }
    
    // MARK: - Subject
    
    func subject(from wkSubject: WKSubject) throws -> Subject? {
        guard (wkSubject.data.hidden_at == nil) else { return nil }
        
        do {
            switch wkSubject.object {
            case "radical":
                return try subject(type: Radical.self, object: wkSubject.object, id: wkSubject.id, data: wkSubject.data, handler: radicalHandler)
            case "kanji":
                return try subject(type: Kanji.self, object: wkSubject.object, id: wkSubject.id, data: wkSubject.data, handler: kanjiHandler)
            case "vocabulary":
                return try subject(type: Vocabulary.self, object: wkSubject.object, id: wkSubject.id, data: wkSubject.data, handler: vocabularyHandler)
            default:
                return nil
            }
        } catch {
            throw error
        }
    }
    
    private func subjectCreateParams(object: String, id: Int, data: WKSubjectData) -> [String: Any] {
        let result = [
            "object": object,
            "id": id,
            "slug": data.slug,
            "document_url": URL(string: data.document_url) as Any,
            "level": data.level,
            "characters": data.characters as Any?,
            "meaning_hint": data.meaning_hint as Any?,
            "meaning_mnemonic": data.meaning_mnemonic as Any?,
            "reading_hint": data.reading_hint as Any?,
            "reading_mnemonic": data.reading_mnemonic as Any?
        ].filter { $0.value != nil }.mapValues { $0! }
        
        return result
    }
    
    private func subject<T: Subject>(type: T.Type, object: String, id: Int, data:WKSubjectData, handler: SubjectHandler<T>) throws -> T {
        let createParams = subjectCreateParams(object: object, id: id, data: data)
        let searchParams = ["id": id]
        
        do {
            let result: T = try handler.findOne(by: searchParams) ?? handler.findOrCreateOne(by: createParams)
            
            return result
        } catch {
            throw error
        }
    }
}
