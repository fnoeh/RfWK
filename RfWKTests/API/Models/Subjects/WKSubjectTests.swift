//
//  WKSubjectTests.swift
//  RfWKTests
//
//  Created by Florian Nöhring on 30.12.19.
//  Copyright © 2019 Florian Nöhring. All rights reserved.
//

import XCTest
@testable import RfWK

class WKSubjectTests: XCTestCase {

    let jsonDecoder = WaniKaniJSONDecoder()
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    func testReadingsOnRadicalReturnsNil() {
        let jsonString = JSONExamples.singleRadical()
        let radical = try! jsonDecoder.decode(WKSubject.self, from: jsonString.data(using: .utf8)!)
                
        let result = radical.data.readings
        XCTAssertNil(result)
    }
}
