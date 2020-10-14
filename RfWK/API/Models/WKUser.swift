//
//  WKUser.swift
//  RfWK
//
//  Created by Florian Nöhring on 09.09.19.
//  Copyright © 2019 Florian Nöhring. All rights reserved.
//

import Foundation

struct WKUser : Codable, Equatable {
    var object: String
    var url: String
    var data_updated_at: Date
    var data: UserData
    
    static var decoder: JSONDecoder {
        get {
            return WaniKaniJSONDecoder()
        }
    }
    
    static func from(json: String?) -> WKUser? {
        guard json != nil else { return nil }
        
        let jsondata = json!.data(using: .utf8)!
        let user: WKUser? = try? self.decoder.decode(WKUser.self, from: jsondata)
        return user
    }
}

struct UserData : Codable, Equatable {
    var id: UUID
    var username: String
    var level: Int
    var profile_url: String
    var started_at: Date
    var subscription: UserSubscription
    var current_vacation_started_at: Date?
    var preferences: UserPreferences
}

struct UserSubscription : Codable, Equatable {
    var active: Bool
    var type: String
    var max_level_granted: Int
    var period_ends_at: Date?
}

struct UserPreferences : Codable, Equatable {
    var lessons_batch_size: Int
    var lessons_autoplay_audio: Bool
    var reviews_autoplay_audio: Bool
    var lessons_presentation_order: String
    var reviews_display_srs_indicator: Bool    
}
