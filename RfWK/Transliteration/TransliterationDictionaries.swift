//
//  TransliterationDictionaries.swift
//  RfWK
//
//  Created by Florian Nöhring on 20.08.20.
//  Copyright © 2020 Florian Nöhring. All rights reserved.
//

import Foundation

class TransliterationDictionaries {
    struct RomajiDictEntry {
        var hiragana: String
        var katakana: String
    }
    struct HiraganaDictEntry {
        var romaji: String
        var katakana: String
    }
    struct KatakanaDictEntry {
        var romaji: String
        var hiragana: String
    }
    
    var romajiDict: Dictionary<String,RomajiDictEntry> = [:]
    var hiraganaDict: Dictionary<String,HiraganaDictEntry> = [:]
    var katakanaDict: Dictionary<String,KatakanaDictEntry> = [:]
    
    convenience init() throws {
        let path = Bundle.main.path(forResource: "transliterations", ofType: "csv")!
        try! self.init(filePath: path)
    }
    
    init(filePath: String) throws {
        do {
            try self.parse(filePath: filePath)
        } catch {
            throw error
        }
    }
    
    private func parse(filePath: String) throws {
        do {
            let content: String = try String(contentsOfFile: filePath, encoding: .utf8)
            let lines = content.split() { $0 == "\n" }.map { String($0) }
            
            for line in lines {
                if line == "Romaji;Hiragana;Katakana;Romaji only?" {
                    continue
                }
                
                let values = line.split() { $0 == ";" }.map { String($0) }
                
                let romaji = values[0]
                let hiragana = values[1]
                let katakana = values[2]
                let romajiOnly = values[3] == "1"
                
                self.romajiDict[romaji] = RomajiDictEntry(hiragana: hiragana, katakana: katakana)
                if !romajiOnly {
                    self.hiraganaDict[hiragana] = HiraganaDictEntry(romaji: romaji, katakana: katakana)
                    self.katakanaDict[katakana] = KatakanaDictEntry(romaji: romaji, hiragana: hiragana)
                }
            }
        } catch {
            throw error
        }
    }
}
