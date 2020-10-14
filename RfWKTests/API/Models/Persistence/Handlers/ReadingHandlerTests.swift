//
//  ReadingHandlerTests.swift
//  RfWKTests
//
//  Created by Florian Nöhring on 30.12.19.
//  Copyright © 2019 Florian Nöhring. All rights reserved.
//

import XCTest
import CoreData
@testable import RfWK

class ReadingHandlerTests: XCTestCase {

    var stack:  Stack!
    var context:  NSManagedObjectContext!
    var handler: ReadingHandler<Reading>!
    
    override func setUp() {
        stack = MemoryStack()
        context = stack.storeContainer.viewContext
        handler = ReadingHandler<Reading>(context: context)!
    }

    func testFindOrCreateReturnsExistingReading() {
        let existingReading = handler.object(["reading": "あめ"])
        let result = try! handler.findOrCreateOne(by: ["reading": "あめ"])
        
        XCTAssertEqual(result, existingReading)
    }
    
    func testFindOrCreateReturnsNewReadingWithoutMatch() {
        XCTAssertNil(try! handler.findOne(by: ["reading": "い"]))
        let result = try! handler.findOrCreateOne(by: ["reading": "い"])

        XCTAssert((result as Any) is Reading)
        XCTAssertEqual(result.reading, "い")
    }
    
    
    func testObjectReturnsReading() {
        let result = handler.object()
        
        XCTAssert((result as Any?) is Reading)
    }
    
    func testFindOneReturnsExistingReading() {
        let existingReading = handler.object(["reading": "き"])
        let result = try! handler.findOne(by: ["reading": "き"])

        XCTAssertNotNil(result)
        XCTAssert((result as Any?) is Reading)
        XCTAssertEqual(result, existingReading)
    }
    
    // MARK: - function readingsWithoutSubjectReading
    
    func testReadingsWithoutSubjectReading() {
        let fixtures = Fixtures(context: context)
        
        let readingWithoutSubjectReading = handler.reading("ま")
        let kanjiReading = fixtures.kanjiReading()
        let readingWithSubjectReading = kanjiReading.reading!
        
        let result = try! handler.readingsWithoutSubjectReading()
        
        XCTAssert(result.contains(readingWithoutSubjectReading))
        XCTAssertFalse(result.contains(readingWithSubjectReading))
    }
}
