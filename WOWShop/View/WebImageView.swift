//
//  WebImageView.swift
//  WOWShop
//
//  Created by Alik on 04.04.2021.
//

import UIKit

class WebImageView: UIImageView {
    
    private var currentUrlString: String?
    private var currentDataTask: URLSessionDataTask?
    
    func set(imageURL: String?, completion: (() -> Void)? = nil) {
        currentUrlString = imageURL
        
        guard let imageURL = imageURL, let url = URL(string: imageURL) else {
            completion?()
            return
        }
        
        if let cachedResponse = URLCache.shared.cachedResponse(for: URLRequest(url: url)) {
            guard let image = UIImage(data: cachedResponse.data) else {
                completion?()
                return
            }
            
            self.image = image
            
            completion?()
            return
        }
        
        currentDataTask = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            
            DispatchQueue.main.async {
                if let data = data, let response = response {
                    self?.handleLoadedImage(data: data, response: response)
                    
                    completion?()
                }
            }
        }
        currentDataTask?.resume()
    }
    
    func killDataTask() {
        currentDataTask?.cancel()
        currentDataTask = nil
    }
    
    private func handleLoadedImage(data: Data, response: URLResponse) {
        guard let responseURL = response.url else { return }
        
        let cachedResponse = CachedURLResponse(response: response, data: data)
        URLCache.shared.storeCachedResponse(cachedResponse, for: URLRequest(url: responseURL))
        
        if responseURL.absoluteString == currentUrlString {
            self.image = UIImage(data: data)
        }
    }

}
