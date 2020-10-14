//
//  UserStoreFacade.swift
//  RfWK
//
//  Created by Florian Nöhring on 13.10.19.
//  Copyright © 2019 Florian Nöhring. All rights reserved.
//

import Foundation

struct UserUpdate {
    var type: UpdateType
    var oldLevel: Int
    var newLevel: Int

    enum UpdateType {
        case newUser
        case sameLevel
        case higherLevel
        case lowerLevel
    }
}

class UserStoreFacade {
    
    var userStore: UserStore
    
    init(userStore: UserStore? = nil) {
        self.userStore = userStore ?? UserStore()
    }
    
    func updateType(newUser: WKUser) -> UserUpdate {
        if let oldUser = self.userStore.retrieve() {
            if oldUser.data.level < newUser.data.level {
                return UserUpdate(type: .higherLevel, oldLevel: oldUser.data.level, newLevel: newUser.data.level)
            } else if oldUser.data.level > newUser.data.level {
                return UserUpdate(type: .lowerLevel, oldLevel: oldUser.data.level, newLevel: newUser.data.level)
            } else { // levels are equal
                return UserUpdate(type: .sameLevel, oldLevel: oldUser.data.level, newLevel: newUser.data.level)
            }
        } else {
            return UserUpdate(type: .newUser, oldLevel: 0, newLevel: newUser.data.level)
        }
    }
    
    func storeUser(newUser: WKUser) {
        self.userStore.store(newUser)
    }
}
