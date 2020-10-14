//
//  Stack.swift
//  RfWK
//
//  Created by Florian Nöhring on 24.11.19.
//  Copyright © 2019 Florian Nöhring. All rights reserved.
//

import Foundation
import CoreData

class Stack {
    
    var fileName: String
    
    init() {
        self.fileName = Constants.sqliteFileName
    }
    
    init(fileName: String) {
        self.fileName = fileName
    }
    
    lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "RfWK")
        
        let description = persistentStoreDescription()
        container.persistentStoreDescriptions = [description]
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func persistentStoreDescription() -> NSPersistentStoreDescription {
        
        let urls = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)
        guard var url = urls.first else { fatalError("can't find \(#function)") }
        
        url.appendPathComponent(appName(), isDirectory: true)
        url.appendPathComponent(fileName)
        
        let description = NSPersistentStoreDescription(url: url)
        description.type = NSSQLiteStoreType
        
        return description
    }
    
    private func appName() -> String {
        return Bundle.main.infoDictionary!["CFBundleName"] as! String
    }
}
