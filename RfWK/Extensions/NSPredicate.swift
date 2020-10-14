//
//  NSPredicate.swift
//  RfWK
//
//  Created by Florian Nöhring on 31.12.19.
//  Copyright © 2019 Florian Nöhring. All rights reserved.
//

import Foundation

extension NSPredicate {
    
    convenience init?(_ keyValues: Dictionary<String,Any>?) {
        guard keyValues != nil && !keyValues!.isEmpty else { return nil }
        
        let format: String = keyValues!.keys.map { (key) -> String in return "\(key) = %@"}.joined(separator: " and ")
        let arguments = Array(keyValues!.values)
        
        self.init(format: format, argumentArray: arguments)
    }
}
