//
//  UserRequest.swift
//  RfWK
//
//  Created by Florian Nöhring on 10.09.19.
//  Copyright © 2019 Florian Nöhring. All rights reserved.
//

import Foundation

class UserRequest : WaniKaniAPIv2 {
    
    convenience init(token: String, delegate: RequestDelegate? = nil) {
        self.init(token: token, action: .user, method: .GET, delegate: delegate)
    }
    
    override var activity: String {
        get { return "Requesting user" }
    }

    override func requestStarted() {
        self.delegate?.requestStarted(self)
    }
    
    internal func noResponse() {
        self.outcome = .error
        self.delegate?.requestFinished(self)
    }
    
    internal func jsonError() {
        self.outcome = .jsonError
        self.delegate?.requestFinished(self)
    }
    
    internal func success(_ user: WKUser) {
        self.outcome = .success
        self.result = user
        self.delegate?.requestFinished(self)
    }
    
    internal func unauthorized() {
        self.outcome = .unauthorized
        self.delegate?.requestFinished(self)
    }
    
    override internal func handleResponse() {
        if self.statusCode == 401 {
            self.unauthorized()
        } else if (self.statusCode == nil) || (self.responseString == nil) {
            self.noResponse()
        } else if let user = WKUser.from(json: self.responseString) {
            self.success(user)
        } else {
            self.jsonError()
        }
    }
}
