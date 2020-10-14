//
//  UserRequestMock.swift
//  RfWKTests
//
//  Created by Florian Nöhring on 23.10.19.
//  Copyright © 2019 Florian Nöhring. All rights reserved.
//

import Foundation
@testable import RfWK

class UserRequestMock : UserRequest {
    var mockedResponses = [(string: String?, code: Int?)]()
    
    func mock(response: String?, code: Int? = 200) {
        mockedResponses.append((response, code))
    }
    
    override func initiate(to targetURL: URL? = nil) {
        prepareResponse()
        
        DispatchQueue.init(label: "urlSession").async {
            self.handleResponse()
        }
    }
    
    private func prepareResponse() {
        guard mockedResponses.hasElements else { return }
        
        let values = mockedResponses.removeFirst()
        self.responseString = values.string
        self.statusCode = values.code
    }
}
