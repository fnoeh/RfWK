//
//  SubjectsTests.swift
//  RfWKTests
//
//  Created by Florian Nöhring on 22.09.19.
//  Copyright © 2019 Florian Nöhring. All rights reserved.
//

import XCTest
@testable import RfWK

class WKSubjectsTests: XCTestCase {

    var jsonString: String!
    var decoder: JSONDecoder!
    
    override func setUp() {
        loadJson()
        
        decoder = JSONDecoder.wanikani()
    }
    
    func loadJson() {
        // Override by loading correct json, e. g. jsonString = JSONExamples.singleKanji()
    }

    func decode() -> WKSubjects? {
        if let data = jsonString.data(using: .utf8) {
            let subjects = try? decoder.decode(WKSubjects.self, from: data)
            
            return subjects
        } else {
            fatalError("Could not create data from json.")
        }
    }
}
