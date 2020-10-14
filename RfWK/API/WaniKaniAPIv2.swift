//
//  WaniKaniAPIv2.swift
//  RfWK
//
//  Created by Florian Nöhring on 10.09.19.
//  Copyright © 2019 Florian Nöhring. All rights reserved.
//

import Foundation

class WaniKaniAPIv2 : NSObject {
    
    enum HTTPMethod {
        case GET
    }
    
    enum Action {
        case user
        case subjects
    }
    
    enum Outcome {
        case success
        case jsonError
        case error
        case unauthorized
    }
    
    let token: String
    let method: HTTPMethod
    let action: Action
    var outcome: Outcome?
    
    var result: Any?
    
    let delegate: RequestDelegate?
    
    // TODO: replace statusCode and responseString with a Response objects or struct
    var statusCode: Int?
    var responseString: String?
    var error: Error?
    
    var activity: String {
        get { return "Calling WaniKani" }
    }
    
    var baseURLString: String {
        get { return "https://api.wanikani.com/v2/\(action)" }
    }
    
    var url: URL {
        get {
            var components = URLComponents(string: baseURLString)!
            components.queryItems = baseParams().sorted(by: {$0 < $1}).map {
                return URLQueryItem(name: $0, value: $1)
            }
            return components.url!
        }
    }
    
    init(token: String, action: Action, method: HTTPMethod, delegate: RequestDelegate? = nil) {
        self.token = token
        self.action = action
        self.method = method
        self.delegate = delegate
    }
    
    func initiate(to targetURL: URL? = nil) {
        let urlSession = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate: self,
            delegateQueue: nil
        )
        
        let request: URLRequest = self.urlRequest(to: targetURL)
        let downLoadTask = urlSession.downloadTask(with: request)
        
        self.requestStarted()
        downLoadTask.resume()
    }
    
    func requestStarted() {}
    func urlRequest(to: URL? = nil) -> URLRequest {
        let theURL = to ?? self.url
        var urlRequest = URLRequest(url: theURL)
        urlRequest.httpMethod = "\(self.method)"
        urlRequest.setValue("Bearer \(self.token)", forHTTPHeaderField: "Authorization")
        
        return urlRequest
    }

    func baseParams() -> Dictionary<String,String> {
        return [:]
    }
    
    func handleResponse() {}
}

extension WaniKaniAPIv2 : URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didFinishDownloadingTo location: URL) {
        self.statusCode = nil
        self.responseString = nil
        
        if let response = downloadTask.response as? HTTPURLResponse {
            self.statusCode = response.statusCode
            self.responseString = try? String(contentsOf: location)
        }
        
        self.handleResponse()
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        // print("Bytes written: \(bytesWritten). (\(totalBytesWritten) total so far.)")
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError usError: Error?) {
        if usError != nil {
            print("Some error occured: \(String(describing: usError))")
            self.error = usError
            self.delegate?.error(self, reason: usError!.localizedDescription)
        }
    }
}
