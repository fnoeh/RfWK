//
//  TranslationExtensionTests.swift
//  RfWKTests
//
//  Created by Florian Nöhring on 03.06.20.
//  Copyright © 2020 Florian Nöhring. All rights reserved.
//

import XCTest
import CoreData
@testable import RfWK

class TranslationExtensionTests: XCTestCase {

    var stack: Stack!
    var context: NSManagedObjectContext!
    var fixtures: Fixtures!
    
    override func setUpWithError() throws {
        stack = MemoryStack()
        context = stack.storeContainer.viewContext
        fixtures = Fixtures(context: context)
    }

    func testKanjiTranslations() throws {
        let radical = fixtures.radical()
        let kanji = fixtures.kanji()
        let translation = fixtures.translation()
        
        _ = fixtures.subjectTranslation(subject: kanji, translation: translation)
        _ = fixtures.subjectTranslation(subject: radical, translation: translation)
        
        let result = translation.kanjiTranslations()
        XCTAssertNotNil(result)
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.subject, kanji)
    }
    
    func testVocabularyTranslations() throws {
        let kanji = fixtures.kanji()
        let vocabulary = fixtures.vocabulary()
        let translation = fixtures.translation()
        
        _ = fixtures.subjectTranslation(subject: kanji, translation: translation)
        _ = fixtures.subjectTranslation(subject: vocabulary, translation: translation)
        
        let result = translation.vocabularyTranslations()
        XCTAssertNotNil(result)
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.subject, vocabulary)
    }
}
