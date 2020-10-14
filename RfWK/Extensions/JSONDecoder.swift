//
//  JSONDecoder.swift
//  RfWK
//
//  Created by Florian Nöhring on 18.09.19.
//  Copyright © 2019 Florian Nöhring. All rights reserved.
//

import Foundation

extension JSONDecoder {
    static func wanikani() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .fractionalISO8601
        return decoder
    }
}
