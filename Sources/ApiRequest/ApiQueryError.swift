//
//  ApiQueryError.swift
//  SingleMG
//
//  Created by Mauricio Guerrero Vega on 17/08/21.
//

import Foundation

public enum ApiQueryError: Error {
    case request(RequestError)
    case http(NetworkRequestError)
    case decode(DecodingError)
}

public struct RequestError: Error {
    let error: Error
    let url: URL
    
    var localizedDescription: String {
        return error.localizedDescription
    }
}

public struct NetworkRequestError: Error {
    let statusCode: Int
    let url: URL
    
    var localizedDescription: String {
        let description: String
        
        switch statusCode {
        case 400:
            description = "\(statusCode) Bad Request"
        case 401:
            description = "\(statusCode) Unatuhorized"
        case 404:
            description = "\(statusCode) Not Found"
        case 408:
            description = "\(statusCode) Request Timeout"
        default:
            description = "\(statusCode) Network Request Error - no other information"
        }
        
        return description
    }
}

extension RequestError {
    init (error: Error, request: URLRequest) {
        self.init(error: error, url: request.url!)
    }
}

extension NetworkRequestError {
    init (statusCode: Int, request: URLRequest) {
        self.init(statusCode: statusCode, url: request.url!)
    }
}
