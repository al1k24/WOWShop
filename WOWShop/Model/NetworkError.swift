//
//  NetworkError.swift
//  WOWShop
//
//  Created by Alik on 01.04.2021.
//

import Foundation

enum NetworkError: Error {
    case url
    case network
    case decoding
}

extension NetworkError {
    var errorDescription: String? {
        switch self {
        case .url:
            return "An error occurred while checking URL ".localizedString
        case .network:
            return "An error occurred while fetching data ".localizedString
        case .decoding:
            return "An error occurred while decoding data".localizedString
        }
    }
}
