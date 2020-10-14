//
//  WaniKaniJSONDecoder.swift
//  RfWK
//
//  Created by Florian Nöhring on 16.10.19.
//  Copyright © 2019 Florian Nöhring. All rights reserved.
//

import Foundation

class WaniKaniJSONDecoder : JSONDecoder {
    
    override init() {
        super.init()
        self.dateDecodingStrategy = .fractionalISO8601
    }
}
