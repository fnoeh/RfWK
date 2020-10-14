//
//  UnnamedProtococol.swift
//  RfWK
//
//  Created by Florian Nöhring on 19.10.19.
//  Copyright © 2019 Florian Nöhring. All rights reserved.
//

import Foundation

protocol UserRequestDelegate {
    func requestStarted()
    func requestFinished()
    func error(reason: String)
}
