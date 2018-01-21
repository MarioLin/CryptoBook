//
//  ColorProfile.swift
//  crypto-address-book
//
//  Created by Mario Lin on 1/21/18.
//  Copyright © 2018 Mario Lin. All rights reserved.
//

import UIKit

enum CoinType {
    case btc
    case eth
    case ltc
    case doge
}

struct ColorProfile {
    let backgroundColor: UIColor
    let textColor: UIColor
    let placeholderColor: UIColor
    let placeholderBackgroundColor: UIColor
    let buttonColor: UIColor
    let buttonTextColor: UIColor
    
    static func colorProfile(type: CoinType) -> ColorProfile {
        switch type {
        case .btc: return ColorProfile.btcProfile()
        case .eth: return ColorProfile.ethProfile()
        case .ltc: return ColorProfile.ltcProfile()
        case .doge: return ColorProfile.dogeProfile()
        }
    }
    
    static func btcProfile() -> ColorProfile {
        return ColorProfile(backgroundColor: .darkGray,
                            textColor: .orange,
                            placeholderColor: .yummyDarkOrange,
                            placeholderBackgroundColor: .yummyOrange,
                            buttonColor: .orange,
                            buttonTextColor: .white)
    }
    
    static func ethProfile() -> ColorProfile {
        return ColorProfile(backgroundColor: .purple,
                            textColor: .white,
                            placeholderColor: .lightGray,
                            placeholderBackgroundColor: .yummyOrange,
                            buttonColor: .white,
                            buttonTextColor: .purple)
    }
    
    static func ltcProfile() -> ColorProfile {
        return ColorProfile(backgroundColor: .white,
                            textColor: .black,
                            placeholderColor: .lightGray,
                            placeholderBackgroundColor: .yummyOrange,
                            buttonColor: .black,
                            buttonTextColor: .white)
    }
    
    static func dogeProfile() -> ColorProfile {
        return ColorProfile(backgroundColor: .white,
                            textColor: .yellow,
                            placeholderColor: .lightGray,
                            placeholderBackgroundColor: .yummyOrange,
                            buttonColor: .yellow,
                            buttonTextColor: .white)
    }
}
