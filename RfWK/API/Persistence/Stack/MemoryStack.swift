//
//  MemoryStack.swift
//  RfWK
//
//  Created by Florian Nöhring on 24.11.19.
//  Copyright © 2019 Florian Nöhring. All rights reserved.
//

import Foundation
import CoreData

class MemoryStack : Stack {
    
    override init() {
        super.init(fileName: Constants.sqliteTestFileName)
    }
    
    override func persistentStoreDescription() -> NSPersistentStoreDescription {
        let description = NSPersistentStoreDescription()
        
        description.type = NSInMemoryStoreType
        
        return description
    }
}
