//
//  ColorProfile.swift
//  crypto-address-book
//
//  Created by Mario Lin on 1/21/18.
//  Copyright © 2018 Mario Lin. All rights reserved.
//

import UIKit

enum CoinType: Int {
    case btc
    case eth
    case ltc
    case doge
    case other
    
    static func coinTypeToString(_ type: CoinType) -> String {
        switch type {
        case .btc: return "BTC"
        case .eth: return "ETH"
        case .ltc: return "LTC"
        case .doge: return "DOGE"
        case .other: return "OTHER"
        }
    }
    
    static func coinTypeToImage(_ type: CoinType) -> UIImage {
        switch type {
        case .btc: return #imageLiteral(resourceName: "bitcoin")
        case .eth: return #imageLiteral(resourceName: "eth")
        case .ltc: return #imageLiteral(resourceName: "litecoin")
        case .doge: return #imageLiteral(resourceName: "doge")
        case .other: return #imageLiteral(resourceName: "eth")
        }

    }
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
        case .other: return ColorProfile.btcProfile()
        }
    }
    
    static func btcProfile() -> ColorProfile {
        return ColorProfile(backgroundColor: .darkGray,
                            textColor: .bitcoinOrange,
                            placeholderColor: .yummyDarkOrange,
                            placeholderBackgroundColor: .yummyOrange,
                            buttonColor: .bitcoinOrange,
                            buttonTextColor: .white)
    }
    
    static func ethProfile() -> ColorProfile {
        return ColorProfile(backgroundColor: .ethereumPurple,
                            textColor: .white,
                            placeholderColor: .ethereumPurple,
                            placeholderBackgroundColor: .ethereumTextPurple,
                            buttonColor: .white,
                            buttonTextColor: .ethereumPurple)
    }
    
    static func ltcProfile() -> ColorProfile {
        return ColorProfile(backgroundColor: .litecoinSilver,
                            textColor: .darkGray,
                            placeholderColor: .lightGray,
                            placeholderBackgroundColor: .white,
                            buttonColor: .darkGray,
                            buttonTextColor: .white)
    }
    
    static func dogeProfile() -> ColorProfile {
        return ColorProfile(backgroundColor: .white,
                            textColor: .dogeYellow,
                            placeholderColor: .dogeYellow,
                            placeholderBackgroundColor: .dogeLightYellow,
                            buttonColor: .dogeYellow,
                            buttonTextColor: .white)
    }
}
