//
//  UserTests.swift
//  RfWKTests
//
//  Created by Florian Nöhring on 13.09.19.
//  Copyright © 2019 Florian Nöhring. All rights reserved.
//

import XCTest
@testable import RfWK

class UserTests: XCTestCase {

    var jsonString: String!
    var decoder: JSONDecoder!
    
    override func setUp() {
        jsonString = JSONExamples.User
        decoder = JSONDecoder.wanikani()
    }
    
    func testJSONdecodedAsUser() {
        if let user = decodeUser() {
            XCTAssert((user as Any) is WKUser)
            XCTAssertEqual(user.url, "https://api.wanikani.com/v2/user")
        } else {
            XCTFail("no user")
        }
    }
    
    func testUserAttibutes() {
        if let user = decodeUser() {
            XCTAssertEqual(user.url, "https://api.wanikani.com/v2/user")
            XCTAssert((user.data_updated_at as Any) is Date)
            
            let formatter = DateFormatter(format: "yyyy-MM-dd HH:mm:ss Z")
            let parsedDataUpdatedAt = formatter.string(from: user.data_updated_at)
            
            XCTAssertEqual(parsedDataUpdatedAt, "2019-09-07 08:24:34 +0200")
        } else {
            XCTFail("no user")
        }
    }

    func testUserDataAttributes() {
        if let user = decodeUser() {
            let data: UserData = user.data
            let format = DateFormatter(format: "yyyy-MM-dd HH:mm:ss Z")
            
            XCTAssert((data as Any) is UserData)
            XCTAssertEqual(data.id, UUID(uuidString: "284c7d18-4867-45e6-95a9-7d357297cbee"))
            XCTAssertEqual(data.username, "RfWK")
            XCTAssertEqual(data.level, 6)
            XCTAssertEqual(data.profile_url, "https://www.wanikani.com/users/Florian")
            XCTAssertEqual(format.string(from: data.started_at), "2017-03-01 11:45:29 +0100")
            XCTAssertEqual(format.string(from: data.current_vacation_started_at!), "2018-06-17 17:31:25 +0200")
            XCTAssertNotNil(data.subscription)
            XCTAssertNotNil(data.preferences)
        } else {
            XCTFail("no user")
        }
    }
    
    func testUserSubscription() {
        if let user = decodeUser() {
            let data: UserData = user.data
            let subscription: UserSubscription = data.subscription
            
            XCTAssert(subscription.active)
            XCTAssertEqual(subscription.type, "lifetime")
            XCTAssertEqual(subscription.max_level_granted, 60)
            XCTAssertNil(subscription.period_ends_at)
        } else {
            XCTFail("no user")
        }
    }
    
    func testUserPreferences() {
        if let user = decodeUser() {
            let data = user.data
            let preferences = data.preferences
            
            XCTAssertEqual(preferences.lessons_batch_size, 5)
            XCTAssertFalse(preferences.lessons_autoplay_audio)
            XCTAssertFalse(preferences.reviews_autoplay_audio)
            XCTAssertEqual(preferences.lessons_presentation_order, "ascending_level_then_subject")
            XCTAssert(preferences.reviews_display_srs_indicator)
        } else {
            XCTFail("no user")
        }
    }
    
    func testComparison() {
        let user1 = decodeUser()!
        let user2 = decodeUser()!
        XCTAssertEqual(user1, user2)
    }
    
    private func decodeUser() -> WKUser? {
        let jsondata = jsonString.data(using: .utf8)!
        let user = try? decoder.decode(WKUser.self, from: jsondata)
        
        if user == nil {
            XCTFail("WKUser not successfully decoded from JSON.")
        }

        return user
    }
}
