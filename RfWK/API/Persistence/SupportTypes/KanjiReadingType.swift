//
//  KanjiReadingType.swift
//  RfWK
//
//  Created by Florian Nöhring on 01.12.19.
//  Copyright © 2019 Florian Nöhring. All rights reserved.
//

import Foundation

enum KanjiReadingType : String, CustomStringConvertible {
    case onyomi
    case kunyomi
    case nanori
    
    var description: String {
        switch self {
        case .onyomi:
            return "onyomi"
        case .kunyomi:
            return "kunyomi"
        case .nanori:
            return "nanori"
        }
    }
}
