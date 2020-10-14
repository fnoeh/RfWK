//
//  KanjiExtensionTests.swift
//  RfWKTests
//
//  Created by Florian Nöhring on 02.05.20.
//  Copyright © 2020 Florian Nöhring. All rights reserved.
//

import XCTest
import CoreData
@testable import RfWK

class KanjiExtensionTests: XCTestCase {

    var kanji: Kanji!
    var kanjiHandler: SubjectHandler<Kanji>!
    
    var stack: Stack!
    var context: NSManagedObjectContext!
    
    override func setUpWithError() throws {
        stack = MemoryStack()
        context = stack.storeContainer.viewContext
        kanjiHandler = SubjectHandler<Kanji>(context: context)!
    }

    // MARK: - function readingsByType()
    
    func testReadingsByTypeIsEmptyForKanjiWithoutReadings() throws {
        let kanji = kanjiHandler.object()
        
        let result = kanji.readingsByType()
        
        XCTAssert(result.isEmpty)
        XCTAssertEqual(result, [:])
    }
    
    private func prepareKanjiAndResult(kanji: Kanji, closure: (Kanji)->()) -> Dictionary<KanjiReadingType, [KanjiReading]> {
        closure(kanji)
        let result = kanji.readingsByType()
        
        return result
    }
    
    func testReadingsByTypeWithOnyomiReading() {
        let kanji = kanjiHandler.object()
        let kanjiReadingHandler = KanjiReadingHandler<KanjiReading>(context: context)!
        let fixtures = Fixtures(context: context)
        
        _ = kanjiReadingHandler.kanjiReading(reading: fixtures.reading(), type: .onyomi, kanji: kanji, primary: true)
        let result = kanji.readingsByType()
        
        XCTAssertFalse(result.isEmpty)
        XCTAssert(result.keys.contains(KanjiReadingType.onyomi))
        
        XCTAssertFalse(result.keys.contains(KanjiReadingType.kunyomi))
        XCTAssertFalse(result.keys.contains(KanjiReadingType.nanori))
    }
    
    func testReadingsByTypeWithKunyomiAndOnyomiAndNanoriReadings() {
        let kanji = kanjiHandler.object()
        let readingHandler = ReadingHandler<Reading>(context: context)!
        let on = readingHandler.reading("まい")
        let kun1 = readingHandler.reading("おう")
        let kun2 = readingHandler.reading("つ")
        let nanori = readingHandler.reading("あ")
        
        let kanjiReadingHandler = KanjiReadingHandler<KanjiReading>(context: context)!
        
        let onReading   = kanjiReadingHandler.kanjiReading(reading: on, type: .onyomi, kanji: kanji, primary: true)
        let kun1Reading = kanjiReadingHandler.kanjiReading(reading: kun1, type: .kunyomi, kanji: kanji, primary: true)
        let kun2Reading = kanjiReadingHandler.kanjiReading(reading: kun2, type: .kunyomi, kanji: kanji, primary: true)
        let nanoriReading = kanjiReadingHandler.kanjiReading(reading: nanori, type: .nanori, kanji: kanji, primary: true)
        
        kanji.addToReadings(onReading)
        kanji.addToReadings(kun1Reading)
        kanji.addToReadings(kun2Reading)
        kanji.addToReadings(nanoriReading)

        let result = kanji.readingsByType()
        let keys = result.keys
        
        XCTAssert(keys.contains(KanjiReadingType.onyomi))
        XCTAssert(keys.contains(KanjiReadingType.kunyomi))
        XCTAssert(keys.contains(KanjiReadingType.nanori))
        
        XCTAssert(result[.onyomi]!.contains(onReading))
        
        XCTAssert(result[.kunyomi]!.contains(kun1Reading))
        XCTAssert(result[.kunyomi]!.contains(kun2Reading))
        
        XCTAssert(result[.nanori]!.contains(nanoriReading))
    }
}
