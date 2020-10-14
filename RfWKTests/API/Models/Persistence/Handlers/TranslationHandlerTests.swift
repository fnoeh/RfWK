//
//  TranslationHandlerTests.swift
//  RfWKTests
//
//  Created by Florian Nöhring on 16.12.19.
//  Copyright © 2019 Florian Nöhring. All rights reserved.
//

import XCTest
import CoreData
@testable import RfWK

class TranslationHandlerTests: XCTestCase {

    var stack: Stack!
    var context: NSManagedObjectContext!
    var handler: TranslationHandler<Translation>!
    
    override func setUp() {
        stack = MemoryStack()
        context = stack.storeContainer.viewContext
        handler = TranslationHandler(context: context)
    }

    // MARK: - function object()
    
    func testObjectReturnsTranslation() {
        let object = handler.object()
        
        XCTAssert((object as Any?) is Translation)
    }
    
    // MARK: - function translationsWithoutSubjectTranslation()
    
    func testTranslationsWithoutSubjectTranslation() {
        let fixtures = Fixtures(context: context)
        let translationWithoutSubjectTranslation = handler.object()
        let subject = fixtures.kanji()
        let translation = fixtures.translation()
        _ = fixtures.subjectTranslation(subject: subject, translation: translation)
        
        let result = try! handler.translationsWithoutSubjectTranslation()
        
        XCTAssert(result.contains(translationWithoutSubjectTranslation))
        XCTAssertFalse(result.contains(translation))
    }
}
