//
//  TranslationTests.swift
//  RfWKTests
//
//  Created by Florian Nöhring on 02.12.19.
//  Copyright © 2019 Florian Nöhring. All rights reserved.
//

import XCTest
import CoreData
@testable import RfWK

class TranslationTests: XCTestCase {

    var stack: Stack!
    var context: NSManagedObjectContext!
    var handler: TranslationHandler<Translation>!
    
    override func setUp() {
        stack = MemoryStack()
        context = stack.storeContainer.viewContext
        handler = TranslationHandler(context: context)
    }
    
    func testTypeAndAttributes() {
        let translation = handler.object(["meaning": "meaning"])
        try! context.save()
        
        XCTAssertEqual(translation.meaning, "meaning")
    }
    
    func testFetchRequest() {
        _ = handler.object(["meaning": "River"])
        try! context.save()
        
        let fetchRequest: NSFetchRequest<Translation> = Translation.fetchRequest()
        
        let result: [Translation] = try! context.fetch(fetchRequest)
        
        XCTAssertEqual(result.count, 1)
        
        let translation = result.first!
        
        XCTAssert((translation as Any?) is Translation)
        XCTAssertEqual(translation.meaning, "River")
    }
    
    func testTwoTranslationsWithSameMeaningAreNotIdentical() {
        let t1 = handler.object(["meaning": "hello"])
        let t2 = handler.object(["meaning": "hello"])
        
        XCTAssertNotEqual(t1, t2)
    }
    
    func testFetchRequestWithPredicateFilter() {
        let white = handler.object(["meaning": "white"])
        let black = handler.object(["meaning": "black"])
        
        let fetchRequest: NSFetchRequest<Translation> = Translation.fetchRequest()
        let predicate = NSPredicate(format: "meaning = %@", "white")
        fetchRequest.predicate = predicate
        
        let result = try! context.fetch(fetchRequest)
        
        XCTAssertEqual(result.count, 1)
        XCTAssert(result.contains(white))
        XCTAssertFalse(result.contains(black))
    }
}
