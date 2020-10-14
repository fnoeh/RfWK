//
//  EntityStoreFacadeTests.swift
//  RfWKTests
//
//  Created by Florian Nöhring on 24.04.20.
//  Copyright © 2020 Florian Nöhring. All rights reserved.
//

import XCTest
import CoreData
@testable import RfWK

class EntityStoreFacadeTests: XCTestCase {

    var stack: Stack!
    var context: NSManagedObjectContext!
    var entityStoreFacade: EntityStoreFacade!
    
    var handler: KanjiReadingHandler<KanjiReading>!
    var modelEntityConverter: ModelEntityConverter!
    
    
    func buildStack() -> Stack {
        preconditionFailure("Abstract method, must be overridden.")
    }
    
    
    override func setUp() {
        stack = buildStack()
        context = stack.storeContainer.viewContext
        entityStoreFacade = EntityStoreFacade(context: context)
        modelEntityConverter = ModelEntityConverter(context: context)
    }
    
    enum EntityType: String {
        case Subject
        case Radical
        case Kanji
        case Vocabulary
        case Translation
        case Reading
        case KanjiReading
        case VocabularyReading
    }
    
    func count(type entityType: EntityType) throws -> Int {
        do {
            let result = try context.count(for: NSFetchRequest(entityName: entityType.rawValue))
            return result
        } catch {
            throw error
        }
    }
    
    func createSubject() {
        _ = Handler<Subject>(context: context)!.object()
    }
    
    func createRadical() {
        _ = Handler<Radical>(context: context)!.object()
    }
    
    func createKanji() -> Kanji {
        return Handler<Kanji>(context: context)!.object()
    }
    
    func createVocabulary() {
        _ = Handler<Vocabulary>(context: context)!.object()
    }
    
    func createTranslation() {
        _ = Handler<Translation>(context: context)!.object(["meaning":"meaning"])
    }
    
    func createReading() -> Reading {
        return Handler<Reading>(context: context)!.object(["reading":"reading"])
    }
    
    func createKanjiReading() {
        let reading = createReading()
        let kanji = createKanji()
        _ = KanjiReadingHandler<KanjiReading>(context: context)!.kanjiReading(reading: reading, type: .onyomi, kanji: kanji, primary: true)
    }
    
    func createVocabularyReading() {
        _ = Handler<VocabularyReading>(context: context)!.object()
    }
}
