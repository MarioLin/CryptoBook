//
//  UserDefaultsManager.swift
//  crypto-address-book
//
//  Created by Mario Lin on 2/15/18.
//  Copyright © 2018 Mario Lin. All rights reserved.
//

import UIKit

fileprivate let UDvalidateTimeStampKey = "UDvalidateTimeStampKey"

class UserDefaultsManager {
    private static var sharedManager = UserDefaultsManager()
    
    func setLastSeenValidTimeStamp() {
        let timestamp = Date().timeIntervalSince1970
        UserDefaults.standard.set(timestamp, forKey: UDvalidateTimeStampKey)
    }
    
    func getLastSeenValidTimeStamp() -> TimeInterval? {
        guard let lastSeenTimestamp = UserDefaults.standard.value(forKey: UDvalidateTimeStampKey) as? TimeInterval else { return nil }
        return lastSeenTimestamp
    }
    
    func isValidTimeStamp() -> Bool {
        guard let timeStamp = getLastSeenValidTimeStamp() else { return true }
        let currentTimeStamp = Date().timeIntervalSince1970
        return currentTimeStamp - timeStamp > 5
    }
    
    class func shared() -> UserDefaultsManager {
        return sharedManager
    }
}
