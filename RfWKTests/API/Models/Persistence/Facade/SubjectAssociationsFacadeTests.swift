//
//  SubjectAssociationsFacadeTests.swift
//  RfWKTests
//
//  Created by Florian Nöhring on 30.12.19.
//  Copyright © 2019 Florian Nöhring. All rights reserved.
//

import XCTest
import CoreData
@testable import RfWK

class SubjectAssociationsFacadeTests: XCTestCase {

    var stack: Stack!
    var context: NSManagedObjectContext!
    var facade: SubjectAssociationsFacade!
    
    override func setUp() {
        stack = MemoryStack()
        context = stack.storeContainer.viewContext
        facade = SubjectAssociationsFacade(context: context, progressDelegate: nil)
    }
    
    // MARK: - function buildAndAssociate
    
    func testBuildAndAssociateCreatesAllInvolvedObjectsAndMakesCorrectAssociations() {
        let wkSubject: WKSubject = WKFixtures().vocabulary()
        let input: [WKSubject] = [wkSubject]
        
        try! facade.buildAndAssociate(wkSubjects: input)

        let retrievedSubjects: [Subject] = try! context.fetch(Subject.fetchRequest() as NSFetchRequest<Subject>)

        XCTAssertEqual(retrievedSubjects.count, 1) // only 全て in this fixture
        if let subject = retrievedSubjects.first as? Vocabulary {
            XCTAssertEqual(subject.slug, "全て")
            XCTAssertEqual(subject.level, 6)
            
            // there's only one reading, it's associated with subject
            XCTAssertEqual(try! context.count(for: NSFetchRequest<Reading>(entityName: "Reading")), 1)
            let subjectReadings = subject.readings!
            let vocabularyReadings = subjectReadings.allObjects as! [VocabularyReading]
            XCTAssertEqual(vocabularyReadings.count, 1)
            
            let vocabularyReading = vocabularyReadings.first!
            let reading = vocabularyReading.reading!
            
            XCTAssert((reading as Any?) is Reading)
            XCTAssertEqual(reading.reading, "すべて")
            
            // there are exactly two meanings: All and Entire
            XCTAssertEqual(try! context.count(for: NSFetchRequest<Translation>(entityName: "Translation")), 2)
            
            let subjectTranslations = subject.subjectTranslations!.allObjects as! [SubjectTranslation]
            XCTAssertEqual(subjectTranslations.count, 2)
            
            let associatedMeanings = subjectTranslations.map { $0.translation!.meaning! }.sorted()
            XCTAssertEqual(associatedMeanings, ["All", "Entire"])
        }
    }
}
