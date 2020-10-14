//
//  Character.swift
//  RfWK
//
//  Created by Florian Nöhring on 12.09.20.
//  Copyright © 2020 Florian Nöhring. All rights reserved.
//

import Foundation

extension Character {
    
    var canBeTransliteratedAsKana: Bool {
        guard self != "-" else { return true }
        
        let unicodeScalar = String(self).unicodeScalars.first!.value
        return  (0x61...0x7a).contains(unicodeScalar) // lowercase alphabet
             || (0x41...0x5a).contains(unicodeScalar) // uppercase alphabet
    }
}
