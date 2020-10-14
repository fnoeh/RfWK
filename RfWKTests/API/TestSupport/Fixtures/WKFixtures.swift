//
//  WKFixtures.swift
//  RfWKTests
//
//  Created by Florian Nöhring on 28.12.19.
//  Copyright © 2019 Florian Nöhring. All rights reserved.
//

import Foundation
@testable import RfWK

class WKFixtures {
    
    let decoder = WaniKaniJSONDecoder()
    
    func user() -> WKUser {
        let jsonString = JSONExamples.User
        let result: WKUser = try! decode(jsonString)
        return result
    }
    
    func user(level: Int) -> WKUser {
        var user = self.user()
        user.data.level = level
        return user
    }
    
    func radical() -> WKSubject {
        let jsonString = JSONExamples.singleRadical()
        let result: WKSubject = try! decode(jsonString)
        return result
    }
    
    func kanji() -> WKSubject {
        let jsonString = JSONExamples.singleKanji()
        let result: WKSubject = try! decode(jsonString)
        return result
    }

    func vocabulary() -> WKSubject {
        let jsonString = JSONExamples.singleVocabulary()
        let result: WKSubject = try! decode(jsonString)
        return result
    }

    func readingWithType() -> WKReading {
        let jsonString = JSONExamples.singleReadingWithKunyomiType()
        let result: WKReading = try! decode(jsonString)
        return result
    }
    
    func readingWithoutType() -> WKReading {
        let jsonString = JSONExamples.singleReadingWithoutType()
        let result: WKReading = try! decode(jsonString)
        return result
    }
    
    enum AcceptedAnswer {
        case accepted
        case notAccepted
    }
    
    func meaning(acceptance: AcceptedAnswer) -> WKMeaning {
        let jsonString: String
            
        switch acceptance {
        case .accepted:
            jsonString = JSONExamples.singleMeaningAccepted()
        case .notAccepted:
            jsonString = JSONExamples.singleMeaningNotAccepted()
        }
        
        let result: WKMeaning = try! decode(jsonString)
        return result
    }
    
    enum AuxiliaryMeaningType {
        case whitelist
        case blacklist
    }
    
    func auxiliaryMeaning(type: AuxiliaryMeaningType) -> WKAuxiliaryMeaning {
        let jsonString: String
        
        switch type {
        case .whitelist:
            jsonString = JSONExamples.singleWhitelistedAuxiliaryMeaning()
        case .blacklist:
            jsonString = JSONExamples.singleBlacklistedAuxiliaryMeaning()
        }
        let result: WKAuxiliaryMeaning = try! decode(jsonString)
        return result
    }
    
    private func decode<T: Decodable>(_ json: String) throws -> T {
        let jsonData = json.data(using: .utf8)!
        let result: T = try decoder.decode(T.self, from: jsonData)
        return result
    }
}
