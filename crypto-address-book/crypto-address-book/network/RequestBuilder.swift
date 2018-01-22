//
//  RequestBuilder.swift
//  crypto-address-book
//
//  Created by Mario Lin on 1/21/18.
//  Copyright © 2018 Mario Lin. All rights reserved.
//

import Foundation

struct RequestBuilder {
    static func soChainRequest(coin: CoinType, address: String) -> URL? {
        let requestString = "https://chain.so/api/v2/get_address_balance/\(CoinType.coinTypeToString(coin).lowercased())/\(address)"
        return URL(string: requestString)
    }
    
    static func blockCypherRequest(coin: CoinType, address: String) -> URL? {
        let requestString = "https://api.blockcypher.com/v1/\(CoinType.coinTypeToString(coin).lowercased())/main/addrs/\(address)/balance"
        return URL(string: requestString)

    }
}

protocol BlockChainTransaction {
    var coin: CoinType { get }
    var address: String { get }
    var balance: Double? { get set }
    var errorMessage: String? { get set }
    init(coin: CoinType, address: String)
}

class SoChainTransaction: ApiTransaction, BlockChainTransaction {
    let coin: CoinType
    let address: String
    var balance: Double?
    var errorMessage: String?
    required init(coin: CoinType, address: String) {
        self.coin = coin
        self.address = address
        super.init()
    }

    override func makeNetworkRequest() {
        self.url = RequestBuilder.blockCypherRequest(coin: coin, address: address)
        super.makeNetworkRequest()
    }
    
    override func saveObjectsFromDict(dictionary: [String : Any]) -> [Any] {
        if let confirmedBalance = dictionary["confirmed_balance"] as? String,
            let castedBalance = Double(confirmedBalance) {
            balance = castedBalance
        }
        if let error = dictionary["error"] as? String {
            errorMessage = error
        }
        return []
    }
}

class BlockCypherTransaction: ApiTransaction, BlockChainTransaction {
    let coin: CoinType
    let address: String
    var balance: Double?
    var errorMessage: String?
    
    required init(coin: CoinType, address: String) {
        self.coin = coin
        self.address = address
        super.init()
    }
    
    override func makeNetworkRequest() {
        self.url = RequestBuilder.blockCypherRequest(coin: coin, address: address)
        super.makeNetworkRequest()
    }
    
    override func saveObjectsFromDict(dictionary: [String : Any]) -> [Any] {
        if let confirmedBalance = dictionary["balance"] as? Double {
            balance = (confirmedBalance / pow(10, 18))
        }
        if let error = dictionary["error"] as? String {
            errorMessage = error
        }
        return []
    }
}
