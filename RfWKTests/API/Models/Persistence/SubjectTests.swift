//
//  SubjectTests.swift
//  RfWKTests
//
//  Created by Florian Nöhring on 01.12.19.
//  Copyright © 2019 Florian Nöhring. All rights reserved.
//

import XCTest
import CoreData
@testable import RfWK

class SubjectTests: XCTestCase {

    var stack: Stack!
    var context: NSManagedObjectContext!
    
    override func setUp() {
        stack = MemoryStack()
        context = stack.storeContainer.viewContext
    }

    func testTypeAndAttributes() {
        let subject = buildSubject()
        try! context.save()
        
        XCTAssert((subject as Any?) is Subject)
        
        XCTAssertEqual(subject.characters, "characters")
        XCTAssertEqual(subject.document_url, URL(string: "https://example.com/subject"))
        XCTAssertEqual(subject.id, 123)
        XCTAssertEqual(subject.level, 12)
        XCTAssertEqual(subject.meaning_hint, "meaning hint")
        XCTAssertEqual(subject.meaning_mnemonic, "meaning mnemonic")
        XCTAssertEqual(subject.reading_hint, "reading hint")
        XCTAssertEqual(subject.reading_mnemonic, "reading mnemonic")
        XCTAssertEqual(subject.slug, "slug")
    }

    func testFetchRequestAndAttributes() {
        _ = buildSubject()
        try! context.save()
        
        let fetchRequest: NSFetchRequest<Subject> = Subject.fetchRequest()
        
        let retrievedSubjects = try! context.fetch(fetchRequest)
        
        XCTAssertEqual(retrievedSubjects.count, 1)
        
        let subject = retrievedSubjects.first!
        
        XCTAssertEqual(subject.characters, "characters")
        XCTAssertEqual(subject.document_url, URL(string: "https://example.com/subject"))
        XCTAssertEqual(subject.id, 123)
        XCTAssertEqual(subject.level, 12)
        XCTAssertEqual(subject.meaning_hint, "meaning hint")
        XCTAssertEqual(subject.meaning_mnemonic, "meaning mnemonic")
        XCTAssertEqual(subject.reading_hint, "reading hint")
        XCTAssertEqual(subject.reading_mnemonic, "reading mnemonic")
        XCTAssertEqual(subject.slug, "slug")
    }
    
    func buildSubject() -> Subject {
        
        let entity = NSEntityDescription.entity(forEntityName: "Subject", in: context)!
        let result = Subject(entity: entity, insertInto: context)
        
        result.setValue("characters", forKey: "characters")
        result.setValue(URL(string: "https://example.com/subject"), forKey: "document_url")
        result.setValue("kanji", forKey: "object")
        result.setValue(123, forKey: "id")
        result.setValue(12, forKey: "level")
        result.setValue("meaning hint", forKey: "meaning_hint")
        result.setValue("meaning mnemonic", forKey: "meaning_mnemonic")
        result.setValue("reading hint", forKey: "reading_hint")
        result.setValue("reading mnemonic", forKey: "reading_mnemonic")
        result.setValue("slug", forKey: "slug")
        
        return result
    }
}
