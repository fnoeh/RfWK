//
//  KanjiReadingExtension.swift
//  RfWK
//
//  Created by Florian Nöhring on 03.05.20.
//  Copyright © 2020 Florian Nöhring. All rights reserved.
//

import Foundation

extension KanjiReading {
    func displayableReading() -> String {
        guard self.reading != nil else { return "" }
        
        if self.type == "onyomi" {
            // TODO: remove    ! and    !
            return self.reading!.reading!.hiraganaAsKatakana
        } else {
            return self.reading!.reading!
        }
    }
}
