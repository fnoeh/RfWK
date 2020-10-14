//
//  TranslationReviewTests.swift
//  RfWKTests
//
//  Created by Florian Nöhring on 12.06.20.
//  Copyright © 2020 Florian Nöhring. All rights reserved.
//

import XCTest
import CoreData
@testable import RfWK

class TranslationReviewTests: XCTestCase {

    var stack: Stack!
    var context: NSManagedObjectContext!
    var fixtures: Fixtures!
    
    override func setUpWithError() throws {
        stack = MemoryStack()
        context = stack.storeContainer.viewContext
        fixtures = Fixtures(context: context)
    }

    // MARK: - initialization
    
    func testTranslationIsAssigned() {
        let translation = fixtures.translation()
        
        let result = try! TranslationReview.init(translation: translation)
        XCTAssertEqual(result.translation, translation)
    }
    
    func testVocabularyWritings() {
        let translation = fixtures.translation()
        
        _ = fixtures.subjectTranslation(subject: fixtures.vocabulary(characters: "included"),
                                        translation: translation)
        
        // This is unrelated to translation and will not show up in the result
        _ = fixtures.subjectTranslation(subject: fixtures.vocabulary(characters: "excluded"),
                                        translation: fixtures.translation())
        
        let result = try! TranslationReview.init(translation: translation)
        XCTAssertEqual(result.vocabularyWritings, ["included"])
    }
    
    func testVocabularyReadings() {
        let translation = fixtures.translation()
        let vocabulary = fixtures.vocabulary()
        let reading = fixtures.reading()
        
    	_ = fixtures.vocabularyReading(vocabulary: vocabulary, reading: reading)
        _ = fixtures.subjectTranslation(subject: vocabulary, translation: translation)
        
        let result = try! TranslationReview.init(translation: translation)
        
        XCTAssertEqual(result.vocabularyReadings.count, 1)
        XCTAssertEqual(result.vocabularyReadings.first, reading.reading)
    }
}
