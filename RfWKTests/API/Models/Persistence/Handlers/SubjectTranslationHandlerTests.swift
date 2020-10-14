//
//  SubjectTranslationHandlerTests.swift
//  RfWKTests
//
//  Created by Florian Nöhring on 02.06.20.
//  Copyright © 2020 Florian Nöhring. All rights reserved.
//

import XCTest
import CoreData
@testable import RfWK

class SubjectTranslationHandlerTests: XCTestCase {

    var context: NSManagedObjectContext!
    var handler: SubjectTranslationHandler<SubjectTranslation>!
    var fixtures: Fixtures!
    
    override func setUpWithError() throws {
        context = MemoryStack().storeContainer.viewContext
        handler = SubjectTranslationHandler<SubjectTranslation>(context: context)!
        fixtures = Fixtures(context: context)
    }

    func testFindOneByReturnsExistingSubjectTranslation() throws {
        let radical = fixtures.radical()
        let translation = fixtures.translation()
        
        let existingSubjectTranslation = handler.object(["subject": radical, "translation": translation])
        let result = try! handler.findOne(by: ["subject": radical, "translation": translation])
        
        XCTAssertNotNil(result)
        XCTAssert((result as Any?) is SubjectTranslation)
        XCTAssertEqual(result, existingSubjectTranslation)
    }
    
    func testRandomSubjectTranslationWithExclusionOfTranslationsByID() throws {
        let vocabularyFromExcludedTranslation = fixtures.vocabulary()
        let excludedTranslation = fixtures.translation()
        _ = fixtures.subjectTranslation(subject: vocabularyFromExcludedTranslation, translation: excludedTranslation)
        
        let subjectTranslation = fixtures.subjectTranslation(subject: fixtures.vocabulary(),
                                                             translation: fixtures.translation())
        
        let exclusionList = Set<Translation>(arrayLiteral: excludedTranslation)
        let predicate = NSPredicate(format: "self.subject.object = %@ AND NOT (self.translation IN %@)", "vocabulary", exclusionList)
        
        let result = try! handler.random(predicate: predicate)
        XCTAssertNotNil(result)
        XCTAssertEqual(result, subjectTranslation)
    }
}
