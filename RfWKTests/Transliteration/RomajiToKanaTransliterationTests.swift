//
//  RomajiToKanaTransliterationTests.swift
//  RfWKTests
//
//  Created by Florian Nöhring on 30.08.20.
//  Copyright © 2020 Florian Nöhring. All rights reserved.
//

import XCTest
@testable import RfWK

class RomajiToKanaTransliterationTests: XCTestCase {

    var transliteration: RomajiToKanaTransliteration!
    
    // MARK: - empty string input
    
    func testEmptyString() {
        transliteration = RomajiToKanaTransliteration(input: "")
        let result = transliteration.output
        XCTAssertEqual(result, "")
    }
    
    // MARK: - romaji of different lengths
    
    func testA() {
        transliteration = RomajiToKanaTransliteration(input: "a")
        let result = transliteration.output
        XCTAssertEqual(result, "あ")
    }
    
    func testAo() {
        XCTAssertEqual(RomajiToKanaTransliteration(input: "ao").output, "あお")
    }
    
    func testSushi() {
        transliteration = RomajiToKanaTransliteration(input: "Sushi")
        let result = transliteration.output
        XCTAssertEqual(result, "すし")
    }
    
    func testArigatou() {
        XCTAssertEqual(RomajiToKanaTransliteration(input: "arigatou").output, "ありがとう")
        XCTAssertEqual(RomajiToKanaTransliteration(input: "あrigatou").output, "ありがとう")
        XCTAssertEqual(RomajiToKanaTransliteration(input: "ありgatou").output, "ありがとう")
        XCTAssertEqual(RomajiToKanaTransliteration(input: "ありがtou").output, "ありがとう")
        XCTAssertEqual(RomajiToKanaTransliteration(input: "ありがとu").output, "ありがとう")
    }
    
    func testDou() {
        XCTAssertEqual(RomajiToKanaTransliteration(input: "Dou").output, "どう")
    }
    
    func testNi() {
        XCTAssertEqual(RomajiToKanaTransliteration(input: "Ni").output, "に")
    }
    
    func testBlank() {
        XCTAssertEqual(RomajiToKanaTransliteration(input: " ").output, " ")
    }
    
    func test123() {
        XCTAssertEqual(RomajiToKanaTransliteration(input: "123").output, "123")
    }
    
    func testNihon() {
        XCTAssertEqual(RomajiToKanaTransliteration(input: "Nihon").output, "にほん")
    }
    
    func testNIHON() {
        XCTAssertEqual(RomajiToKanaTransliteration(input: "NIHON").output, "ニホン")
    }
    
    func testNippon() {
        XCTAssertEqual(RomajiToKanaTransliteration(input: "NIPPON").output, "ニッポン")
    }
    
    func testTekken() {
        XCTAssertEqual(RomajiToKanaTransliteration(input: "tekken").output, "てっけん")
    }
    
    func testGenki() {
        XCTAssertEqual(RomajiToKanaTransliteration(input: "Genki").output, "げんき")
    }
    
    func testGennki() {
        XCTAssertEqual(RomajiToKanaTransliteration(input: "Gennki").output, "げんき")
    }
    
    func testNingyou() {
        XCTAssertEqual(RomajiToKanaTransliteration(input: "Ningyou").output, "にんぎょう")
    }
    
    func testAMerIKA() {
        XCTAssertEqual(RomajiToKanaTransliteration(input: "AMerIKA").output, "アめりカ")
    }
    
    func testTest() {
        XCTAssertEqual(RomajiToKanaTransliteration(input: "Test").output, "てst")
    }
    
    func testほんしゅう() {
        XCTAssertEqual(RomajiToKanaTransliteration(input: "ほんしゅう").output, "ほんしゅう")
    }
    
    func test町() {
        XCTAssertEqual(RomajiToKanaTransliteration(input: "町").output, "町")
    }
    
    func test日本語() {
        XCTAssertEqual(RomajiToKanaTransliteration(input: "日本語").output, "日本語")
    }
    
}
