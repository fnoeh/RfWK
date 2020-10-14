//
//  SubjectsSingleRadical.swift
//  RfWKTests
//
//  Created by Florian Nöhring on 27.09.19.
//  Copyright © 2019 Florian Nöhring. All rights reserved.
//

import XCTest
@testable import RfWK

class WKSubjectsSingleKanjiTests: WKSubjectsTests {

    override func loadJson() {
        jsonString = JSONExamples.subjectsWithSingleKanji()
    }

    func testDecodeSingleKanji() {
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

        XCTAssertEqual(data.slug, "化")
        XCTAssertEqual(data.characters, "化")
        XCTAssertEqual(data.level, 6)

        let meanings = data.meanings
        XCTAssertEqual(meanings.count, 1)
        let meaning = meanings[0]

        XCTAssertEqual(meaning.meaning, "Change")
        XCTAssert(meaning.accepted_answer)
        XCTAssert(meaning.primary)

        XCTAssert(data.auxiliary_meanings.isEmpty)

        let readings = data.readings

        if let ka_reading = readings?.first(where: { $0.reading == "か" }) {
            XCTAssertEqual(ka_reading.type, "onyomi")
            XCTAssertEqual(ka_reading.reading, "か")
            XCTAssert(ka_reading.primary)
            XCTAssert(ka_reading.accepted_answer)
        } else {
            XCTFail("Expected WKReading missing from readings.")
        }

        if let ba_reading = readings?.first(where: { $0.reading == "ば" }) {
            XCTAssertEqual(ba_reading.type, "kunyomi")
            XCTAssertEqual(ba_reading.reading, "ば")
            XCTAssertFalse(ba_reading.primary)
            XCTAssertFalse(ba_reading.accepted_answer)
        } else {
            XCTFail("Expected WKReading missing from readings.")
        }
        
        XCTAssertEqual(data.component_subject_ids!.sorted(), [57, 75])
        
        XCTAssertEqual(
            data.amalgamation_subject_ids!.sorted(),
            [2846,3178,3467,3494,3749,3880,3926,3927,7063,7346,7998,8017,8706]
        )

        XCTAssertEqual(
            data.visually_similar_subject_ids!.sorted(),
            [517, 1088]
        )
        
        XCTAssertEqual(data.meaning_mnemonic, "Meaning mnemonic for change.")
        XCTAssertEqual(data.meaning_hint, "Meaning hint for change.")
        XCTAssertEqual(data.reading_mnemonic, "Reading mnemonic for change.")
        XCTAssertEqual(data.reading_hint, "Reading hint for change.")

        XCTAssertEqual(data.lesson_position, 10)
    }
}
