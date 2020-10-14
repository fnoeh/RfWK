//
//  RomajiToKanaTransliteration.swift
//  RfWK
//
//  Created by Florian Nöhring on 30.08.20.
//  Copyright © 2020 Florian Nöhring. All rights reserved.
//

import Foundation

class RomajiToKanaTransliteration {
    let input: String
    var output: String = ""
    private var remainingInput: String
    static let dictionaries = try! TransliterationDictionaries()
    static var romajiDict: Dictionary<String,TransliterationDictionaries.RomajiDictEntry> = {
        return dictionaries.romajiDict
    }()
    
    init(input: String) {
        self.input = input
        self.remainingInput = input
        
        while hasMore() {
            let chars = nextChars()
            let nextStep = self.nextStep(nextChars: chars)
            
            switch nextStep.step {
            case .smallTsu:
                smallTsu(chars)
            case .skipOne:
                skipOne(chars)
            case .transliterateOne:
                transferChunk(nextStep.replacement!, noOfCharsToRemove: 1)
            case .transliterateTwo:
                transferChunk(nextStep.replacement!, noOfCharsToRemove: 2)
            case .transliterateThree:
                transferChunk(nextStep.replacement!, noOfCharsToRemove: 3)
            }
        }
    }

    struct NextChars {
        var c1: Character
        var c2: Character?
        var c3: Character?
        
        var one: String {
            get {
                return String(c1)
            }
        }
        
        var two: String {
            get {
                return String([c1, c2!])
            }
        }
        
        var three: String {
            get {
                return String([c1, c2!, c3!])
            }
        }
    }
    
    struct NextStep {
        enum Step {
            case smallTsu
            case skipOne
            case transliterateOne
            case transliterateTwo
            case transliterateThree
        }
        
        var step: Step
        var replacement: String?
        
        static func smallTsu() -> NextStep {
            return NextStep(step: .smallTsu, replacement: nil)
        }
        
        static func skipOne() -> NextStep {
            return NextStep(step: .skipOne, replacement: nil)
        }
        
        static func transliterateOne(_ replacement: String) -> NextStep {
            return NextStep(step: .transliterateOne, replacement: replacement)
        }
        
        static func transliterateTwo(_ replacement: String) -> NextStep {
            return NextStep(step: .transliterateTwo, replacement: replacement)
        }
        
        static func transliterateThree(_ replacement: String) -> NextStep {
            return NextStep(step: .transliterateThree, replacement: replacement)
        }
    }
    
    func smallTsu(_ chars: NextChars ) {
        output.append( chars.two.isUppercase ? "ッ" : "っ" )
        remainingInput.removeFirst()
    }
    
    func skipOne(_ chars: NextChars) {
        output.append(chars.c1)
        remainingInput.removeFirst()
    }
    
    func transferChunk(_ chunk: String, noOfCharsToRemove: Int) {
        output.append(chunk)
        remainingInput.removeFirst(noOfCharsToRemove)
    }
    
    func hasMore() -> Bool {
        return remainingInput.count > 0
    }
    
    func nextChars() -> NextChars {
        let startIndex = remainingInput.startIndex
        
        var result = NextChars(
            c1: remainingInput[startIndex]
        )
        
        if remainingInput.count > 1 {
            result.c2 = remainingInput[remainingInput.index(startIndex, offsetBy: 1)]
            
            if remainingInput.count > 2 {
                result.c3 = remainingInput[remainingInput.index(startIndex, offsetBy: 2)]
            }
        }
        
        return result
    }
    
    func nextStep(nextChars chars: NextChars) -> NextStep {
        // [c1] [c2] [c3] […] […] […]
        
        guard chars.c1.canBeTransliteratedAsKana else { return NextStep.skipOne() }
        
        let dictionary = RomajiToKanaTransliteration.romajiDict
        
        if chars.c2?.canBeTransliteratedAsKana ?? false {
            // c1 and c2 are both indivually transliteratable, but maybe not when combined, e. g. ai
            if chars.c1 == chars.c2 && !["a", "e", "i", "o", "u"].contains(chars.c1) && chars.c1 != "n" {
                return NextStep.smallTsu()
            }

            if chars.c3?.canBeTransliteratedAsKana ?? false {
                // c1, c2, c3 are all indivually transliteratable, but maybe not combined, e. g. ani.
                if let replacementString = replacement(romaji: chars.three, dictionary: dictionary) {
                    return NextStep.transliterateThree(replacementString)
                }
            }
            
            // c1 and c2 are each indivually transliteratable, but maybe not combined. c3 is not or nil
            if let replacementString = replacement(romaji: chars.two, dictionary: dictionary) {
                return NextStep.transliterateTwo(replacementString)
            }
        }
        
        // c2 is not a transliteratable char but c1 is
        if let replacementString = replacement(romaji: chars.one, dictionary: dictionary) {
            return NextStep.transliterateOne(replacementString)
        } else {
            return NextStep.skipOne()
        }
    }
    
    func replacement(romaji: String, dictionary: Dictionary<String, TransliterationDictionaries.RomajiDictEntry>) -> String? {
        if let entry = dictionary[romaji.lowercased()] {
            return romaji.isUppercase ? entry.katakana : entry.hiragana
        }
        
        return nil
    }
}
