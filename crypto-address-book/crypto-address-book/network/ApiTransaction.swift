//
//  ApiTransaction.swift
//  mamawhatscooking
//
//  Created by Mario Lin on 5/13/17.
//  Copyright © 2017 Mario Lin. All rights reserved.
//

import Foundation
typealias DataTaskCompletionBlock = (_ transaction: ApiTransaction, _ objects: [Any]?, _ response: URLResponse?, _ error: Error?) -> ()

class ApiTransaction: NSObject {
    let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
    var url: URL?
    var completion: DataTaskCompletionBlock?
    var didSucceed: Bool = false
    var canceled: Bool = false
    
    // MARK: URLSession
    func makeNetworkRequest() {
        guard let parsedUrl = parseParamsWithURL() else { fatalError("malformed url") }
        print("API get request: " + parsedUrl.absoluteString)
        let datatask = defaultSession.dataTask(with: parsedUrl) { (data, response, error) in
            if error == nil {
                self.didSucceed = true
            }
            guard let data = data, let response = response else {
                DispatchQueue.main.async {
                    self.completion?(self, nil, nil, error)
                }
                return
            }
            let dict = self.serializeDataToJson(data: data)
            let savedObjects = self.saveObjectsFromDict(dictionary: dict)
            DispatchQueue.main.async {
                self.completion?(self, savedObjects, response, error)
            }
        }
        datatask.resume()
    }
    
    // MARK: Serialization
    func parseParamsWithURL() -> URL? {
        guard let url = url else { return nil }
        if let wellformedUrl = url.absoluteString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            return URL(string: wellformedUrl)
        }
        return nil
    }
    
    func serializeDataToJson(data: Data) -> [String: Any] {
        var json = Dictionary<String, Any>()
        do {
            json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String:Any]
        } catch let error as NSError {
            print(error)
        }
        return json
    }
    
    // MARK: Subclass required overrides
    func saveObjectsFromDict(dictionary: [String: Any]) -> [Any] {
        // override
        fatalError("subclass must override")
    }
    
}
