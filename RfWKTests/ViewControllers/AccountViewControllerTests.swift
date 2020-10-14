//
//  AccountViewControllerTests.swift
//  RfWKTests
//
//  Created by Florian Nöhring on 09.08.20.
//  Copyright © 2020 Florian Nöhring. All rights reserved.
//

import XCTest
@testable import RfWK

class AccountViewControllerTests: XCTestCase {

    var controller: AccountViewController!
    var wkFixtures: WKFixtures = {
        WKFixtures()
    }()
    var userDefaults: UserDefaults!
    var userStore: UserStore!
    
    override func setUp() {
        userDefaults = UserDefaults(suiteName: "Test")
        userStore = UserStore(defaults: userDefaults)
        userStore.remove()
    }
    
    // MARK: - Request Delegate
    
    // MARK: requestFinished
    
    func testRequestFinishedWithUserRequestCallsTreatNewUser() {
        let userRequest = UserRequest(token: "token")
        userRequest.outcome = .success
        
        let expectation = XCTestExpectation()
        
        
        class Controller: AccountViewController {
            var expectation: XCTestExpectation?
            
            convenience init(expectation: XCTestExpectation) {
                self.init()
                self.expectation = expectation
            }
            
            override func treatNewUser(request: UserRequest) {
                self.expectation?.fulfill()
            }
        }
        
        controller = Controller(expectation: expectation)
        controller.requestFinished(userRequest)
        
        self.wait(for: [expectation], timeout: 0.1)
    }
    
    func testRequestFinishedWithSubjectsRequestCallsTreatNewUser() {
        let subjectsRequest = SubjectsRequest(token: "token", level: 1)
        subjectsRequest.outcome = .success
        
        let expectation = XCTestExpectation(description: "Request subjects")
        
        class Controller: AccountViewController {
            var expectation: XCTestExpectation?
            
            convenience init(expectation: XCTestExpectation) {
                self.init()
                self.expectation = expectation
            }
            
            override func saveSubjects(request: SubjectsRequest) {
                self.expectation?.fulfill()
            }
        }
        
        controller = Controller(expectation: expectation)
        controller.requestFinished(subjectsRequest)
        
        self.wait(for: [expectation], timeout: 0.1)
    }
    
    // MARK: - treatNewUser
    
    func testTreatNewUserWithCaseNewUserCallsSaveNewUserAndRequestSubjects() {
        let expectation = XCTestExpectation(description: "Save new user")

        let userRequest = UserRequest(token: "token")
        userRequest.result = WKFixtures().user()
        
        class Controller: AccountViewController {
            var expectSaveNewUserAndRequestSubjects: XCTestExpectation?
            
            convenience init(expectation: XCTestExpectation, userStore: UserStore) {
                self.init()
                self.expectSaveNewUserAndRequestSubjects = expectation
                self.userStore = userStore
            }
            
            override func saveNewUserAndRequestSubjects(_ newUser: WKUser, request: UserRequest, userUpdate: UserUpdate) {
                self.expectSaveNewUserAndRequestSubjects?.fulfill()
            }
        }
        
        controller = Controller(expectation: expectation, userStore: self.userStore)
        controller.treatNewUser(request: userRequest)

        self.wait(for: [expectation], timeout: 0.1)
    }

    func testTreatNewUserWithCaseSameLevel() {
        let expectUpdateUserWithoutLeveling = XCTestExpectation(description: "call updateUserWIthoutLeveling()")
        
        let oldUser = wkFixtures.user(level: 4)
        let newUser = wkFixtures.user(level: 4)
        
        userStore.store(oldUser)
        
        let userRequest = UserRequest(token: "token")
        userRequest.result = newUser
        
        class Controller: AccountViewController {
            var expectation: XCTestExpectation?
            
            convenience init(expectation: XCTestExpectation?, userStore: UserStore) {
                self.init()
                self.expectation = expectation
                self.userStore = userStore
            }
            
            override func updateUserWithoutLeveling(_ newUser: WKUser) {
                self.expectation?.fulfill()
            }
        }
        
        controller = Controller(expectation: expectUpdateUserWithoutLeveling, userStore: self.userStore)
        controller.treatNewUser(request: userRequest)

        self.wait(for: [expectUpdateUserWithoutLeveling], timeout: 0.1)
    }

    func testTreatNewUserWithCaseHigherLevelCallsUpgradeUser() {
        let expectUpgradeUser = XCTestExpectation(description: "call upgradeUser()")
        
        let oldUser = wkFixtures.user(level: 1)
        let newUser = wkFixtures.user(level: 2)
        
        userStore.store(oldUser)
        
        let userRequest = UserRequest(token: "token")
        userRequest.result = newUser
        
        class Controller: AccountViewController {
            var expectation: XCTestExpectation?
            
            convenience init(expectation: XCTestExpectation?, userStore: UserStore) {
                self.init()
                self.expectation = expectation
                self.userStore = userStore
            }
            
            override func upgradeUser(_ newUser: WKUser, _ comparison: UserUpdate, _ request: UserRequest) {
                self.expectation?.fulfill()
            }
        }
        
        controller = Controller(expectation: expectUpgradeUser, userStore: self.userStore)
        controller.treatNewUser(request: userRequest)
        
        self.wait(for: [expectUpgradeUser], timeout: 0.1)
    }

    func testTreatNewUserWithCaseLowerLevelDisplaysDowngradeWarning() {
        let oldUser = wkFixtures.user(level: 5)
        let newUser = wkFixtures.user(level: 3)
        
        userStore.store(oldUser)
        
        let expectation = XCTestExpectation(description: "Expect display downgrade warning")
        let userRequest = UserRequest(token: "token")
        userRequest.result = newUser
        
        class Controller: AccountViewController {
            var expectation: XCTestExpectation?
            
            convenience init(expectation: XCTestExpectation, userStore: UserStore) {
                self.init()
                self.expectation = expectation
                self.userStore = userStore
            }
            
            override func requestUserDowngradeWarning(newUser: WKUser, oldLevel: Int, newLevel: Int) {
                self.expectation?.fulfill()
            }
        }
        
        controller = Controller(expectation: expectation, userStore: self.userStore)
        controller.treatNewUser(request: userRequest)

        self.wait(for: [expectation], timeout: 0.1)
    }
}
