//
//  KanjiTests.swift
//  RfWKTests
//
//  Created by Florian Nöhring on 08.12.19.
//  Copyright © 2019 Florian Nöhring. All rights reserved.
//

import XCTest
import CoreData
@testable import RfWK

class KanjiTests: XCTestCase {

    var stack: Stack!
    var context: NSManagedObjectContext!
    var handler: SubjectHandler<Kanji>!
    lazy var fixtures = Fixtures(context: context)
    
    override func setUp() {
        stack = MemoryStack()
        context = stack.storeContainer.viewContext
        handler = SubjectHandler<Kanji>(context: context)
    }

    func testTypeAndAttributes() {
        let kanji = handler.object([
            "characters": "上",
            "document_url": URL(string: "https://www.wanikani.com/kanji/%E4%B8%8A")!,
            "id": 450,
            "level": 1,
            "meaning_hint": "meaning hint",
            "meaning_mnemonic": "meaning mnemonic",
            "reading_hint": "reading hint",
            "reading_mnemonic": "reading mnemonic",
            "slug": "上"
        ])
        
        XCTAssert((kanji as Any?) is Subject)
        XCTAssert((kanji as Any?) is Kanji)
        
        XCTAssertEqual(kanji.characters, "上")
        XCTAssertEqual(kanji.document_url, URL(string: "https://www.wanikani.com/kanji/%E4%B8%8A"))
        XCTAssertEqual(kanji.id, 450)
        XCTAssertEqual(kanji.level, 1)
        XCTAssertEqual(kanji.meaning_hint, "meaning hint")
        XCTAssertEqual(kanji.meaning_mnemonic, "meaning mnemonic")
        XCTAssertEqual(kanji.reading_hint, "reading hint")
        XCTAssertEqual(kanji.reading_mnemonic, "reading mnemonic")
        XCTAssertEqual(kanji.slug, "上")
    }
    
    func testFetchRequest() {
        let kanji = fixtures.kanji()
        XCTAssertNoThrow(try context.save())
        
        let fetchRequest: NSFetchRequest<Kanji> = Kanji.fetchRequest()
        let result: [Kanji] = try! context.fetch(fetchRequest)
        XCTAssertEqual(result.count, 1)
        
        let retrievedKanji = result.first!
        XCTAssertEqual(retrievedKanji, kanji)
    }
}
