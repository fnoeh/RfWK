//
//  VocabularyExtensionTests.swift
//  RfWKTests
//
//  Created by Florian Nöhring on 12.06.20.
//  Copyright © 2020 Florian Nöhring. All rights reserved.
//

import XCTest
import CoreData
@testable import RfWK

class VocabularyExtensionTests: XCTestCase {

    var stack: Stack!
    var context: NSManagedObjectContext!
    var fixtures: Fixtures!
    
    override func setUpWithError() throws {
        stack = MemoryStack()
        context = stack.storeContainer.viewContext
        fixtures = Fixtures(context: context)
    }

    func testAssociatedReadings() throws {
        let vocabulary = fixtures.vocabulary()
        let reading = fixtures.reading()
        
        _ = fixtures.vocabularyReading(vocabulary: vocabulary,
                                       reading: reading)
        
        let result = try! vocabulary.associatedReadings()
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first, reading)
    }
}
