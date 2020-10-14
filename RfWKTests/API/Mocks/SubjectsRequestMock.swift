//
//  SubjectsRequestMock.swift
//  RfWKTests
//
//  Created by Florian Nöhring on 12.11.19.
//  Copyright © 2019 Florian Nöhring. All rights reserved.
//

import Foundation
@testable import RfWK

class SubjectsRequestMock : SubjectsRequest {
    var mockedResponses = [(string: String, code: Int)]()
    
    func mock(response: String, code: Int = 200) {
        mockedResponses.append((string: response, code: code))
    }
    
    override func initiate(to targetURL: URL? = nil) {
        prepareResponse()
        
        DispatchQueue.init(label: "urlSesssion").async() {
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
