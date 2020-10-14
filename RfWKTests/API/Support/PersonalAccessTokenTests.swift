//
//  PersonalAccessTokenTests.swift
//  RfWKTests
//
//  Created by Florian Nöhring on 07.09.19.
//  Copyright © 2019 Florian Nöhring. All rights reserved.
//

import XCTest
@testable import RfWK

class PersonalAccessTokenTests: XCTestCase {
    
    let validToken: String = "5BE13497-BEDE-4394-ACCC-EDC63C510C36"
    let invalidToken: String = "123456789"
    let oldToken: String = "9304d4163c6f9a65baba70ea481ca983"
    
    func testBuildWithValidToken() {
        let subject: ValidPersonalAccessToken? = ValidPersonalAccessToken.build(validToken)

        XCTAssertNotNil(subject)
        XCTAssertEqual(subject!.value, validToken)
    }

    func testBuildWithValidTokenWithAdditionalWhitespace() {
        let param = " \(validToken) \n"
        let subject = ValidPersonalAccessToken.build(param)

        XCTAssertNotNil(subject)
        XCTAssertEqual(subject!.value, validToken)
    }


    func testBuildWithInvalidToken() {
        let subject = ValidPersonalAccessToken.build(invalidToken)

        XCTAssertNil(subject)
    }

    func testBuildWithOldToken() {
        let subject = ValidPersonalAccessToken.build(oldToken)

        XCTAssertNil(subject)
    }
}
