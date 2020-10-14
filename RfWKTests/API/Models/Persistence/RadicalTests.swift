//
//  RadicalTests.swift
//  RfWKTests
//
//  Created by Florian Nöhring on 15.12.19.
//  Copyright © 2019 Florian Nöhring. All rights reserved.
//

import XCTest
import CoreData
@testable import RfWK

class RadicalTests: XCTestCase {

    var stack: Stack!
    var context: NSManagedObjectContext!
    var handler: SubjectHandler<Radical>!
    lazy var fixtures = Fixtures(context: context)
    
    override func setUp() {
        stack = MemoryStack()
        context = stack.storeContainer.viewContext
        handler = SubjectHandler<Radical>(context: context)
    }

    func testTypeAndAttributes() {
        let radical = handler.object([
            "characters": "rad",
            "document_url": URL(string: "http://url")!,
            "id": 12,
            "level": 3,
            "meaning_hint": "mhint",
            "meaning_mnemonic": "mmnem",
            "reading_hint": "rhint",
            "reading_mnemonic": "rmnem",
            "slug": "slug"
        ])
        
        
        XCTAssert((radical as Any?) is Subject)
        XCTAssert((radical as Any?) is Radical)
        
        XCTAssertEqual(radical.characters, "rad")
        XCTAssertEqual(radical.document_url, URL(string: "http://url"))
        XCTAssertEqual(radical.id, 12)
        XCTAssertEqual(radical.level, 3)
        XCTAssertEqual(radical.meaning_hint, "mhint")
        XCTAssertEqual(radical.meaning_mnemonic, "mmnem")
        XCTAssertEqual(radical.reading_hint, "rhint")
        XCTAssertEqual(radical.reading_mnemonic, "rmnem")
        XCTAssertEqual(radical.slug, "slug")
    }
    
    func testFetchRequest() {
        let radical = fixtures.radical()
        try! context.save()
        
        let fetchRequest: NSFetchRequest<Radical> = Radical.fetchRequest()
        
        let result: [Radical] = try! context.fetch(fetchRequest)
        
        XCTAssertEqual(result.count, 1)
        
        let retrievedRadical = result.first!
        
        XCTAssertEqual(retrievedRadical, radical)
    }
}
