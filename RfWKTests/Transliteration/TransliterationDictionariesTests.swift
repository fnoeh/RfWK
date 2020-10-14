//
//  TransliterationDictionariesTests.swift
//  RfWKTests
//
//  Created by Florian Nöhring on 20.08.20.
//  Copyright © 2020 Florian Nöhring. All rights reserved.
//

import XCTest
@testable import RfWK

class TransliterationDictionariesTests: XCTestCase {

    var filePath: String!
    var transcriptions: TransliterationDictionaries!
    
    override func setUpWithError() throws {
        filePath = Bundle.main.path(forResource: "transliterations", ofType: "csv")
        transcriptions = try! TransliterationDictionaries(filePath: filePath)
    }
    
    func testItHas118RomajiMappings() {
        let dict = transcriptions.romajiDict
        XCTAssertEqual(dict.keys.count, 118)
    }
    
    func testItHas106HiraganaMappings() {
        let dict = transcriptions.hiraganaDict
        XCTAssertEqual(dict.keys.count, 106)
    }
    
    func testItHas106KatakanaMappings() {
        let dict = transcriptions.katakanaDict
        XCTAssertEqual(dict.keys.count, 106)
    }
}
