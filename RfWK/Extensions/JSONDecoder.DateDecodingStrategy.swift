//
//  JSONDecoder.DateDecodingStrategy.swift
//  RfWK
//
//  Created by Florian Nöhring on 15.09.19.
//  Copyright © 2019 Florian Nöhring. All rights reserved.
//

import Foundation

extension JSONDecoder.DateDecodingStrategy {
    static let fractionalISO8601 = custom {
        let container = try $0.singleValueContainer()
        let string = try container.decode(String.self)
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        guard let date = formatter.date(from: string) else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid date: " + string)
        }
        
        return date
    }
}
