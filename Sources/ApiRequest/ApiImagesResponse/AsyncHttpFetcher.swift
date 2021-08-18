//
//  File.swift
//  
//
//  Created by Mauricio Guerrero Vega on 18/08/21.
//

import Foundation

class AsyncHttpFetcher {
    
    let sesion: URLSession
    
    init() {
        let configuracionSesion = URLSessionConfiguration.default
        configuracionSesion.requestCachePolicy = .returnCacheDataElseLoad
        //configuracionSesion.urlCache = urlCache
        self.sesion = URLSession(configuration: configuracionSesion)
    }
    
    func executeRequest(_ request: URLRequest, completionHandler handler: ((Result<Data, ApiQueryError>) -> Void)?) {
        let task = sesion.dataTask(with: request) { (data, response, error) in
            
            guard error == nil else {
                handler?(.failure(ApiQueryError.request(RequestError(error: error!, url: request.url!))))
                return
            }
            
            let httpResponse = response as! HTTPURLResponse
            
            // Request succeeded
            if httpResponse.statusCode == 200, let data = data {
                handler?(.success(data))
            } else {
                handler?(.failure(ApiQueryError.http(NetworkRequestError(statusCode: httpResponse.statusCode, url: request.url!))))
            }
        }
        task.resume()
    }
}
