//
//  Handler.swift
//  RfWK
//
//  Created by Florian Nöhring on 22.12.19.
//  Copyright © 2019 Florian Nöhring. All rights reserved.
//

import Foundation
import CoreData

class Handler<T: NSManagedObject> {

    var entity: NSEntityDescription
    var context: NSManagedObjectContext

    init?(context: NSManagedObjectContext) {
        self.context = context

        let entityString = String(describing: T.self)
        if let entityDescription = NSEntityDescription.entity(forEntityName: entityString, in: context) {
            self.entity = entityDescription
        } else {
            return nil
        }
    }
    
    func object() -> T {
        return NSManagedObject(entity: self.entity, insertInto: self.context) as! T
    }
    
    func object(_ values: Dictionary<String,Any>) -> T {
        let result = NSManagedObject(entity: self.entity, insertInto: self.context) as! T
        
        for (key, value) in values {
            result.setValue(value, forKey: key)
        }
        
        return result
    }
    
    func findOne(by values: Dictionary<String,Any>? = nil, closure: (() -> T?)? = nil) throws -> T? {
        let fetchRequest = NSFetchRequest<T>(entityName: String(describing: T.self))

        if let predicate = NSPredicate(values) {
            fetchRequest.predicate = predicate
        }

        do {
            fetchRequest.fetchLimit = 1
            let result: [T] = try context.fetch(fetchRequest)
            
            return result.first ?? closure?()
        } catch let error as NSError {
            print("Error in Handler.findOne - \(error), \(error.userInfo)")
            throw error
        }
    }
    
    func findOrCreateOne(by values: Dictionary<String,Any>) throws -> T {
        if let existing: T = try findOne(by: values) {
            return existing
        } else {
            let newlyCreated = object(values)
            return newlyCreated
        }
    }
    
    func all(sortDescriptors: [NSSortDescriptor] = []) throws -> [T] {
        do {
            let fetchRequest = T.fetchRequest()
            fetchRequest.sortDescriptors = sortDescriptors
            
            let result: [T] = try context.fetch(fetchRequest) as! [T]
            return result
        } catch {
            throw error
        }
    }
    
    func random(predicate: NSPredicate?) throws -> T? {
        let fetchRequest = NSFetchRequest<T>(entityName: String(describing: T.self))
        
        if predicate != nil {
            fetchRequest.predicate = predicate
        }

        do {
            let totalCount = try context.count(for: fetchRequest)
            if totalCount > 0 {
                
                fetchRequest.fetchOffset = Int.random(in: 0..<totalCount)
                fetchRequest.fetchLimit = 1
                
                let fetchResult = try context.fetch(fetchRequest)
                return fetchResult.first
            }
            
            return nil
        } catch {
            throw error
        }

    }
}
