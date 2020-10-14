//
//  Shared.swift
//  RfWK
//
//  Created by Florian Nöhring on 22.09.19.
//  Copyright © 2019 Florian Nöhring. All rights reserved.
//

import Foundation

struct WKPages : Codable, Equatable {
    var per_page: Int
    var next_url: String?
    var previous_url: String?
}
