//
//  Endpoint.swift
//  News
//
//  Created by Yoyo on 3/17/21.
//

import Foundation

enum Endpoint {
    case headlines
    case news
    
    var url: URL? {
        switch self {
        case .headlines:
            var urlComponents = URLComponents(string: Environment.host + Environment.endpointHeadline)
            urlComponents?.queryItems = [URLQueryItem(name: "apiKey", value: Environment.key)]
            urlComponents?.queryItems = [URLQueryItem(name: "country", value: "us")]
            return urlComponents?.url
        case .news:
            var urlComponents = URLComponents(string: Environment.host + Environment.endpointSource)
            urlComponents?.queryItems = [URLQueryItem(name: "apiKey", value: Environment.key)]
            urlComponents?.queryItems = [URLQueryItem(name: "country", value: "us")]
            
            return urlComponents?.url
        }
    }
}
