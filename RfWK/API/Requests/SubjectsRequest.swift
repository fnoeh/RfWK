//
//  SubjectsRequest.swift
//  RfWK
//
//  Created by Florian Nöhring on 15.10.19.
//  Copyright © 2019 Florian Nöhring. All rights reserved.
//

import Foundation

class SubjectsRequest : WaniKaniAPIv2 {
    
    let levels: ClosedRange<Int>
    var totalCount = 0
    var fetchedCount = 0
    
    // TODO: add array to contain parsed (JSON) or raw response content from intermediate calls
    // var responses = [(string: String, code: Int)]()
    
    init(token: String,
         action: WaniKaniAPIv2.Action,
         method: WaniKaniAPIv2.HTTPMethod,
         delegate: RequestDelegate?,
         levels: ClosedRange<Int>) {
        self.levels = levels
        super.init(token: token, action: action, method: method, delegate: delegate)
        
        self.result = [WKSubject]()
    }
    
    convenience init(token: String, delegate: RequestDelegate? = nil, level: Int) {
        self.init(token: token, action: .subjects, method: .GET, delegate: delegate, levels: 1...level)
    }
    
    convenience init(token: String, delegate: RequestDelegate? = nil, levels: ClosedRange<Int>) {
        self.init(token: token, action: .subjects, method: .GET, delegate: delegate, levels: levels)
    }

    override var activity: String {
        get { return "Downloading content" }
    }
    
    override func baseParams() -> Dictionary<String, String> {
        return [
            "levels": Array(levels).map{ String($0) }.joined(separator: ","),
            "types": "kanji,vocabulary"
        ]
    }
    
    internal func unauthorized() {
        self.outcome = .unauthorized
        self.delegate?.requestFinished(self)
    }
    
    internal func noResponse() {
        self.outcome = .error
        self.delegate?.requestFinished(self)
    }
    
    internal func jsonError() {
        self.outcome = .jsonError
        self.delegate?.requestFinished(self)
    }
    
    internal func success() {
        self.outcome = .success
        self.delegate?.requestFinished(self)
    }
    
    override internal func handleResponse() {
        if self.statusCode == 401 {
            self.outcome = .unauthorized
            self.unauthorized()
        } else if (self.statusCode == nil) || (self.responseString == nil) {
            self.noResponse()
        } else if let subjectsWrapper = WKSubjects.from(json: self.responseString) {
            self.totalCount = subjectsWrapper.total_count
            let subjects: [WKSubject] = subjectsWrapper.data
            self.fetchedCount += subjects.count
            self.delegateProgress()
            self.result = (self.result as! [WKSubject]) + subjects
            
            if subjectsWrapper.hasMore {
                let nextURLString = subjectsWrapper.pages.next_url!
                let nextURL = URL(string: nextURLString)!
                
                self.initiate(to: nextURL)
            } else {
                self.success()
            }
        } else {
            self.jsonError()
        }
    }
    
    func delegateProgress(_ customValue: Float? = nil) {
        let progress: Float
        
        if customValue != nil {
            progress = customValue!
        } else if self.totalCount == 0 {
            progress = 0.0
        } else {
            progress = Float(self.fetchedCount) / Float(self.totalCount)
        }
        
        delegate?.progress(progress)
    }
}
