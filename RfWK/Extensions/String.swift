//
//  String.swift
//  RfWK
//
//  Created by Florian Nöhring on 08.09.19.
//  Copyright © 2019 Florian Nöhring. All rights reserved.
//

import Foundation

extension String {
    func matches(_ regex: String) -> Bool {
        return self.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
        
    var katakanaAsHiragana: String {
        return self.applyingTransform(StringTransform.hiraganaToKatakana, reverse: true)!
    }
    
    var hiraganaAsKatakana: String {
        return self.applyingTransform(StringTransform.hiraganaToKatakana, reverse: false)!
    }
    
    var isUppercase: Bool {
        return self.allSatisfy({ $0.isUppercase })
    }
}
