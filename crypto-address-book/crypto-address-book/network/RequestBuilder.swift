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
        let requestString = "https://chain.so/api/v2/get_address_balance/\(CoinType.coinTypeToString(coin))/\(address)"
        return URL(string: requestString)
    }
    
    static func blockCypherRequest(coin: CoinType, address: String) -> URL? {
        let requestString = "https://api.blockcypher.com/v1/\(CoinType.coinTypeToString(coin))/main/addrs/\(address)/balance"
        return URL(string: requestString)

    }
}

protocol BlockChainTransaction {
    var coin: CoinType { get }
    var address: String { get }
    init(coin: CoinType, address: String)
}

class SoChainTransaction: ApiTransaction, BlockChainTransaction {
    let coin: CoinType
    let address: String
    
    required init(coin: CoinType, address: String) {
        self.coin = coin
        self.address = address
        super.init()
    }

    override func makeNetworkRequest() {
        self.url = RequestBuilder.blockCypherRequest(coin: coin, address: address)
        makeNetworkRequest()
    }
    
    override func saveObjectsFromDict(dictionary: [String : Any]) -> [Any] {
        return []
    }
}

class BlockCypherTransaction: ApiTransaction, BlockChainTransaction {
    let coin: CoinType
    let address: String
    
    required init(coin: CoinType, address: String) {
        self.coin = coin
        self.address = address
        super.init()
    }
    
    override func makeNetworkRequest() {
        self.url = RequestBuilder.blockCypherRequest(coin: coin, address: address)
        makeNetworkRequest()
    }
    
    override func saveObjectsFromDict(dictionary: [String : Any]) -> [Any] {
        return []
    }
}
