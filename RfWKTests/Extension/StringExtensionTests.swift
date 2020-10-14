//
//  StringExtensionTests.swift
//  RfWKTests
//
//  Created by Florian Nöhring on 30.08.20.
//  Copyright © 2020 Florian Nöhring. All rights reserved.
//

import XCTest
@testable import RfWK

class StringExtensionTests: XCTestCase {
    override func setUp() {
    }
    
    // MARK: - katakanaAsHiragana

    func testKatakanaAsHiraganaWithEmptyString() {
        XCTAssertEqual("".katakanaAsHiragana, "")
    }
    
    func testKatakanaAsHiraganaWithRomaji() {
        XCTAssertEqual("Sushi".katakanaAsHiragana, "Sushi")
    }
    
    func testKatakanaAsHiraganaWithKanji() {
        XCTAssertEqual("日本".katakanaAsHiragana, "日本")
    }
    
    func testKatakanaAsHiraganaWithKatakana() {
        XCTAssertEqual("マイ".katakanaAsHiragana, "まい")
    }
    
    func testKatakanaAsHiraganaWithMixedInput() {
        XCTAssertEqual("aびょメ人1".katakanaAsHiragana, "aびょめ人1")
    }
    
    // MARK: - hiraganaAsKatakana
    
    func testHiraganaAsKatakanaWithEmptyString() {
        XCTAssertEqual("".hiraganaAsKatakana, "")
    }
    
    func testHiraganaAsKatakanaWithKatakana() {
        XCTAssertEqual("ドイツ".hiraganaAsKatakana, "ドイツ")
    }
    
    func testHiraganaAsKatakanaWithKanji() {
        XCTAssertEqual("日本".hiraganaAsKatakana, "日本")
    }
    
    func testHiraganaAsKatakanaWithHiragana() {
        XCTAssertEqual("いま".hiraganaAsKatakana, "イマ")
    }
 
    func testHiraganaAsKatakanaWithMixedInput() {
        XCTAssertEqual("aびょメ人1".hiraganaAsKatakana, "aビョメ人1")
    }
}
