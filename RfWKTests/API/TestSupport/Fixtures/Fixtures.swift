//
//  Fixtures.swift
//  RfWKTests
//
//  Created by Florian Nöhring on 08.12.19.
//  Copyright © 2019 Florian Nöhring. All rights reserved.
//

import Foundation
import CoreData
@testable import RfWK

class Fixtures {
    
    let context: NSManagedObjectContext
    lazy var readingHandler = ReadingHandler<Reading>(context: context)!
    lazy var kanjiReadingHandler = KanjiReadingHandler<KanjiReading>(context: context)!
    lazy var vocabularyReadingHandler = VocabularyReadingHandler<VocabularyReading>(context: context)!
    lazy var radicalHandler = SubjectHandler<Radical>(context: context)!
    lazy var kanjiHandler = SubjectHandler<Kanji>(context: context)!
    lazy var vocabularyHandler = SubjectHandler<Vocabulary>(context: context)!
    lazy var translationHandler = TranslationHandler<Translation>(context: context)!
    lazy var subjectTranslationHandler = SubjectTranslationHandler<SubjectTranslation>(context: context)!
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func subjectTranslation(subject: Subject, translation: Translation, primary: Bool = true, auxiliary: Bool = false) -> SubjectTranslation {
        return subjectTranslationHandler.object(["subject": subject, "translation": translation, "primary": primary, "auxiliary": auxiliary])
    }
    
    func kanjiReading(type: KanjiReadingType = .onyomi) -> KanjiReading {
        return kanjiReadingHandler.kanjiReading(reading: reading(),
                                                type: type,
                                                kanji: kanji(),
                                                primary: true
        )
    }
    
    func vocabularyReading(vocabulary: Vocabulary, reading: Reading, primary: Bool = true) -> VocabularyReading {
        return vocabularyReadingHandler.vocabularyReading(reading: reading,
                                                          vocabulary: vocabulary,
                                                          primary: primary)
    }
    
    func vocabularyReading() -> VocabularyReading {
        return vocabularyReadingHandler.vocabularyReading(reading: reading(),
                                                          vocabulary: vocabulary(),
                                                          primary: true)
    }
    
    func reading() -> Reading {
        let reading = readingHandler.object(["reading": "the reading"])
        return reading
    }
    
    func radical() -> Radical {
        return radicalHandler.object([
            "characters": "a radical",
            "document_url": URL(string: "https://example.com/radical")!,
            "object": "radical",
            "id": 99,
            "level": 2,
            "meaning_hint": "a radical meaning hint",
            "meaning_mnemonic": "a radical meaning mnemonic",
            "reading_hint": "a radical reading hint",
            "reading_mnemonic": "a radical reading mnemonic",
            "slug": "radical_slug"
        ])
    }
    
    func kanji(_ overrides: [String: Any] = [:]) -> Kanji {
        let attributes = kanjiAttributes.merging(overrides, uniquingKeysWith: { (_, new) in new })
        return kanjiHandler.object(attributes)
    }
    
    let kanjiAttributes: [String: Any] = [
        "characters": "a kanji",
        "document_url": URL(string: "https://example.com")!,
        "object": "kanji",
        "id": 149,
        "level": 3,
        "meaning_hint": "a kanji meaning hint",
        "meaning_mnemonic": "a kanji meaning mnemonic",
        "reading_hint": "a kanji reading hint",
        "reading_mnemonic": "a kanji reading mnemonic",
        "slug": "kanji_slug"
    ]
    
    func vocabulary(characters: String) -> Vocabulary {
        let attributes = vocabularyAttributes.merging(["characters": characters], uniquingKeysWith: { (_, new) in new })
        return vocabularyHandler.object(attributes)
    }
    
    private let vocabularyAttributes: [String: Any] = [
        "characters": "a vocabulary",
        "document_url": URL(string: "https://example.com")!,
        "object": "vocabulary",
        "id": 86,
        "level": 3,
        "meaning_hint": "a vocabulary meaning hint",
        "meaning_mnemonic": "a vocabulary meaning mnemonic",
        "reading_hint": "a vocabulary reading hint",
        "reading_mnemonic": "a vocabulary reading mnemonic",
        "slug": "vocab_slug"
    ]
    
    func vocabulary() -> Vocabulary {
        return vocabularyHandler.object(vocabularyAttributes)
    }
    
    func translation() -> Translation {
        return translationHandler.object(["meaning": "a meaning"])
    }
}
