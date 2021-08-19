//
//  File.swift
//  
//
//  Created by Mauricio Guerrero Vega on 18/08/21.
//

import UIKit
import Combine

public class AppRemoteImageProvider { 
    
    static let shared = AppRemoteImageProvider()
    static let imageCache = NSCache<NSString, AnyObject>()
    
    private lazy var fetcher = AsyncHttpFetcher()
    
    func loadImage(imageView: inout UIImageView, strImagen: String, completion: @escaping (UIImage?)->Void) {
        
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = imageView.bounds
        imageView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        guard let strImagenFormatted = strImagen.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        guard let urlImagen = URL(string: strImagenFormatted) else { return }
        
        //subImg = AppRemoteImageProvider.shared.publisher(para: urlImagen)
        
        var subImg : Cancellable?
        subImg = publisher(para: urlImagen)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { (imagen) in
                if imagen != nil {
                    activityIndicator.stopAnimating()
                    activityIndicator.removeFromSuperview()
                }
                completion(imagen)
                subImg?.cancel()
            })
    }
}


extension AppRemoteImageProvider {
    
    //MARK: -RECOVER IMAGE
    private func publisher(para url: URL) -> Future<UIImage?, Never> {
        return Future<UIImage?, Never> { [weak self] (promise) in
            guard let self = self else { return }
            
            if let cachedImage = AppRemoteImageProvider.imageCache.object(forKey: url.absoluteString as NSString) as? UIImage {
                promise(.success(cachedImage))
                //print("Cache")
            }else {
                self.descargarImagen(de: url) { imagen in
                    promise(.success(imagen))
                    //print("Network")
                }
            }
        }
    }
    
    //MARK: -RECOVER IMAGE FROM URL
    func descargarImagen(de url: URL, completar: ((UIImage?) -> Void)? = nil) {
        print(url)
        var request = URLRequest(url: url)
        request.cachePolicy = .returnCacheDataElseLoad
        
        fetcher.executeRequest(request) {(resultado) in
            var imagen: UIImage?
            switch resultado {
            case .failure(let error):
                print(error, url)
            case .success(let datos):
                imagen = UIImage(data: datos)
                AppRemoteImageProvider.imageCache.setObject(imagen!, forKey: url.absoluteString as NSString)
            }
            completar?(imagen)
        }
    }
}

