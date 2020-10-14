//
//  SubjectsSingleRadical.swift
//  RfWKTests
//
//  Created by Florian Nöhring on 27.09.19.
//  Copyright © 2019 Florian Nöhring. All rights reserved.
//

import XCTest
@testable import RfWK

class WKSubjectsSingleVocabularyTests: WKSubjectsTests {

    override func loadJson() {
        jsonString = JSONExamples.subjectsWithSingleVocabulary()
    }

    func testDecodeSingleVocabulary() {
        let subjects = decode()
        
        XCTAssertNotNil(subjects)
        XCTAssert((subjects as Any?) is WKSubjects)
    }
    
    func testSubjectData() {
        let subjects = decode()!
        
        XCTAssertEqual(subjects.data.count, 1)
        
        let subject = subjects.data[0]
        
        XCTAssertEqual(subject.id, 2854)
        
        let data = subject.data
        XCTAssert((data as Any?) is WKSubjectData)
        
        XCTAssertEqual(data.level, 6)
        
        XCTAssertEqual(data.slug, "全て")
        XCTAssertNil(data.hidden_at)
        XCTAssertEqual(data.characters, "全て")
        
        let meanings = data.meanings
        XCTAssertEqual(meanings.count, 2)
        
        let meaning_all = meanings[0], meaning_entire = meanings[1]
        
        XCTAssertEqual(meaning_all.meaning, "All")
        XCTAssert(meaning_all.primary)
        XCTAssert(meaning_all.accepted_answer)
        
        XCTAssertEqual(meaning_entire.meaning, "Entire")
        XCTAssertFalse(meaning_entire.primary)
        XCTAssert(meaning_entire.accepted_answer)
        
        XCTAssert(data.auxiliary_meanings.isEmpty)
        
        XCTAssertEqual(data.readings!.count, 1)
        let reading = data.readings![0]
        
        XCTAssertEqual(reading.reading, "すべて")
        XCTAssert(reading.primary)
        XCTAssert(reading.accepted_answer)
        
        XCTAssertEqual(data.parts_of_speech!.count, 2)
        
        XCTAssert(data.parts_of_speech!.contains("の adjective"))
        XCTAssert(data.parts_of_speech!.contains("noun"))
        
        XCTAssertEqual(data.component_subject_ids!, [610])
        
        XCTAssertEqual(data.meaning_mnemonic, "Meaning mnemonic for all.")
        XCTAssertEqual(data.reading_mnemonic, "Reading mnemonic for all.")
        
        XCTAssertNil(data.meaning_hint)
        XCTAssertNil(data.reading_hint)
        
        let context_sentences = data.context_sentences!
        
        XCTAssertEqual(context_sentences.count, 1)
        
        let first_context_sentence = context_sentences[0]
        
        XCTAssertEqual(first_context_sentence["en"], "Example sentence in English.")
        XCTAssertEqual(first_context_sentence["ja"], "Example sentence in Japanese.")
        
        let audios = data.pronunciation_audios!
        XCTAssertEqual(audios.count, 4)
        
        let first_audio = audios[0]
        
        XCTAssertEqual(first_audio.url, "https://cdn.wanikani.com/audios/39536-subject-2854.mp3?1553791112")
        XCTAssertEqual(first_audio.metadata.gender, "female")
        XCTAssertEqual(first_audio.metadata.source_id, 27446)
        XCTAssertEqual(first_audio.metadata.pronunciation, "すべて")
        XCTAssertEqual(first_audio.metadata.voice_actor_id, 1)
        XCTAssertEqual(first_audio.metadata.voice_actor_name, "Kyoko")
        XCTAssertEqual(first_audio.metadata.voice_description, "Tokyo accent")
        XCTAssertEqual(first_audio.content_type, "audio/mpeg")

        XCTAssertEqual(data.lesson_position, 24)
    }
}
