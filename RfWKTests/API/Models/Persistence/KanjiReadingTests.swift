//
//  KanjiReadingTests.swift
//  RfWKTests
//
//  Created by Florian Nöhring on 01.12.19.
//  Copyright © 2019 Florian Nöhring. All rights reserved.
//

import XCTest
import CoreData
@testable import RfWK

class KanjiReadingTests: XCTestCase {

    var stack: Stack!
    var context: NSManagedObjectContext!
    var handler: KanjiReadingHandler<KanjiReading>!
    var fixtures: Fixtures!
    
    override func setUp() {
        stack = MemoryStack()
        context = stack.storeContainer.viewContext
        handler = KanjiReadingHandler<KanjiReading>(context: context)
        fixtures = Fixtures(context: context)
    }

    func testOnyomiReading() {
        let reading = fixtures.kanjiReading(type: .onyomi)
        XCTAssertEqual(reading.type, "onyomi")
    }

    func testKunyomiReading() {
        let reading = fixtures.kanjiReading(type: .kunyomi)
        XCTAssertEqual(reading.type, "kunyomi")
    }

    func testNanoriReading() {
        let reading = fixtures.kanjiReading(type: .nanori)
        XCTAssertEqual(reading.type, "nanori")
    }
    
    func testTypeAndAttributes() {
        let reading = fixtures.kanjiReading(type: .onyomi)
        
        XCTAssert((reading as Any?) is KanjiReading)
        XCTAssert((reading.reading as Any?) is Reading)
        XCTAssert((reading.kanji as Any?) is Kanji)
    }

    func testFetchRequestRetrievesSavedKanjiReading() {
        let kanjiReading = fixtures.kanjiReading()
        try! context.save()
        
        let fetchRequest: NSFetchRequest<KanjiReading> = KanjiReading.fetchRequest()
        
        let retrievedKanjiReadings: [KanjiReading] = try! context.fetch(fetchRequest)
        
        XCTAssertEqual(retrievedKanjiReadings.count, 1)
        XCTAssert(retrievedKanjiReadings.contains(kanjiReading))
    }
    
    func testKanjiReadingFetchRequestDoesNotRetrieveReading() {
        let readingEntity = NSEntityDescription.entity(forEntityName: "Reading", in: context)!
        let managedObject = NSManagedObject.init(entity: readingEntity, insertInto: context)
        
        managedObject.setValue("てがみ", forKey: "reading")
        
        try! context.save()
        
        let fetchRequest: NSFetchRequest<KanjiReading>  = KanjiReading.fetchRequest()
        
        let retrievedKanjiReadings: [KanjiReading] = try! context.fetch(fetchRequest)
        
        XCTAssertEqual(retrievedKanjiReadings.count, 0)
    }
}
