//
//  UserRequestTests.swift
//  RfWKTests
//
//  Created by Florian Nöhring on 15.10.19.
//  Copyright © 2019 Florian Nöhring. All rights reserved.
//

import XCTest
@testable import RfWK

class UserRequestTests: XCTestCase {

    let token = "abc123"
    
    func testUrlIsCorrect() {
        XCTAssertEqual(
            UserRequest(token: token).url.absoluteString,
            "https://api.wanikani.com/v2/user?"
        )
    }
    
    func testBaseParamsIsEmpty() {
        let result = UserRequest(token: token).baseParams()
        XCTAssert(result.isEmpty)
    }
    
    func testMethodIsGET() {
        XCTAssertEqual(
            UserRequest(token: token).method,
            WaniKaniAPIv2.HTTPMethod.GET
        )
    }
    
    class TestDelegate : RequestDelegate {
        var expectation: XCTestExpectation?

        init(expectation: XCTestExpectation? = nil) {
            self.expectation = expectation
        }
        
        func requestStarted(_ request: WaniKaniAPIv2) {}
        func requestFinished(_ request: WaniKaniAPIv2) {}
        func error(_ request: WaniKaniAPIv2, reason: String) {}
        func progress(_ value: Float) {}
    }
    
    func testHandleResponseWith401IsUnauthorized() {
        class TestDelegateUnauthorized : TestDelegate {
            override func requestFinished(_ request: WaniKaniAPIv2) {
                if request.outcome == .unauthorized && request.statusCode == 401 {
                    expectation?.fulfill()
                }
            }
        }

        let expectation = XCTestExpectation()
        let delegate = TestDelegateUnauthorized(expectation: expectation)
        let request = UserRequestMock(token: token, delegate: delegate)
        
        request.mock(response: """
            {
                "error": "Unauthorized. Nice try.",
                "code": 401
            }
        """, code: 401)
        request.initiate()
        
        self.wait(for: [expectation], timeout: 0.5)
    }
    
    func testHandleResponseWithoutStatusCodeIsError() {
        class TestDelegateNoStatus : TestDelegate {
            override func requestFinished(_ request: WaniKaniAPIv2) {
                if request.outcome == .error {
                    expectation?.fulfill()
                }
            }
        }
        
        let expectation = XCTestExpectation()
        let delegate = TestDelegateNoStatus(expectation: expectation)
        let request = UserRequestMock(token: token, delegate: delegate)
        
        request.mock(response: nil, code: nil)
        request.initiate()
        
        self.wait(for: [expectation], timeout: 0.5)
    }
    
    func testHandleResponseWithoutResponseIsError() {
        class TestDelegateNoStatus : TestDelegate {
            override func requestFinished(_ request: WaniKaniAPIv2) {
                if request.outcome == .error {
                    expectation?.fulfill()
                }
            }
        }
        
        let expectation = XCTestExpectation()
        let delegate = TestDelegateNoStatus(expectation: expectation)
        let request = UserRequestMock(token: token, delegate: delegate)
        
        request.mock(response: nil, code: 200)
        request.initiate()
        
        self.wait(for: [expectation], timeout: 0.5)
    }

    class TestDelegateJsonError : TestDelegate {
        override func requestFinished(_ request: WaniKaniAPIv2) {
            if request.outcome == .jsonError {
                expectation?.fulfill()
            }
        }
    }
    
    func testHandleResponseWithInvalidJsonIsJsonError() {
        let expectation = XCTestExpectation()
        let delegate = TestDelegateJsonError(expectation: expectation)
        let request = UserRequestMock(token: token, delegate: delegate)
        
        request.mock(response: "You shall not parse")
        request.initiate()
        
        self.wait(for: [expectation], timeout: 0.5)
    }
    
    func testHandleResponseWithWrongJsonIsJsonError() {
        let expectation = XCTestExpectation()
        let delegate = TestDelegateJsonError(expectation: expectation)
        let request = UserRequestMock(token: token, delegate: delegate)

        request.mock(response: """
            {"type":"json","but":"I'm not a User"}
        """)
        request.initiate()
        
        self.wait(for: [expectation], timeout: 0.5)
    }
    
    func testHandleResponseWithUserJson() {
        let userJson = JSONExamples.User
        let user = WKUser.from(json: userJson)!
        
        class TestDelegateUser : TestDelegate {
            let user: WKUser
            
            init(expectation: XCTestExpectation, expectedUser: WKUser) {
                self.user = expectedUser
                super.init(expectation: expectation)
            }
            
            override func requestFinished(_ request: WaniKaniAPIv2) {
                if let innerUser = request.result as? WKUser {
                    if request.outcome == .success && innerUser == self.user {
                        expectation?.fulfill()
                    }
                }
            }
        }
        
        let expectation = XCTestExpectation()
        let delegate = TestDelegateUser(expectation: expectation, expectedUser: user)
        let request = UserRequestMock(token: token, delegate: delegate)
        
        request.mock(response: userJson, code: 200)
        request.initiate()
        
        self.wait(for: [expectation], timeout: 0.5)
    }
}
