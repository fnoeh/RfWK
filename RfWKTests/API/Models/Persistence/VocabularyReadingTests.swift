//
//  VocabularyReading.swift
//  RfWKTests
//
//  Created by Florian Nöhring on 03.12.19.
//  Copyright © 2019 Florian Nöhring. All rights reserved.
//

import XCTest
import CoreData
@testable import RfWK

class VocabularyReadingTests: XCTestCase {

    var stack: Stack!
    var context: NSManagedObjectContext!
    var handler: Handler<VocabularyReading>!
    var fixtures: Fixtures!
    
    override func setUp() {
        stack = MemoryStack()
        context = stack.storeContainer.viewContext
        handler = Handler<VocabularyReading>(context: context)
        fixtures = Fixtures(context: context)
    }

    func testTypeAndAttributes() {
        let vocabReading = fixtures.vocabularyReading()
        XCTAssert((vocabReading as Any?) is VocabularyReading)
        
        let reading = vocabReading.reading
        XCTAssert((reading as Any?) is Reading)

        let vocabulary = vocabReading.vocabulary
        XCTAssert((vocabulary as Any?) is Vocabulary)
    }

    func testFetchRequest() {
        _ = fixtures.vocabularyReading()
        
        try! context.save()
        
        let fetchRequest: NSFetchRequest<VocabularyReading> = VocabularyReading.fetchRequest()
        let result: [VocabularyReading] = try! context.fetch(fetchRequest)
        
        XCTAssertEqual(result.count, 1)
        
        let vocabReading = result.first!
        
        XCTAssert((vocabReading as Any?) is VocabularyReading)
    }
}
