//
//  VocabularyTests.swift
//  RfWKTests
//
//  Created by Florian Nöhring on 15.12.19.
//  Copyright © 2019 Florian Nöhring. All rights reserved.
//

import XCTest
import CoreData
@testable import RfWK

class VocabularyTests: XCTestCase {

    var stack: Stack!
    var context: NSManagedObjectContext!
    var handler: SubjectHandler<Vocabulary>!
    lazy var fixtures = Fixtures(context: context)
    
    override func setUp() {
        stack = MemoryStack()
        context = stack.storeContainer.viewContext
        handler = SubjectHandler<Vocabulary>(context: context)
    }

    func testTypeAndAttributes() {
        let vocab = handler.object([
            "characters": "vocab",
            "document_url": URL(string: "http://url")!,
            "id": 37,
            "level": 4,
            "meaning_hint": "meaning_hint",
            "meaning_mnemonic": "meaning_mnemonic",
            "reading_hint": "reading_hint",
            "reading_mnemonic": "reading_mnemonic",
            "slug": "vocab_slug"
        ])
        
        XCTAssert((vocab as Any?) is Subject)
        XCTAssert((vocab as Any?) is Vocabulary)
        
        XCTAssertEqual(vocab.characters, "vocab")
        XCTAssertEqual(vocab.document_url, URL(string: "http://url"))
        XCTAssertEqual(vocab.id, 37)
        XCTAssertEqual(vocab.level, 4)
        XCTAssertEqual(vocab.meaning_hint, "meaning_hint")
        XCTAssertEqual(vocab.meaning_mnemonic, "meaning_mnemonic")
        XCTAssertEqual(vocab.reading_hint, "reading_hint")
        XCTAssertEqual(vocab.reading_mnemonic, "reading_mnemonic")
        XCTAssertEqual(vocab.slug, "vocab_slug")
    }

    func testFetchRequest() {
        let vocab = fixtures.vocabulary()
        try! context.save()
        
        let fetchRequest: NSFetchRequest<Vocabulary> = Vocabulary.fetchRequest()
        let result = try! context.fetch(fetchRequest)
        XCTAssertEqual(result.count, 1)
        
        let retrievedVocabulary = result.first!
        XCTAssertEqual(retrievedVocabulary, vocab)
    }
}
