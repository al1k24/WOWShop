//
//  NetworkService.swift
//  WOWShop
//
//  Created by Alik on 01.04.2021.
//

import Foundation

struct NetworkService {
    
    static let shared = NetworkService()
    private init() {}
    
    private let host = "http://mobile-test.devebs.net:5000"
    
    func fetchProducts(offest: Int, limit: Int, completion: @escaping (Result<[Product], NetworkError>) -> Void) {
        let urlString = "\(host)/products?offset=\(offest)&limit=\(limit)"
        
        load(from: urlString) { (result) in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let data):
                guard let products = try? [Product].decode(from: data) else {
                    completion(.failure(.decoding))
                    return
                }

                completion(.success(products))
            }
        }
    }
    
    func fetchProduct(id: Int, completion: @escaping (Result<Product, NetworkError>) -> Void) {
        let urlString = "\(host)/product?id=\(id)"
        
        load(from: urlString) { (result) in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let data):
                guard let product = try? Product.decode(from: data) else {
                    completion(.failure(.decoding))
                    return
                }

                completion(.success(product))
            }
        }
    }
    
    private func load(from urlString: String, withCompletion completion: @escaping (Result<Data, NetworkError>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.url))
            return
        }
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request, completionHandler: { (data, response, _) in
            DispatchQueue.main.async {
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.hasSuccessStatusCode,
                      let data = data else {
                    completion(.failure(.network))
                    return
                }
                
                completion(.success(data))
            }
        }).resume()
    }
}
