//
//  SubjectExtension.swift
//  RfWK
//
//  Created by Florian Nöhring on 05.06.20.
//  Copyright © 2020 Florian Nöhring. All rights reserved.
//

import Foundation

extension Subject {
    
    func translations() -> [Translation] {
        // TODO: find a solution that doesn’t use N+1 queries
        return self.subjectTranslations!.allObjects.map({ ($0 as! SubjectTranslation).translation! })
    }
    
    func meanings() -> [String] {
        return self.translations().map({ $0.meaning! })
    }
}
