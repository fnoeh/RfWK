//
//  PersonalAccessToken.swift
//  RfWK
//
//  Created by Florian Nöhring on 07.09.19.
//  Copyright © 2019 Florian Nöhring. All rights reserved.
//

import Foundation

public class ValidPersonalAccessToken {
    
    let value: String
    
    private init(_ token: String) {
        self.value = token
    }
    
    static func build(_ token: String) -> ValidPersonalAccessToken? {
        let trimmedToken = token.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        guard formatIsValid(trimmedToken) else { return nil }
        
        return ValidPersonalAccessToken(trimmedToken)
    }
    
    static func formatIsValid(_ token: String?) -> Bool {
        guard token != nil && !token!.isEmpty else { return false }
        let validPattern = "[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}"
        
        return token!.matches(validPattern)
    }
}
