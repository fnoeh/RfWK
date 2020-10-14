//
//  JSONExamples.swift
//  RfWKTests
//
//  Created by Florian Nöhring on 18.09.19.
//  Copyright © 2019 Florian Nöhring. All rights reserved.
//

import Foundation

class JSONExamples {

    static let User = fileContent("user")
    static let Subjects = fileContent("subjects_single_radical")
    
    static func singleRadical() -> String {
        return fileContent("single_radical")
    }
    
    static func singleKanji() -> String {
        return fileContent("single_kanji")
    }
    
    static func singleVocabulary() -> String {
        return fileContent("single_vocabulary")
    }
    
    static func singleReadingWithKunyomiType() -> String {
        return fileContent("single_kanji_reading")
    }
    
    static func singleReadingWithoutType() -> String {
        return fileContent("single_vocabulary_reading")
    }
    
    static func subjectsWithSingleRadical() -> String {
        return fileContent("subjects_single_radical")
    }
    
    static func subjectsWithSingleKanji() -> String {
        return fileContent("subjects_single_kanji")
    }
    
    static func subjectsWithSingleVocabulary() -> String {
        return fileContent("subjects_single_vocabulary")
    }
    
    static func singleMeaningAccepted() -> String {
        return fileContent("single_meaning_accepted")
    }
    
    static func singleMeaningNotAccepted() -> String {
        return fileContent("single_meaning_not_accepted")
    }
    
    static func singleWhitelistedAuxiliaryMeaning() -> String {
        return fileContent("single_whitelisted_auxiliary_meaning")
    }
    
    static func singleBlacklistedAuxiliaryMeaning() -> String {
        return fileContent("single_blacklisted_auxiliary_meaning")
    }
    
    static func fileContent(_ name: String) -> String {
        let bundle = Bundle(for: JSONExamples.self)
        let path = bundle.url(forResource: name, withExtension: "json")
        
        do {
            let json = try String(contentsOf: path!)
            return json
        } catch {
            fatalError("Could not read content from file \(name).json.")
        }
    }
}
