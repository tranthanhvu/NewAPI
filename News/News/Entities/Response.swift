//
//  Response.swift
//  News
//
//  Created by Yoyo on 3/17/21.
//

import Foundation

public enum ResponseStatus: String {
    case ok = "ok"
    case error = "error"
}

public struct Response: Codable {
    var status: ResponseStatus = .error
    var code: String? = nil
    var message: String? = nil
    var totalResults: Int? = nil
    var articles: [Article]? = nil
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case code = "code"
        case message = "message"
        case totalResults = "totalResults"
        case articles = "articles"
    }
    
    init() {
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let strStatus = try container.decode(String.self, forKey: .status)
        if let status = ResponseStatus(rawValue: strStatus) {
            self.status = status
        }
        
        code = (try? container.decode(String.self, forKey: .code)) ?? nil
        message = (try? container.decode(String.self, forKey: .message)) ?? nil
        totalResults = (try? container.decode(Int.self, forKey: .totalResults)) ?? 0
        articles = (try? container.decode([Article].self, forKey: .articles)) ?? [Article]()
    }
    
    public func encode(to encoder: Encoder) throws {
        // DO NOTHING
    }
}
