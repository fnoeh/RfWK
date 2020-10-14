//
//  NSManagedObjectTests.swift
//  RfWKTests
//
//  Created by Florian Nöhring on 24.11.19.
//  Copyright © 2019 Florian Nöhring. All rights reserved.
//

import XCTest
import CoreData
@testable import RfWK

class NSManagedObjectTests: XCTestCase {

    var stack: Stack!
    var entity: NSEntityDescription!
    var context: NSManagedObjectContext!

    override func setUp() {
        stack = MemoryStack()
        context = stack.storeContainer.viewContext
        entity = NSEntityDescription.entity(forEntityName: "Translation", in: context)
    }

    override func tearDown() {
        entity = nil
        context = nil
        stack = nil
    }

    func testAttributes() {
        let managedObject: NSManagedObject = NSManagedObject(entity: entity, insertInto: context)
        
        XCTAssert((managedObject as Any) is Translation)
        
        let meaning = "the meaning"
        managedObject.setValue(meaning, forKey: "meaning")
        XCTAssertEqual(managedObject.value(forKey: "meaning") as! String, meaning)
    }
    
    func testEmptyFetchRequest() {
        let fetchRequest: NSFetchRequest<Translation> = NSFetchRequest.init(entityName: "Translation")

        var result: [NSManagedObject]? = nil
        
        XCTAssertNoThrow(result = try context.fetch(fetchRequest))
        XCTAssertEqual(result?.count, 0)
    }
    
    func testSaveAndRetrieve() {
        let managedObject: NSManagedObject = NSManagedObject(entity: entity, insertInto: context)
        
        managedObject.setValue("meaning", forKey: "meaning")
        XCTAssertNoThrow(try context.save())
        
        let fetchRequest: NSFetchRequest<Translation> = NSFetchRequest.init(entityName: "Translation")
        var result: [NSManagedObject]? = nil
        
        XCTAssertNoThrow(result = try context.fetch(fetchRequest))
        // result = try! context.fetch(fetchRequest)
        
        XCTAssertEqual(result?.count, 1)
        
        let retrievedObject = result!.first
        let retrievedMeaning = retrievedObject?.value(forKey: "meaning") as! String
        XCTAssertEqual(retrievedMeaning, "meaning")
    }
    
    func testFetchRequestFindsUnsavedObjects() {
        let managedObject = NSManagedObject(entity: entity, insertInto: context)
        managedObject.setValue("meaning", forKey: "meaning")
        
        let fetchRequest: NSFetchRequest<Translation> = NSFetchRequest.init(entityName: "Translation")
        let result: [NSManagedObject] = try! context.fetch(fetchRequest)
        
        XCTAssertEqual(result.count, 1)
        XCTAssert(result.contains(managedObject))
    }
}
