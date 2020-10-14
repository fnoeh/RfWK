//
//  SubjectExtensionTests.swift
//  RfWKTests
//
//  Created by Florian Nöhring on 06.06.20.
//  Copyright © 2020 Florian Nöhring. All rights reserved.
//

import XCTest
import CoreData
@testable import RfWK

class SubjectExtensionTests: XCTestCase {

    var stack: Stack!
    var context: NSManagedObjectContext!
    var fixtures: Fixtures!
    
    override func setUpWithError() throws {
        stack = MemoryStack()
        context = stack.storeContainer.viewContext
        fixtures = Fixtures(context: context)
    }

    func testTranslations() throws {
        let subject = fixtures.kanji()
        let translation1 = fixtures.translation()
        let translation2 = fixtures.translation()
        _ = fixtures.subjectTranslation(subject: subject, translation: translation1)
        _ = fixtures.subjectTranslation(subject: subject, translation: translation2)
        
        let result = subject.translations()
        XCTAssertEqual(result.count, 2)
        XCTAssert(result.contains(translation1))
        XCTAssert(result.contains(translation2))
    }
}
