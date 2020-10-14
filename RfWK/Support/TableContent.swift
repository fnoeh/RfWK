//
//  TableContent.swift
//  RfWK
//
//  Created by Florian Nöhring on 02.05.20.
//  Copyright © 2020 Florian Nöhring. All rights reserved.
//

import Foundation

struct SectionContent<T> {
    var title: String
    var items: [T]
    var segue: String?
}


class TableContent<T> {
    var content: [SectionContent<T>] = Array()
    
    init(content: [SectionContent<T>] = []) {
        self.content = content
    }
    
    func numberOfSections() -> Int {
        return content.count
    }
    
    func numberOfRowsIn(section: Int) -> Int {
        return content[section].items.count
    }
    
    func segueIdentifier(for section: Int) -> String? {
        return content[section].segue
    }
    
    func item(at indexPath: IndexPath) -> T {
        return content[indexPath.section].items[indexPath.row]
    }
}
