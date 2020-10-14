//
//  KanjiExtension.swift
//  RfWK
//
//  Created by Florian Nöhring on 02.05.20.
//  Copyright © 2020 Florian Nöhring. All rights reserved.
//

import Foundation

extension Kanji {
    
    func readingsByType() -> Dictionary<KanjiReadingType, [KanjiReading]> {
        let result: Dictionary<KanjiReadingType, [KanjiReading]>
        
        if let readingsSet = self.readings, let allReadings = readingsSet.allObjects as? [KanjiReading] {
            result = Dictionary(
                grouping: (allReadings),
                by: { KanjiReadingType(rawValue: $0.type!)! }
            )
        } else {
            result = [:]
        }
        
        return result
    }
}
