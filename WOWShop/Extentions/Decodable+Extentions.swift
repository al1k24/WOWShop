//
//  Decodable+Extentions.swift
//  WOWShop
//
//  Created by Alik on 01.04.2021.
//

import Foundation

extension Decodable {
    static func decode(with decoder: JSONDecoder = JSONDecoder(), from data: Data) throws -> Self {
        return try decoder.decode(Self.self, from: data)
    }
}
