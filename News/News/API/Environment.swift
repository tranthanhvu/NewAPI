//
//  Environment.swift
//  News
//
//  Created by Yoyo on 3/17/21.
//

import Foundation

enum Environment {
    enum Keys: String {
        case host = "API_HOST"
        case key = "API_KEY"
        case headline = "API_EP_HEADLINE"
        case source = "API_EP_SOURCE"
    }
    
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Plist file not found")
        }
        return dict
    }()
    
    static func value(fromKey key: Keys) -> String {
            guard let value = Environment.infoDictionary[key.rawValue] as? String else {
                fatalError("\(key.rawValue) not set in plist for this environment")
            }
            
            return value
        }
    
    static let host: String = {
        value(fromKey: .host)
    }()
 
    static let key: String = {
        value(fromKey: .key)
    }()
    
    static let endpointSource: String = {
        value(fromKey: .source)
    }()
    
    static let endpointHeadline: String = {
        value(fromKey: .headline)
    }()
}
