//
//  Utilities.swift
//  WOWShop
//
//  Created by Alik on 04.04.2021.
//

import UIKit

class Utilities {
    
    func attributetPrice(for price: Int, and sale: Int) -> NSAttributedString {
        let saledPrice = Double(price) - (Double(price) * Double(sale) / 100.0)
        let formatedPrice = String(format: "$ %g", sale > 0 ? saledPrice : Double(price))
        
        let attributedText = NSMutableAttributedString(string: formatedPrice, attributes: [
            NSAttributedString.Key.font: UIFont(name: "OpenSans-SemiBold", size: 20) ?? .systemFont(ofSize: 12),
            NSAttributedString.Key.foregroundColor: UIColor.wowProductPriceBlue
        ])
        
        if sale > 0 {
            attributedText.append(NSMutableAttributedString(string: ",- ", attributes: [
                NSAttributedString.Key.font: UIFont(name: "OpenSans-SemiBold", size: 20) ?? .systemFont(ofSize: 12),
                NSAttributedString.Key.foregroundColor: UIColor.wowProductPriceBlue
            ]))
            
            attributedText.append(NSMutableAttributedString(string: "$ \(price)", attributes: [
                NSAttributedString.Key.font: UIFont(name: "OpenSans-SemiBold", size: 14) ?? .systemFont(ofSize: 12),
                NSAttributedString.Key.foregroundColor: UIColor.wowProductPriceGray,
                NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue
            ]))
        }
        
        return attributedText
    }
}
