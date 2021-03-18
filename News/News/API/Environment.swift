//
//  Environment.swift
//  News
//
//  Created by Yoyo on 3/17/21.
//

import Foundation

public enum Environment {
    public enum Keys: String, CaseIterable {
        case host = "API_HOST"
        case key = "API_KEY"
        case headline = "API_EP_HEADLINE"
        case everything = "API_EP_EVERYTHING"
    }
    
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Plist file not found")
        }
        return dict
    }()
    
    public static func valueOrNil(fromKey key: Keys) -> String? {
        Environment.infoDictionary[key.rawValue] as? String
    }
    
    public static func value(fromKey key: Keys) -> String {
        guard let value = valueOrNil(fromKey: key) else {
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
    
    static let endpointEverything: String = {
        value(fromKey: .everything)
    }()
    
    static let endpointHeadline: String = {
        value(fromKey: .headline)
    }()
}
