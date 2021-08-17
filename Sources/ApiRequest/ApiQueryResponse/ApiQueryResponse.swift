//
//  ApiQueryResponse.swift
//  SingleMG
//
//  Created by Mauricio Guerrero Vega on 17/08/21.
//

import Foundation
import Combine


extension ApiQueryResponse {
     
    public var queryItems: [URLQueryItem] { [] }
    public var url: URL {
            var url = URL(string: "\(endpointName)/\(queryName)")!
            var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
            components.queryItems = queryItems
            url = components.url!
            return url
    }
    
    public func ejecutar() -> Future<R, ApiQueryError> {
        let request = buildRequest()
        let publisher = Future<R, ApiQueryError> { (promise) in
            URLSession.shared.dataTaskPublisher(for: request)
                .tryMap { (data, response) -> R in
                    let httpResponse = response as! HTTPURLResponse
                    let statusCode = httpResponse.statusCode
                    
                    if statusCode == 200 {
                        do {
                            return try JSONDecoder().decode(R.self, from: data)
                        } catch {
                            throw ApiQueryError.decode(error as! DecodingError)
                        }
                    } else {
                        throw ApiQueryError.http(NetworkRequestError(statusCode: statusCode, request: request))
                    }
                }
                .eraseToAnyPublisher()
                .subscribe(Subscribers.Sink(receiveCompletion: { (completion) in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        if let apiError = (error as? ApiQueryError) {
                            promise(.failure(apiError))
                        } else {
                            promise(.failure(ApiQueryError.request(RequestError(error: error, request: request))))
                        }
                    }
                }, receiveValue: {
                    promise(.success($0))
                }))
        }
        return publisher
    }
    
}

