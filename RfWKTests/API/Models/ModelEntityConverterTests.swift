//
//  ModelEntityConverterTests.swift
//  RfWKTests
//
//  Created by Florian Nöhring on 13.04.20.
//  Copyright © 2020 Florian Nöhring. All rights reserved.
//

import XCTest
import CoreData
@testable import RfWK

class ModelEntityConverterTests: XCTestCase {

    var stack: Stack!
    var context: NSManagedObjectContext!
    var modelEntityConverter: ModelEntityConverter!
    
    override func setUpWithError() throws {
        stack = MemoryStack()
        context = stack.storeContainer.viewContext
        modelEntityConverter = ModelEntityConverter(context: context)
    }

    // MARK: - function reading(from: WKReading)
    
    func testReadingFromWKReadingCreatesNewReading() {
        let wkVocabularyReading = WKFixtures().readingWithoutType()
        let fetchRequest = Reading.fetchRequest() as NSFetchRequest<Reading>
        let result = try! modelEntityConverter.reading(from: wkVocabularyReading)
        
        XCTAssert((result as Any?) is Reading)
        XCTAssertEqual(try! context.count(for: fetchRequest), 1)
    }
    
    func testReadingFromWKReadingReturnsExistingReading() {
        let reading = "え"
        let primary = false
        let accepted_answer = true
        
        let fetchRequest: NSFetchRequest<Reading> = Reading.fetchRequest()
        let handler = ReadingHandler<Reading>(context: context)!
        let existingReading = handler.reading(reading)
        
        XCTAssertEqual(try! context.count(for: fetchRequest), 1)
        
        let wkReading = WKReading(type: nil, primary: primary, reading: reading, accepted_answer: accepted_answer)
        let result = try! modelEntityConverter.reading(from: wkReading)
        
        XCTAssertEqual(result, existingReading)
        XCTAssertEqual(try! context.count(for: fetchRequest), 1) // Still 1
    }
    
    // MARK: - function kanjiReading(between: Reading, and: Kanji from: WKReading)
    
    func testKanjiReadingUpdatesAttributePrimaryWithCurrentValueInWKReading() {
        let fixtures = Fixtures(context: context)
        
        let existingKanjiReading = fixtures.kanjiReading()
        let existingKanji = existingKanjiReading.kanji!
        let existingReading = existingKanjiReading.reading!
        
        let initialValue = existingKanjiReading.primary
        
        let wkReading = WKReading(type: existingKanjiReading.type,
                                  primary: !initialValue,   // flipped attribute compared to existing KanjiReading
                                  reading: existingKanjiReading.reading!.reading!,
                                  accepted_answer: true)
        
        let result = try! modelEntityConverter.kanjiReading(between: existingReading, and: existingKanji, from: wkReading)
        
        XCTAssertEqual(result, existingKanjiReading)
        XCTAssertEqual(result.primary, !initialValue)
    }
    
    // MARK: - function translation(from: WKMeaning)
    
    func testTranslationFromWKMeaningReturnsTranslationIfAcceptedAnswer() {
        let input = WKFixtures().meaning(acceptance: .accepted)
        let result = try! modelEntityConverter.translation(from: input)
        XCTAssert((result as Any?) is Translation)
    }
    
    func testTranslationFromWKMeaningReturnsNilIfNotAcceptedAnswer() {
        let input = WKFixtures().meaning(acceptance: .notAccepted)
        let result = try! modelEntityConverter.translation(from: input)
        XCTAssertNil(result)
    }
    
    func testTranslationFromWhitelistedWKAuxiliaryMeaningReturnsTranslation() {
        let input = WKFixtures().auxiliaryMeaning(type: .whitelist)
        let result = try! modelEntityConverter.translation(from: input)
        XCTAssert((result as Any?) is Translation)
    }
    
    func testTranslationFromBlacklistedWKAuxiliaryMeaningReturnsNil() {
        let input = WKFixtures().auxiliaryMeaning(type: .blacklist)
        let result = try! modelEntityConverter.translation(from: input)
        XCTAssertNil(result)
    }
    
    func testTranslationFromWKMeaningReturnsExistingTranslationIfAcceptedAnswer() {
        let handler = Handler<Translation>(context: context)!
        let existingTranslation = handler.object(["meaning":"meaning"])
        
        let wkMeaning = WKMeaning(meaning: "meaning", primary: false, accepted_answer: true)
        let result = try! modelEntityConverter.translation(from: wkMeaning)
        
        XCTAssertEqual(result, existingTranslation)
    }
    
    func testTranslationFromWhitelistedWKAuxiliaryMeaningReturnsExistingTranslation() {
        let handler = Handler<Translation>(context: context)!
        let existingTranslation = handler.object(["meaning":"meaning"])
        
        let auxMeaning = WKAuxiliaryMeaning(type: "whitelist", meaning: "meaning")
        let result = try! modelEntityConverter.translation(from: auxMeaning)
        
        XCTAssertEqual(result, existingTranslation)
    }
    
    // MARK: - function subject(from: WKSubject)
    
    func testSubjectWithHiddenAtReturnsNil() {
        var subjectData = wkSubjectData
        subjectData.hidden_at = Date()
        
        let wkSubject = WKSubject(id: 99, object: "radical", url: "", data_updated_at: Date(), data: subjectData)
        let result = try! modelEntityConverter.subject(from: wkSubject)
        XCTAssertNil(result)
    }
    
    let subjectAttributes: [String: Any] = [
        "id": 270,
        "characters": "characters",
        "level": 16,
        "slug": "slug",
        "document_url": URL(string: "https://www.wanikani.com/") as Any,
        "reading_mnemonic": "reading mnemonic",
        "reading_hint": "reading hint",
        "meaning_mnemonic": "meaning mnemonic",
        "meaning_hint": "meaning hint"
    ]
    
    lazy var wkSubjectData: WKSubjectData = {
        WKSubjectData(
            auxiliary_meanings: [],
            created_at: Date(),
            document_url: (subjectAttributes["document_url"] as! URL).absoluteString,
            hidden_at: nil,
            lesson_position: 99,
            level: subjectAttributes["level"] as! Int,
            meanings: [],
            slug: subjectAttributes["slug"] as! String,
            characters: subjectAttributes["characters"] as? String,
            amalgamation_subject_ids: [],
            character_images: [],
            component_subject_ids: [],
            visually_similar_subject_ids: [],
            readings: [],
            parts_of_speech: [],
            context_sentences: [],
            pronunciation_audios: [],
            reading_mnemonic: "reading mnemonic",
            reading_hint: "reading hint",
            meaning_mnemonic: "meaning mnemonic",
            meaning_hint: "meaning hint")
    }()
    
    private func subjectHasExpectedAttributes(_ testSubject: Subject, file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(testSubject.characters,       subjectAttributes["characters"]       as? String, file: file, line: line)
        XCTAssertEqual(testSubject.slug,             subjectAttributes["slug"]             as? String, file: file, line: line)
        XCTAssertEqual(testSubject.level,            Int16(subjectAttributes["level"]      as! Int),  file: file, line: line)
        XCTAssertEqual(testSubject.document_url,     subjectAttributes["document_url"]     as? URL,    file: file, line: line)
        XCTAssertEqual(testSubject.reading_mnemonic, subjectAttributes["reading_mnemonic"] as? String, file: file, line: line)
        XCTAssertEqual(testSubject.reading_hint,     subjectAttributes["reading_hint"]     as? String, file: file, line: line)
        XCTAssertEqual(testSubject.meaning_mnemonic, subjectAttributes["meaning_mnemonic"] as? String, file: file, line: line)
        XCTAssertEqual(testSubject.meaning_hint,     subjectAttributes["meaning_hint"]     as? String, file: file, line: line)
    }

    private func buildWKSubject(id: Int, object: String, data: WKSubjectData) -> WKSubject {
        return WKSubject(id: id, object: object, url: "http://example.com", data_updated_at: Date(), data: data)
    }
    
    // MARK: - function radical(id: Int, from: WKSubjectData)

    func testSubjectWithRadicalAsWKSubjectReturnsExistingRadicalIdentifiedByID() {
        let handler = SubjectHandler<Radical>(context: context)!
        let existingRadical = handler.object(subjectAttributes)
        let id = Int(existingRadical.id)
        
        let wkSubject = buildWKSubject(id: id, object: "radical", data: wkSubjectData)
        let result = try! modelEntityConverter.subject(from: wkSubject)
        
        XCTAssertEqual(result, existingRadical)
    }
    
    func testSubjectWithRadicalAsWKSubjectCreatesNewRadicalIfNothingFoundByID() {
        let handler = SubjectHandler<Radical>(context: context)!
        let existingRadical = handler.object(subjectAttributes)
        let unmatchedID = Int(existingRadical.id) + 99
        
        let wkSubject = buildWKSubject(id: unmatchedID, object: "radical", data: wkSubjectData)
        let result = try! modelEntityConverter.subject(from: wkSubject)!
        
        XCTAssertNotEqual(result, existingRadical)
        XCTAssert((result as Any) is Radical)
        XCTAssertEqual(result.id, Int16(unmatchedID))
        subjectHasExpectedAttributes(result)
    }
    
    // MARK: - function kanji(id: Int, from: WKSubject)
    
    func testSubjectWithKanjiAsWKSubjectReturnsExistingKanjiIdentifiedByID() {
        let handler = SubjectHandler<Kanji>(context: context)!
        let existingKanji = handler.object(subjectAttributes)
        let id = Int(existingKanji.id)
        
        let wkSubject = buildWKSubject(id: id, object: "kanji", data: wkSubjectData)
        let result = try! modelEntityConverter.subject(from: wkSubject)
        
        XCTAssertEqual(result, existingKanji)
    }
    
    func testSubjectWithKanjiAsWKSubjectCreatesNewKanjiIfNothingFoundByID() {
        let handler = SubjectHandler<Kanji>(context: context)!
        let existingKanji = handler.object(subjectAttributes)
        let unmatchedID = Int(existingKanji.id) + 10
        
        let wkSubject = buildWKSubject(id: unmatchedID, object: "kanji", data: wkSubjectData)
        let result = try! modelEntityConverter.subject(from: wkSubject)!
        
        XCTAssertEqual(result.id, Int16(unmatchedID))
        subjectHasExpectedAttributes(result)
    }
    
    // MARK: - function vocabulary(id: Int, from: WKSubject)
    
    func testSubjectWithVocabularyAsWKSubjectReturnsExistingVocabularyIdentifiedByID() {
        let handler = SubjectHandler<Vocabulary>(context: context)!
        let existingVocabulary = handler.object(subjectAttributes)
        let id = Int(existingVocabulary.id)
        
        let wkSubject = buildWKSubject(id: id, object: "vocabulary", data: wkSubjectData)
        let result = try! modelEntityConverter.subject(from: wkSubject)
        
        XCTAssertEqual(result, existingVocabulary)
    }
    
    func testSubjectWithVocabularyAsWKSubjectCreatesNewVocabularyIfNothingFoundByID() {
        let handler = SubjectHandler<Vocabulary>(context: context)!
        let existingVocabulary = handler.object(subjectAttributes)
        let unmatchedID = Int(existingVocabulary.id) + 10
        
        let wkSubject = buildWKSubject(id: unmatchedID, object: "vocabulary", data: wkSubjectData)
        let result = try! modelEntityConverter.subject(from: wkSubject)!
        
        XCTAssertEqual(result.id, Int16(unmatchedID))
        subjectHasExpectedAttributes(result)
    }
}
