//
//  Response.swift
//  News
//
//  Created by Yoyo on 3/17/21.
//

import Foundation

public struct Response: Codable {
    var status: String = ""
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
        status = try container.decode(String.self, forKey: .status)
        code = (try? container.decode(String.self, forKey: .code)) ?? nil
        message = (try? container.decode(String.self, forKey: .message)) ?? nil
        totalResults = (try? container.decode(Int.self, forKey: .totalResults)) ?? 0
        articles = (try? container.decode([Article].self, forKey: .articles)) ?? [Article]()
    }
    
    public func encode(to encoder: Encoder) throws {
        // DO NOTHING
    }
}
