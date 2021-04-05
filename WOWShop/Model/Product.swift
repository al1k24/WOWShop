//
//  Product.swift
//  WOWShop
//
//  Created by Alik on 01.04.2021.
//

import Foundation

struct Product {
    let id: Int
    let title: String
    let shortDescription: String
    let image: String
    let price: Int
    let salePercent: Int
    let details: String
}

extension Product: Decodable {
    private enum ProductCodingKeys: String, CodingKey {
        case id, title
        case shortDescription = "short_description"
        case image, price
        case salePercent = "sale_precent"
        case details
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ProductCodingKeys.self)

        self.id = try container.decode(Int.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.shortDescription = try container.decode(String.self, forKey: .shortDescription)
        self.image = try container.decode(String.self, forKey: .image)
        self.price = try container.decode(Int.self, forKey: .price)
        self.salePercent = try container.decode(Int.self, forKey: .salePercent)
        self.details = try container.decode(String.self, forKey: .details)
    }
}
