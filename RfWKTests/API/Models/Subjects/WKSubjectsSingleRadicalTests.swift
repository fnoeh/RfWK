//
//  SubjectsSingleRadical.swift
//  RfWKTests
//
//  Created by Florian Nöhring on 27.09.19.
//  Copyright © 2019 Florian Nöhring. All rights reserved.
//

import XCTest
@testable import RfWK

class WKSubjectsSingleRadicalTests: WKSubjectsTests {

    override func loadJson() {
        jsonString = JSONExamples.subjectsWithSingleRadical()
    }

    func testDecodeSingleRadical() {
        let subjects = decode()
        
        XCTAssertNotNil(subjects)
        XCTAssert((subjects as Any?) is WKSubjects)
    }
    
    func testSubjectData() {
        let subjects = decode()!
        
        XCTAssertEqual(subjects.data.count, 1)
        
        let subject = subjects.data[0]
        XCTAssert((subject as Any?) is WKSubject)
        
        let data = subject.data
        XCTAssert((data as Any?) is WKSubjectData)
        
        XCTAssertEqual(data.level, 3)
        XCTAssertEqual(data.slug, "spoon")
        XCTAssertNil(data.hidden_at)
        XCTAssertEqual(data.characters, "匕")
        
        let character_images = data.character_images
        XCTAssertNotNil(character_images)
        XCTAssertEqual(character_images!.count, 9)
        
        let meanings = data.meanings
        XCTAssertEqual(meanings.count, 1)
        let meaning = meanings[0]
        
        XCTAssertEqual(meaning.meaning, "Spoon")
        XCTAssert(meaning.primary)
        XCTAssert(meaning.accepted_answer)
        
        XCTAssert(data.auxiliary_meanings.isEmpty)
        
        XCTAssertEqual(
            data.amalgamation_subject_ids?.sorted(),
            [
                517,557,607,617,781,797,894,921,
                1414,1456,1672,1674,1863,1914,2014,
                2051,2063,2131,2329,2349,2405
            ]
        )
        
        XCTAssertEqual(data.meaning_mnemonic, "Meaning mnemonic for spoon.")
        XCTAssertNil(data.meaning_hint)
        XCTAssertNil(data.reading_mnemonic)
        XCTAssertNil(data.reading_hint)

        XCTAssertEqual(data.lesson_position, 11)
    }
}

