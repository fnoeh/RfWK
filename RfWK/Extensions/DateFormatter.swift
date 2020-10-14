//
//  DateFormatter.swift
//  RfWK
//
//  Created by Florian Nöhring on 15.09.19.
//  Copyright © 2019 Florian Nöhring. All rights reserved.
//

import Foundation

extension DateFormatter {
    convenience init(format: String) {
        self.init()
        self.dateFormat = format
    }
}
