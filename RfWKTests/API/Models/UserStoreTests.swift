//
//  StoreUserInDefaultsTests.swift
//  RfWKTests
//
//  Created by Florian Nöhring on 18.09.19.
//  Copyright © 2019 Florian Nöhring. All rights reserved.
//

import XCTest
@testable import RfWK

class UserStoreTests: XCTestCase {
    
    var userJSON: String!
    var decoder: JSONDecoder!
    var user: WKUser!
    var userStore: UserStore!
    var defaults: UserDefaults!
    
    override func setUp() {
        userJSON = JSONExamples.User
        decoder = JSONDecoder.wanikani()
        user = decodeUser()
        defaults = UserDefaults.init(suiteName: Constants.userDefaultsTestSuiteName)
        userStore = UserStore.init(defaults: defaults)
        userStore.remove()
    }
    
    override func tearDown() {
        userStore.remove()
    }
    
    func testUserIsUser() {
        XCTAssertNotNil(user)
        XCTAssert((user as Any?) is WKUser)
    }
    
    func testStoreAndRetrieve() {
        let initialUserInStore = userStore.retrieve()
        XCTAssertNil(initialUserInStore)
        
        userStore.store(user)
        
        let retrievedUser = userStore.retrieve()
        XCTAssertNotNil(retrievedUser)
        XCTAssertEqual(retrievedUser!.data.id , user.data.id)
    }
    
    func testRemove() {
        userStore.store(user)
        userStore.remove()
        
        let retrievedUser = userStore.retrieve()
        XCTAssertNil(retrievedUser)
    }
    
    private func decodeUser() -> WKUser {
        let jsondata = userJSON.data(using: .utf8)!
        let user = try? decoder.decode(WKUser.self, from: jsondata)
        return user!
    }
}
