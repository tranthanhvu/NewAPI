//
//  Endpoint.swift
//  News
//
//  Created by Yoyo on 3/17/21.
//

import Foundation

public enum Endpoint {
    case headlines
    case news(Category)
    
    public static let pageSize = 20
    
    public static func getNextPage(offset: Int) -> Int? {
        if offset % Endpoint.pageSize == 0 {
            return (offset / Endpoint.pageSize) + 1
        }
        
        return nil
    }
    
    public func getUrl(page: Int) -> URL? {
        switch self {
        case .headlines:
            var urlComponents = URLComponents(string: Environment.host + Environment.endpointHeadline)
            urlComponents?.queryItems = [
                URLQueryItem(name: "apiKey", value: Environment.key),
                URLQueryItem(name: "country", value: "us"),
                URLQueryItem(name: "pageSize", value: "\(Endpoint.pageSize)"),
                URLQueryItem(name: "page", value: "\(page)")
            ]
            
            return urlComponents?.url
        case .news(let category):
            var urlComponents = URLComponents(string: Environment.host + Environment.endpointEverything)
            urlComponents?.queryItems = [
                URLQueryItem(name: "apiKey", value: Environment.key),
                URLQueryItem(name: "q", value: category.rawValue),
                URLQueryItem(name: "pageSize", value: "\(Endpoint.pageSize)"),
                URLQueryItem(name: "page", value: "\(page)")
            ]
            
            return urlComponents?.url
        }
    }
}
