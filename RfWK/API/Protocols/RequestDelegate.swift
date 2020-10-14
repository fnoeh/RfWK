//
//  RequestDelegate.swift
//  RfWK
//
//  Created by Florian Nöhring on 14.11.19.
//  Copyright © 2019 Florian Nöhring. All rights reserved.
//

import Foundation

protocol RequestDelegate {
    func requestStarted(_ request: WaniKaniAPIv2)
    func requestFinished(_ request: WaniKaniAPIv2)
    func error(_ request: WaniKaniAPIv2, reason: String)
    func progress(_ value: Float)
}
