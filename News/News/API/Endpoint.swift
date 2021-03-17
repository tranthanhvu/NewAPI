//
//  Endpoint.swift
//  News
//
//  Created by Yoyo on 3/17/21.
//

import Foundation

enum Endpoint {
    case headlines
    case news(Category)
    
    var url: URL? {
        switch self {
        case .headlines:
            var urlComponents = URLComponents(string: Environment.host + Environment.endpointHeadline)
            urlComponents?.queryItems = [
                URLQueryItem(name: "apiKey", value: Environment.key),
                URLQueryItem(name: "country", value: "us")
            ]
            
            return urlComponents?.url
        case .news(let category):
            var urlComponents = URLComponents(string: Environment.host + Environment.endpointEverything)
            urlComponents?.queryItems = [
                URLQueryItem(name: "apiKey", value: Environment.key),
                URLQueryItem(name: "q", value: category.rawValue)
            ]
            
            return urlComponents?.url
        }
    }
}
