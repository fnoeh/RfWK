//
//  SubjectHandlerTests.swift
//  RfWKTests
//
//  Created by Florian Nöhring on 27.12.19.
//  Copyright © 2019 Florian Nöhring. All rights reserved.
//

import XCTest
import CoreData
@testable import RfWK

class SubjectHandlerTests: XCTestCase {

    var stack: Stack!
    var context: NSManagedObjectContext!
    var handler: SubjectHandler<Subject>!
    
    override func setUp() {
        stack = MemoryStack()
        context = stack.storeContainer.viewContext
        handler = SubjectHandler<Subject>(context: context)
    }

    // MARK: - function object()
    
    // MARK: SubjectHandler<Vocabulary>
    
    func testObjectReturnsVocabulary() {
        let theHandler = SubjectHandler<Vocabulary>(context: context)!
        
        let object = theHandler.object()
        XCTAssert((object as Any?) is Subject)
        XCTAssert((object as Any?) is Vocabulary)
    }
    
    // MARK: function subject(from: WKSubject)
    
    // MARK: when using a Radical
        
    func testSubjectFromWKSubjectReturnsRadical() {
        let radical = WKFixtures().radical()
        XCTAssert((radical as Any?) is WKSubject)
        
        let result = handler.subject(from: radical)
        
        XCTAssert((result as Any?) is Subject)
        XCTAssert((result as Any?) is Radical)
                
        XCTAssertEqual(result.id, 57)
        XCTAssertEqual(result.level, 3)
        XCTAssertEqual(result.slug, "spoon")
        XCTAssertEqual(result.document_url, URL(string: "https://www.wanikani.com/radicals/spoon"))
        XCTAssertEqual(result.characters, "匕")
        XCTAssertEqual(result.meaning_mnemonic, "Meaning mnemonic for spoon.")
        XCTAssertNil(result.meaning_hint)
        XCTAssertNil(result.reading_mnemonic)
        XCTAssertNil(result.reading_hint)
    }
    
    // MARK: when using a Kanji
    
    func testSubjectFromWKSubjectReturnsKanji() {
        let kanji = WKFixtures().kanji()
        XCTAssert((kanji as Any?) is WKSubject)
        
        let result = handler.subject(from: kanji)
        
        XCTAssert((result as Any?) is Subject)
        XCTAssert((result as Any?) is Kanji)

        XCTAssertEqual(result.id, 607)
        XCTAssertEqual(result.level, 6)
        XCTAssertEqual(result.slug, "化")
        XCTAssertEqual(result.document_url, URL(string: "https://www.wanikani.com/kanji/%E5%8C%96"))
        XCTAssertEqual(result.characters, "化")
        XCTAssertEqual(result.meaning_mnemonic, "Meaning mnemonic for change.")
        XCTAssertEqual(result.meaning_hint, "Meaning hint for change.")
        XCTAssertEqual(result.reading_mnemonic, "Reading mnemonic for change.")
        XCTAssertEqual(result.reading_hint, "Reading hint for change.")
    }
    
    // MARK: when using a Vocabulary
    
    func testSubjectFromWKSubjectReturnsVocabulary() {
        let vocabulary = WKFixtures().vocabulary()
        XCTAssert((vocabulary as Any?) is WKSubject)
        
        let result = handler.subject(from: vocabulary)
        
        XCTAssert((result as Any?) is Subject)
        XCTAssert((result as Any?) is Vocabulary)

        XCTAssertEqual(result.id, 2854)
        XCTAssertEqual(result.level, 6)
        XCTAssertEqual(result.slug, "全て")
        XCTAssertEqual(result.document_url, URL(string: "https://www.wanikani.com/vocabulary/%E5%85%A8%E3%81%A6"))
        XCTAssertEqual(result.characters, "全て")
        XCTAssertEqual(result.meaning_mnemonic, "Meaning mnemonic for all.")
        XCTAssertNil(result.meaning_hint)
        XCTAssertEqual(result.reading_mnemonic, "Reading mnemonic for all.")
        XCTAssertNil(result.reading_hint)
    }
    
    // MARK: - function allWithLevel(in range)

    func testAllWithLevelInRageExcludesLowerLevels() {
        let subject = Fixtures(context: context).kanji(["level": 10])
        let result = try! handler.allWithLevel(in: 16...)
        XCTAssertFalse(result.contains(subject))
    }
    
    func testAllWithLevelInRageIncludesSubjecstInRange() {
        let subject = Fixtures(context: context).kanji(["level": 20])
        let result = try! handler.allWithLevel(in: 16...)
        XCTAssert(result.contains(subject))
    }
}
