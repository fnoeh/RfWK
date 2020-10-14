//
//  TranslationReview.swift
//  RfWK
//
//  Created by Florian Nöhring on 12.06.20.
//  Copyright © 2020 Florian Nöhring. All rights reserved.
//

import Foundation

enum TranslationReviewResult {
    case skipped
    case correct
    case wrong
}

class TranslationReview {
    var translation: Translation
    
    // TODO: Kanji would be nice to have later to tell when the user accidentally
    // tries to enter the reading of a kanji instead of a vocabulary
    // var kanjiReadings: [String]
    // var kanjiWritings: [String]
    var vocabularyReadings: [String]
    var vocabularyWritings: [String]
    var givenAnswer: String?
    var result: TranslationReviewResult?
    
    init(translation: Translation) throws {
        self.translation = translation
        
        // kanjiReadings = []
        // kanjiWritings = []
        
        let vocabularies = translation.vocabularyTranslations().map({ (subjectTranslation) in return subjectTranslation.subject as! Vocabulary })
        self.vocabularyWritings = vocabularies.map { $0.characters! }
        
        var collectedReadings = Set<String>()
        do {
            for vocabulary in vocabularies {
                try vocabulary.associatedReadings().forEach({ collectedReadings.insert($0.reading!) })
            }
        } catch {
            throw error
        }
        
        vocabularyReadings = Array(collectedReadings)
    }
    
    func checkAnswer(answer: String) -> TranslationReviewResult {
        if answer == "" {
            self.result = .skipped
        } else if (self.vocabularyReadings.contains(answer) || self.vocabularyWritings.contains(answer)) {
            self.result = .correct
        } else {
            self.result = .wrong
        }
        self.givenAnswer = answer
        
        return self.result!
    }
}
