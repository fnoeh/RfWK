//
//  KanjiReadingHandler.swift
//  RfWK
//
//  Created by Florian Nöhring on 28.05.20.
//  Copyright © 2020 Florian Nöhring. All rights reserved.
//

import Foundation
import CoreData

class KanjiReadingHandler<T: KanjiReading> : Handler<T> {
    lazy var kanjiReadingEntity = NSEntityDescription.entity(forEntityName: "KanjiReading", in: self.context)!
        
    func kanjiReading(reading: Reading,
                      type: KanjiReadingType,
                      kanji: Kanji,
                      primary: Bool) -> KanjiReading {
        let result = NSManagedObject.init(entity: kanjiReadingEntity, insertInto: context) as! KanjiReading

        result.reading = reading
        result.type = "\(type)"
        result.kanji = kanji
        result.primary = primary

        return result
    }
}
