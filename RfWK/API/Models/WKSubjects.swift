//
//  Subjects.swift
//  RfWK
//
//  Created by Florian Nöhring on 22.09.19.
//  Copyright © 2019 Florian Nöhring. All rights reserved.
//

import Foundation

struct WKSubjects : Codable, Equatable {
    var object: String
    var url: String
    var pages: WKPages
    var total_count: Int
    var data_updated_at: Date
    var data: [WKSubject]
    
    static var decoder: JSONDecoder {
        get {
            return WaniKaniJSONDecoder()
        }
    }
    
    static func from(json: String?) -> WKSubjects? {
        guard json != nil else { return nil }
        
        let jsonData = json!.data(using: .utf8)!
        let subjects: WKSubjects? = try? self.decoder.decode(WKSubjects.self, from: jsonData)
        return subjects
    }
    
    var hasMore: Bool {
        get {
            pages.next_url != nil
        }
    }
}

struct WKSubject : Codable, Equatable {
    var id: Int
    var object: String
    var url: String
    var data_updated_at: Date
    var data: WKSubjectData
}

struct WKSubjectData : Codable, Equatable {
    // SubjectData can represent either a Radical, Kanji or Vocabulary
    
    // common attributes
    var auxiliary_meanings: [WKAuxiliaryMeaning]
    var created_at: Date
    var document_url: String
    var hidden_at: Date?
    var lesson_position: Int
    var level: Int
    var meanings: [WKMeaning]
    var slug: String
    
    // The following attributes’ presence depends on the represented type.
    // Attributes are marked as existent (+), non-existent (-) or optional (±)
    var characters: String?                             // Radical: ± | Kanji: + | Vocabulary: +
    var amalgamation_subject_ids: [Int]?                // Radical: + | Kanji: + | Vocabulary: -
    var character_images: [WKCharacterImage]?             // Radical: + | Kanji: - | Vocabulary: -
    var component_subject_ids: [Int]?                   // Radical: - | Kanji: + | Vocabulary: +
    var visually_similar_subject_ids: [Int]?            // Radical: - | Kanji: + | Vocabulary: -
    var readings: [WKReading]?                            // Radical: - | Kanji: + | Vocabulary: +
    var parts_of_speech: [String]?                      // Radical: - | Kanji: - | Vocabulary: +
    var context_sentences: [Dictionary<String,String>]? // Radical: - | Kanji: - | Vocabulary: +
    var pronunciation_audios: [WKPronunciationAudio]?     // Radical: - | Kanji: - | Vocabulary: +
    
    var reading_mnemonic: String?   // Radical: - | Kanji: - | Vocabulary: +
    var reading_hint: String?       // Radical: ± | Kanji: ± | Vocabulary: ±
    var meaning_mnemonic: String?   // Radical: ± | Kanji: ± | Vocabulary: ±
    var meaning_hint: String?       // Radical: ± | Kanji: ± | Vocabulary: ±
}

struct WKCharacterImage : Codable, Equatable {
    var url: String
    var content_type: String
    
    // Currently metadata will be ignored. Reason being that it contains various attributes of unknown types. This will not be decodable by Swift out-of-the-box. Some types are boolean which is not covered by the type String nor something like Any?
    // var metadata: Dictionary<String,String>
}

struct WKMeaning : Codable, Equatable {
    var meaning: String
    var primary: Bool
    var accepted_answer: Bool
}

struct WKAuxiliaryMeaning : Codable, Equatable {
    var type: String
    var meaning: String
}

struct WKReading : Codable, Equatable {
    var type: String?   // One of [kunyomi, onyomi, nanori] iff it's Kanji, null in case of Vocabulary
    var primary: Bool
    var reading: String
    var accepted_answer: Bool
}

struct WKPronunciationAudio : Codable, Equatable {
    var url: String
    var metadata: WKPronunciationAudioMetadata
    var content_type: String
}

struct WKPronunciationAudioMetadata : Codable, Equatable {
    var gender: String
    var source_id: Int
    var pronunciation: String
    var voice_actor_id: Int
    var voice_actor_name: String
    var voice_description: String
}
