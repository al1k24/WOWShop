//
//  HTTPURLResponse+Extentions.swift
//  WOWShop
//
//  Created by Alik on 04.04.2021.
//

import Foundation

extension HTTPURLResponse {
    var hasSuccessStatusCode: Bool {
        return 200...299 ~= statusCode
    }
}
