//
//  BuildRequest.swift
//  SingleMG
//
//  Created by Mauricio Guerrero Vega on 17/08/21.
//

import Foundation

//MARK: - BUILD REQUEST
extension ApiQueryResponse {
    
    func buildRequest() -> URLRequest {
        let request: URLRequest
        switch method {
        case .get:
            request = composeGetRequest()
        case .put:
            request = composePutRequest()
        case .post:
            request = composePostRequest()
        }
        return request
    }
    
    func composeGetRequest() -> URLRequest {
        var request = URLRequest(url: url)
        
        request.httpMethod = HttpMethod.get.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        return request
    }
    
    func composePostRequest() -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = HttpMethod.post.rawValue
        request.addValue("application/json",forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("keep-alive", forHTTPHeaderField: "Connection")
        request.httpBody = data
        
        return request
    }
    
    func composePutRequest() -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = HttpMethod.put.rawValue
        request.addValue("application/json",forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("keep-alive", forHTTPHeaderField: "Connection")
        request.httpBody = data
        
        return request
    }
    
}
