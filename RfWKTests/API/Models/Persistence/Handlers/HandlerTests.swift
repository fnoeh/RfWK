//
//  HandlerTests.swift
//  RfWKTests
//
//  Created by Florian Nöhring on 23.12.19.
//  Copyright © 2019 Florian Nöhring. All rights reserved.
//

import XCTest
import CoreData
@testable import RfWK

class HandlerTests: XCTestCase {

    var stack: Stack!
    var context: NSManagedObjectContext!
    var fixtures: Fixtures!
    
    override func setUp() {
        stack = MemoryStack()
        context = stack.storeContainer.viewContext
        fixtures = Fixtures(context: context)
    }
    
    // MARK: - function object() + object([String:Any])
    
    // MARK: - Handler<Reading>
    
    // 1A (temporary)
    func testObjectWithoutValuesReturnsReading() {
        let handler = Handler<Reading>(context: context)!
        let object = handler.object()
        
        XCTAssert((object as Any?) is Reading)
    }
    
    // 1B (temporary)
    func testObjectWithValuesReturnsReading() {
        let handler = Handler<Reading>(context: context)!
        let object = handler.object([
            "reading": "まい"
        ])
        XCTAssert((object as Any?) is Reading)
        XCTAssertEqual(object.reading, "まい")
    }
    
    // MARK: Handler<VocabularyReading>
    
    // 3A (temporary)
    func testObjectWithoutValuesReturnsVocabularyReading() {
        let handler = Handler<VocabularyReading>(context: context)!
        let object = handler.object()
        XCTAssert((object as Any?) is VocabularyReading)
    }
    
    // MARK: Handler<KanjiReading>
    
    // 2A (temporary)
    func testObjectWithoutValuesReturnsKanjiReading() {
        let handler = Handler<KanjiReading>(context: context)!
        let object = handler.object()
        XCTAssert((object as Any?) is KanjiReading)
    }

    // 2B (temporary)
    func testObjectWithValuesReturnsKanjiReading() {
        let handler = Handler<KanjiReading>(context: context)!
        
        let kanji = fixtures.kanji()
        let reading = fixtures.reading()
        let kanjiReading = handler.object([
            "reading": reading,
            "type": "onyomi",
            "kanji": kanji
        ])
        XCTAssert((kanjiReading as Any?) is KanjiReading)
        XCTAssertEqual(kanjiReading.reading!.reading, reading.reading)
        XCTAssertEqual(kanjiReading.type, "onyomi")
    }
    
    // MARK: Handler<Translation>
    
    // 8A (temporary)
    func testObjectWithoutValuesReturnsTranslation() {
        let handler = Handler<Translation>(context: context)!
        let object = handler.object()
        XCTAssert((object as Any?) is Translation)
    }
    
    // 8B (temporary)
    func testObjectWithValuesReturnsTranslation() {
        let handler = Handler<Translation>(context: context)!
        let object = handler.object(["meaning": "dog"])
        XCTAssert((object as Any?) is Translation)
        XCTAssertEqual(object.meaning, "dog")
    }
    
    // MARK: Handler<Subject>
    
    let subjectAttributes: Dictionary<String, Any> = [
        "characters": "subj",
        "document_url": URL(string: "http://url")!,
        "id": 67,
        "level": 3,
        "meaning_hint": "meaning hint",
        "meaning_mnemonic": "meaning mnemonic",
        "reading_hint": "reading hint",
        "reading_mnemonic": "reading mnemonic",
        "slug": "a slug"
    ]
    
    private func subjectHasExpectedAttributes(_ testsubject: Subject, file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(testsubject.characters,       "subj",                     "characters not as expected",       file: file, line: line)
        XCTAssertEqual(testsubject.document_url,     URL(string: "http://url")!, "document_url not as expected",     file: file, line: line)
        XCTAssertEqual(testsubject.id,               67,                         "id not as expected",               file: file, line: line)
        XCTAssertEqual(testsubject.level,            3,                          "level not as expected",            file: file, line: line)
        XCTAssertEqual(testsubject.meaning_hint,     "meaning hint",             "meaning_hint not as expected",     file: file, line: line)
        XCTAssertEqual(testsubject.meaning_mnemonic, "meaning mnemonic",         "meaning_mnemonic not as expected", file: file, line: line)
        XCTAssertEqual(testsubject.reading_hint,     "reading hint",             "reading_hint not as expected",     file: file, line: line)
        XCTAssertEqual(testsubject.reading_mnemonic, "reading mnemonic",         "reading_mnemonic not as expected", file: file, line: line)
        XCTAssertEqual(testsubject.slug,             "a slug",                   "slug not as expected",             file: file, line: line)
    }
    
    // 4A (temporary)
    func testObjectWithoutValuesReturnsSubject() {
        let handler = Handler<Subject>(context: context)!
        let object = handler.object()
        XCTAssert((object as Any?) is Subject)
    }

    // 4B (temporary)
    func testObjectWithValuesReturnsSubject() {
        let handler = Handler<Subject>(context: context)!
        let object = handler.object(subjectAttributes)
        XCTAssert((object as Any?) is Subject)
        
        subjectHasExpectedAttributes(object)
    }
    
    // MARK: Handler<Radical>
    
    // 6A (temporary)
    func testObjectWithoutValuesReturnsRadical() {
        let handler = Handler<Radical>(context: context)!
        let object = handler.object()
        XCTAssert((object as Any?) is Radical)
    }

    // 6B (temporary)
    func testObjectWithValuesReturnsRadical() {
        let handler = Handler<Radical>(context: context)!
        let object = handler.object(subjectAttributes)
        XCTAssert((object as Any?) is Radical)
        
        subjectHasExpectedAttributes(object)
    }
    
    // MARK: Handler<Kanji>
    
    // 5A (temporary)
    func testObjectWithoutValuesReturnsKanji() {
        let handler = Handler<Kanji>(context: context)!
        let object = handler.object()
        XCTAssert((object as Any?) is Kanji)
    }
    
    // 5B (temporary)
    func testObjectWithValuesReturnsKanji() {
        let handler = Handler<Kanji>(context: context)!
        let object = handler.object(subjectAttributes)
        XCTAssert((object as Any?) is Kanji)
        
        subjectHasExpectedAttributes(object)
    }
    
    // MARK: Handler<Vocabulary>
    
    // 7A (temporary)
    func testObjectWithoutValuesReturnsVocabulary() {
        let handler = Handler<Vocabulary>(context: context)!
        let object = handler.object()
        XCTAssert((object as Any?) is Vocabulary)
    }

    // 7B (temporary)
    func testObjectWithValuesReturnsVocabulary() {
        let handler = Handler<Vocabulary>(context: context)!
        let object = handler.object(subjectAttributes)
        XCTAssert((object as Any?) is Vocabulary)
        
        subjectHasExpectedAttributes(object)
    }
    
    // MARK: - func findOne(by:)
    
    func testFindOneEmptyResult() {
        let handler = Handler<Translation>(context: context)!
        let result: Translation? = try! handler.findOne()
        XCTAssertNil(result)
    }
    
    func testFindOneReturnsOnlySpecifiedType() {
        let readingHandler = Handler<Reading>(context: context)!
        _ = readingHandler.object()
        
        let translationHandler = Handler<Translation>(context: context)!
        let existingTranslation = translationHandler.object()
        
        let result: Translation? = try! translationHandler.findOne()
        XCTAssert((result as Any?) is Translation)
        XCTAssertEqual(result, existingTranslation)
    }
    
    // 1C (temporary)
    func testFindOneReturnsReading() {
        let handler = Handler<Reading>(context: context)!
        let existingReading = handler.object()
        
        let result: Reading? = try! handler.findOne()
        XCTAssert((result as Any?) is Reading)
        XCTAssertEqual(result, existingReading)
    }
    
    // 6C (temporary)
    func testFindOneReturnsRadical() {
        let handler = Handler<Radical>(context: context)!
        let existingRadical = handler.object()
        
        let result: Radical? = try! handler.findOne()
        XCTAssert((result as Any?) is Radical)
        XCTAssertEqual(result, existingRadical)
    }
    
    
    func testFindOneDoesNotReturnSupertype() {
        let kanjiHandler = Handler<Kanji>(context: context)!
        let subjectHandler = Handler<Subject>(context: context)!
        _ = subjectHandler.object()
        
        let result = try! kanjiHandler.findOne()
        XCTAssertNil(result)
    }
        
    func testFindOneReturnsSubtype() {
        let subjectHandler = Handler<Subject>(context: context)!
        let kanjiHandler = Handler<Kanji>(context: context)!
        let existingKanji = kanjiHandler.object()
        let result = try! subjectHandler.findOne()
        
        XCTAssertNotNil(result)
        XCTAssert((result as Any?) is Kanji)
        XCTAssertEqual(result, existingKanji)
    }
    
    // 8D (temporary)
    func testFindOneReturnsExistingObjectWithFullMatch() {
        let handler = Handler<Translation>(context: context)!
        let existingTranslation = handler.object(["meaning":"the meaning"])
        let result: Translation? = try! handler.findOne(by: ["meaning": "the meaning"])
        
        XCTAssertNotNil(result)
        XCTAssert((result as Any?) is Translation)
        XCTAssertEqual(result, existingTranslation)
    }
    
    func testFindOneDoesNotReturnExistingObjectWithoutMatch() {
        let handler = Handler<Translation>(context: context)!
        _ = handler.object(["meaning":"one"])
        
        let result: Translation? = try! handler.findOne(by: ["meaning": "two"])
        XCTAssertNil(result)
    }
    
    func testFindOneDoesNotReturnExistingObjectWithPartialMatch() {
        let handler = Handler<Kanji>(context: context)!
        let existingKanji = fixtures.kanji()
        
        let searchParams: [String:Any] = [
            "id": (existingKanji.id + 10), // id will not match
            "characters": existingKanji.characters as Any,
            "slug": existingKanji.slug as Any
        ]
        let result: Kanji? = try! handler.findOne(by: searchParams)
        XCTAssertNil(result)
    }
    
    func testFindOneWithoutMatchCallsClosure() {
        let handler = Handler<Translation>(context: context)!
        let expectation = XCTestExpectation(description: "Closure called")
        
        _ = try! handler.findOne() { () -> Translation? in
            expectation.fulfill()
            return nil
        }
        
        self.wait(for: [expectation], timeout: 0.3)
    }
    
    func testFindOneWithMatchDoesNotCallClosure() {
        let handler = Handler<Translation>(context: context)!
        let existingTranslation = handler.object()
        
        let expectation = XCTestExpectation(description: "Closure called")
        expectation.isInverted = true
        
        let result = try! handler.findOne() { () -> Translation? in
            XCTFail("Closure was called unexpectedly in Handler.findOne()")
            return nil
        }
        
        XCTAssertNotNil(result)
        XCTAssert((result as Any?) is Translation)
        XCTAssertEqual(result, existingTranslation)
    }
    
    func testFindOneWithoutMatchReturnsResultFromClosure() {
        let handler = Handler<Translation>(context: context)!
        
        let result = try! handler.findOne() { () -> Translation? in
            return handler.object(["meaning":"abc"])
        }
        
        XCTAssertNotNil(result)
        XCTAssert((result as Any?) is Translation)
        XCTAssertEqual(result?.meaning, "abc")
    }
    
    // MARK: - function findOrCreateOne

    // 8E (temporary)
    func testfindOrCreateOneReturnsExistingObject() {
        let handler: Handler<Translation> = Handler<Translation>(context: context)!
        let existingObject = handler.object(["meaning": "blue"])
        let foundObject = try! handler.findOrCreateOne(by: ["meaning":"blue"])

        XCTAssertEqual(foundObject, existingObject)
    }

    // 8F (temporary)
    func testfindOrCreateOneReturnsNewObjectIfNotFound() {
        let handler: Handler<Translation> = Handler<Translation>(context: context)!
        let existingObject = handler.object(["meaning": "red"])
        let newObject = try! handler.findOrCreateOne(by: ["meaning":"blue"])

        XCTAssertNotEqual(newObject, existingObject)
        XCTAssert((newObject as Any?) is Translation)
        XCTAssertEqual(newObject.meaning, "blue")
    }
    
    // MARK: - random(predicate:)
    
    func testRandomWithoutEntitiesReturnsNil() throws {
        let handler: Handler<Translation> = Handler<Translation>(context: context)!
        do {
            let result = try handler.random(predicate: nil)
            XCTAssertNil(result)
        } catch {
            throw error
        }
    }

    func testRandomWithOnlyOneEntityReturnsThatEntity() {
        let handler = Handler<Translation>(context: context)!
        let translation = fixtures.translation()
        let result = try! handler.random(predicate: nil)
        XCTAssertEqual(result, translation)
    }

    func testRandomReturnsExistingEntity() {
        let handler = Handler<Translation>(context: context)!

        let translation1 = fixtures.translation()
        let translation2 = fixtures.translation()

        let result = try! handler.random(predicate: nil)
        XCTAssert([translation1, translation2].contains(result))
    }


    func testRandomIncludesEntityWithPredicate() {
        let handler = SubjectTranslationHandler<SubjectTranslation>(context: context)!

        let vocabulary = fixtures.vocabulary()
        let translation = fixtures.translation()

        let vocabularyTranslation = fixtures.subjectTranslation(subject: vocabulary, translation: translation)
        let predicate = NSPredicate.init(format: "self.subject.object = %@", "vocabulary")

        let result = try! handler.random(predicate: predicate)
        XCTAssertEqual(result, vocabularyTranslation)
    }

    func testRandomExcludesUnwantedEntitiesWithPredicate() {
        let handler = SubjectTranslationHandler<SubjectTranslation>(context: context)!

        let kanji = fixtures.kanji()
        let translation = fixtures.translation()

        _ = fixtures.subjectTranslation(subject: kanji, translation: translation)
        let predicate = NSPredicate.init(format: "self.subject.object = %@", "vocabulary")

        let result = try! handler.random(predicate: predicate)
        XCTAssertNil(result)
    }
    
    func testRandomWithExclusionOfCertainEntities() {
        let handler = Handler<Translation>(context: context)!
        
        let translation = fixtures.translation()
        let predicate = NSPredicate.init(format: "NOT (SELF.objectID IN %@)", [translation.objectID])
        
        let result = try! handler.random(predicate: predicate)
        XCTAssertNil(result)
    }
}
