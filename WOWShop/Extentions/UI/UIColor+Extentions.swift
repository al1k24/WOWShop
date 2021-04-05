//
//  UIColor+Extentions.swift
//  WOWShop
//
//  Created by Alik on 01.04.2021.
//

import UIKit

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    static let wowShopBlue = UIColor.rgb(red: 24, green: 39, blue: 103)
    static let wowProductNameBlue = UIColor.rgb(red: 7, green: 25, blue: 92)
    static let wowProductDescriptionGray = UIColor.rgb(red: 66, green: 74, blue: 86)
    static let wowProductPriceBlue = UIColor.rgb(red: 3, green: 90, blue: 151)
    static let wowProductPriceGray = UIColor.rgb(red: 156, green: 177, blue: 188)
    static let wowProductSeparatorGray = UIColor.rgb(red: 211, green: 220, blue: 217)
    static let wowAddToCartButtonBlue = UIColor.rgb(red: 24, green: 40, blue: 103)
    static let wowBuyNowButtonPurple = UIColor.rgb(red: 119, green: 64, blue: 162)
    static let wowFavoriteButtonRed = UIColor.rgb(red: 227, green: 69, blue: 58)
}
