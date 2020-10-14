//
//  SubjectsRequestDelegate.swift
//  RfWK
//
//  Created by Florian Nöhring on 12.11.19.
//  Copyright © 2019 Florian Nöhring. All rights reserved.
//

import Foundation

protocol SubjectsRequestDelegate {
    func requestStarted()
    func requestFinished()
    func requestFailed(reason: String)
}
