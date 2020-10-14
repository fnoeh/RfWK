//
//  SubjectsTests.swift
//  RfWKTests
//
//  Created by Florian Nöhring on 15.10.19.
//  Copyright © 2019 Florian Nöhring. All rights reserved.
//

import XCTest
@testable import RfWK

class SubjectsRequestTests: XCTestCase {

    let token = "abc123"
    
    func testUrlIsCorrect() {
        XCTAssertEqual(
            SubjectsRequestMock(token: token, delegate: TestDelegate(), levels: 11...15).url.absoluteString,
            "https://api.wanikani.com/v2/subjects?levels=11,12,13,14,15&types=kanji,vocabulary"
        )
    }
    
    func testBaseParamsContainsLevels() {
        XCTAssertEqual(
            SubjectsRequestMock(token: token, levels: 11...15).baseParams(),
            ["levels": "11,12,13,14,15", "types": "kanji,vocabulary"]
        )
    }
    
    func testMethodIsGET() {
        XCTAssertEqual(
            UserRequestMock(token: token).method,
            WaniKaniAPIv2.HTTPMethod.GET
        )
    }
    
    class TestDelegate : RequestDelegate {
        var expectation: XCTestExpectation?
        var request: SubjectsRequest?
        
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
        
        let request = SubjectsRequestMock(token: token, delegate: delegate, levels: 11...15)
        request.statusCode = 401
        
        request.initiate()
        request.handleResponse()
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
        let request = SubjectsRequestMock(token: token, delegate: delegate, levels: 11...15)
        request.statusCode = nil
        
        request.initiate()
        request.handleResponse()
        self.wait(for: [expectation], timeout: 0.5)
    }
    
    func testHandleResponseWithoutResponseIsError() {
        class TestDelegateNoResponse : TestDelegate {
            override func requestFinished(_ request: WaniKaniAPIv2) {
                if request.outcome == .error {
                    expectation?.fulfill()
                }
            }
        }
        
        let expectation = XCTestExpectation()
        let delegate = TestDelegateNoResponse(expectation: expectation)
        let request = SubjectsRequestMock(token: token, delegate: delegate, levels: 11...15)
        request.statusCode = 200 // Status 200 but no response here
        
        request.initiate()
        request.handleResponse()
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
        let request = SubjectsRequestMock(token: token, delegate: delegate, levels: 11...15)

        request.mock(response: "not json")
        request.initiate()

        self.wait(for: [expectation], timeout: 0.5)
    }
    
    class TestDelegateWithSubjectsJson : TestDelegate {
        let expectedSubjects: [WKSubject]
        
        init(expectation: XCTestExpectation, expectedSubjects: [WKSubject]) {
            self.expectedSubjects = expectedSubjects
            super.init(expectation: expectation)
        }
        
        override func requestFinished(_ request: WaniKaniAPIv2) {
            if let innerSubjects = request.result as? [WKSubject] {
                if request.outcome == .success && innerSubjects == expectedSubjects {
                    self.expectation?.fulfill()
                } else {
                    // self.expectation.
                }
            }
        }
    }
    
    func testHandleResponseJsonWithSingleKanji() {
        let jsonString = JSONExamples.subjectsWithSingleKanji()
        let subjectsWithSingleKanji =  WKSubjects.from(json: jsonString)!
        let subjects = subjectsWithSingleKanji.data
        
        let expectation = XCTestExpectation()
        let delegate = TestDelegateWithSubjectsJson(expectation: expectation, expectedSubjects: subjects)
        let request = SubjectsRequestMock(token: token, delegate: delegate, levels: 11...15)
        
        request.mock(response: jsonString, code: 200)
        request.initiate()
        
        self.wait(for: [expectation], timeout: 0.5)
    }
    
    
    func testHandleResponseWithFollowupPageMakesAdditionalRequests() {
        let page1Response = JSONExamples.fileContent("subjects_page_1")
        let page2Response = JSONExamples.fileContent("subjects_page_2")
        let page3Response = JSONExamples.fileContent("subjects_page_3")
        
        let expect2ndRequest = XCTestExpectation(description: "2nd request is made to correct URL")
        let expect3rdRequest = XCTestExpectation(description: "3rd request is made to correct URL")
        let expectSuccessIsCalled = XCTestExpectation(description: "success() is called eventually")
        
        class FollowUpRequest : SubjectsRequestMock {
            var expect2ndRequest: XCTestExpectation?
            var expect3rdRequest: XCTestExpectation?
            var expectSuccessIsCalled: XCTestExpectation?
            
            override func success() {
                expectSuccessIsCalled?.fulfill()
            }
            
            override func initiate(to targetURL: URL? = nil) {
                if targetURL?.absoluteString == "https://api.wanikani.com/v2/subjects?levels=4&page_after_id=2632" {
                    expect2ndRequest?.fulfill()
                } else if targetURL?.absoluteString == "https://api.wanikani.com/v2/subjects?levels=4&page_after_id=2635" {
                    expect3rdRequest?.fulfill()
                }
                
                super.initiate(to: targetURL)
            }
        }
        
        let request = FollowUpRequest(token: token, levels: 11...15)
        request.expect2ndRequest = expect2ndRequest
        request.expect3rdRequest = expect3rdRequest
        request.expectSuccessIsCalled = expectSuccessIsCalled
        
        request.mock(response: page1Response, code: 200)
        request.mock(response: page2Response, code: 200)
        request.mock(response: page3Response, code: 200)
        
        request.initiate()
        
        self.wait(for: [expect2ndRequest, expect3rdRequest, expectSuccessIsCalled], timeout: 1.0, enforceOrder: true)
    }
    
    func testHandleResponseStoresAllSubjectsFromMultipleRequests() {
        let page1Response = JSONExamples.fileContent("subjects_page_1")
        let page2Response = JSONExamples.fileContent("subjects_page_2")
        let page3Response = JSONExamples.fileContent("subjects_page_3")
        
        let subject1 = WKSubjects.from(json: page1Response)!.data.first!
        let subject2 = WKSubjects.from(json: page2Response)!.data.first!
        let subject3 = WKSubjects.from(json: page3Response)!.data.first!
        
        let expectedSubjects: [WKSubject] = [subject1, subject2, subject3]
        let expectAllSubjectsStored = XCTestExpectation(description: "Subjects from all requests are stored.")
        
        class Delegate : TestDelegateWithSubjectsJson {
            override func requestFinished(_ request: WaniKaniAPIv2) {
                if let innerSubjects = request.result as? [WKSubject] {
                    if request.outcome == .success && innerSubjects == expectedSubjects {
                        if expectedSubjects.allSatisfy({ innerSubjects.contains($0) }) {
                            self.expectation?.fulfill()
                        }
                    }
                }
            }
        }
        
        let delegate = Delegate(expectation: expectAllSubjectsStored, expectedSubjects: expectedSubjects)
        let request = SubjectsRequestMock(token: token, delegate: delegate, levels: 11...15)
        
        request.mock(response: page1Response)
        request.mock(response: page2Response)
        request.mock(response: page3Response)
        
        request.initiate()
        
        self.wait(for: [expectAllSubjectsStored], timeout: 0.5)
    }
}

