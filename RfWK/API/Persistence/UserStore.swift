//
//  UserStore.swift
//  RfWK
//
//  Created by Florian Nöhring on 18.09.19.
//  Copyright © 2019 Florian Nöhring. All rights reserved.
//

import Foundation

class UserStore {
    
    let defaults: UserDefaults
    let defaultsKey = "User"
    
    init() {
        self.defaults = UserDefaults.standard
    }
    
    init(defaults: UserDefaults) {
        self.defaults = defaults
    }
    
    func retrieve() -> WKUser? {
        if let data = defaults.value(forKey: defaultsKey) as? Data {
            if let result = try? PropertyListDecoder().decode(WKUser.self, from: data) {
                return result
            }
        }
        return nil
    }
    
    func store(_ user: WKUser) {
        defaults.set(try? PropertyListEncoder().encode(user), forKey: defaultsKey)
    }
    
    func remove() {
        defaults.removeObject(forKey: defaultsKey)
    }
}
