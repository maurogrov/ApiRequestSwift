//
//  ApiQueryResponseProtocol.swift
//  SingleMG
//
//  Created by Mauricio Guerrero Vega on 17/08/21.
//

import Foundation
import Combine

public protocol ApiQueryResponse: AnyObject {
    
    associatedtype R: Decodable
    
    var method: HttpMethod { get }
    var data: Data? { get }
    var queryItems: [URLQueryItem] { get }
    var url: URL { get }
    var queryName: String { get }
    var endpointName: String { get }
    
    func ejecutar() -> Future<R, ApiQueryError>
    
}
