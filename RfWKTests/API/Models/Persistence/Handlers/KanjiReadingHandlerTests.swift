//
//  KanjiReadingHandlerTests.swift
//  RfWKTests
//
//  Created by Florian Nöhring on 28.05.20.
//  Copyright © 2020 Florian Nöhring. All rights reserved.
//

import XCTest
import CoreData
@testable import RfWK

class KanjiReadingHandlerTests: XCTestCase {

    var stack: Stack!
    var context: NSManagedObjectContext!
    var handler: KanjiReadingHandler<KanjiReading>!
    
    override func setUpWithError() throws {
        stack = MemoryStack()
        context = stack.storeContainer.viewContext
        handler = KanjiReadingHandler<KanjiReading>(context: context)!
    }

    func testFindOneWithAssociatedModelsReturnsJoinModel() {
        let fixtures = Fixtures(context: context)
        let kanjiReading = fixtures.kanjiReading(type: .onyomi)
        let reading = kanjiReading.reading!
        let kanji = kanjiReading.kanji!
        
        let result = try! handler.findOne(by: ["reading": reading, "kanji": kanji])
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result, kanjiReading)
    }
}
