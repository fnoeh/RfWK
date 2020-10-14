//
//  InMemoryEntityStoreFacadeTests.swift
//  RfWKTests
//
//  Created by Florian Nöhring on 24.04.20.
//  Copyright © 2020 Florian Nöhring. All rights reserved.
//

import XCTest
import CoreData
@testable import RfWK

class InMemoryEntityStoreFacadeTests: EntityStoreFacadeTests {

    override func buildStack() -> Stack {
        return MemoryStack()
    }

    // MARK: - function removeAllSequentially()
    
    func testRemoveAllSequentially() {
        XCTContext.runActivity(named: "Make sure there are stored no entities whatsoever before") { _ in
            XCTAssertEqual(try! count(type: .Subject), 0)
            XCTAssertEqual(try! count(type: .Radical), 0)
            XCTAssertEqual(try! count(type: .Kanji), 0)
            XCTAssertEqual(try! count(type: .Vocabulary), 0)

            XCTAssertEqual(try! count(type: .Translation), 0)

            XCTAssertEqual(try! count(type: .Reading), 0)
            XCTAssertEqual(try! count(type: .KanjiReading), 0)
            XCTAssertEqual(try! count(type: .VocabularyReading), 0)
        }
        
        XCTContext.runActivity(named: "create at least one of each Entity type") { _ in
            createSubject()
            createRadical()
            _ = createKanji()
            createVocabulary()

            createTranslation()

            _ = createReading()
            createKanjiReading()
            createVocabularyReading()
        }

        XCTContext.runActivity(named: "Make sure there are at least one of each entity type") { _ in
            XCTAssertGreaterThanOrEqual(try! self.count(type: .Subject), 1)
            XCTAssertGreaterThanOrEqual(try! self.count(type: .Radical), 1)
            XCTAssertGreaterThanOrEqual(try! self.count(type: .Kanji), 1)
            XCTAssertGreaterThanOrEqual(try! self.count(type: .Vocabulary), 1)
            XCTAssertGreaterThanOrEqual(try! self.count(type: .Translation), 1)
            XCTAssertGreaterThanOrEqual(try! self.count(type: .Reading), 1)
            XCTAssertGreaterThanOrEqual(try! self.count(type: .KanjiReading), 1)
            XCTAssertGreaterThanOrEqual(try! self.count(type: .VocabularyReading), 1)
        }

        XCTContext.runActivity(named: "call removeAllSequentially()") { _ in
            try! entityStoreFacade.removeAllSequentially()
        }

        XCTContext.runActivity(named: "After removeAllSequentially(), make sure there are no more entities") { _ in
            XCTAssertEqual(try! count(type: .Subject), 0)
            XCTAssertEqual(try! count(type: .Radical), 0)
            XCTAssertEqual(try! count(type: .Kanji), 0)
            XCTAssertEqual(try! count(type: .Vocabulary), 0)
            XCTAssertEqual(try! count(type: .Translation), 0)
            XCTAssertEqual(try! count(type: .Reading), 0)
            XCTAssertEqual(try! count(type: .KanjiReading), 0)
            XCTAssertEqual(try! count(type: .VocabularyReading), 0)
        }
    }
}
