//
//  Article.swift
//  News
//
//  Created by Yoyo on 3/17/21.
//

import Foundation

public struct Article: Codable, Hashable {
    let author: String
    let title: String
    let description: String
    let content: String
    let urlToImage: String
    let url: String
    let publishedAt: Date
    
    enum CodingKeys: String, CodingKey {
        case author = "author"
        case title = "title"
        case description = "description"
        case content = "content"
        case urlToImage = "urlToImage"
        case url = "url"
        case publishedAt = "publishedAt"
    }
    
    public init(author: String, title: String, description: String, content: String, urlToImage: String, url: String, publishedAt: Date) {
        self.author = author
        self.title = title
        self.description = description
        self.content = content
        self.urlToImage = urlToImage
        self.url = url
        self.publishedAt = publishedAt
    }
  
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        author = (try? container.decode(String.self, forKey: .author)) ?? ""
        title = (try? container.decode(String.self, forKey: .title)) ?? ""
        description = (try? container.decode(String.self, forKey: .description)) ?? ""
        content = (try? container.decode(String.self, forKey: .content)) ?? ""
        urlToImage = (try? container.decode(String.self, forKey: .urlToImage)) ?? ""
        url = (try? container.decode(String.self, forKey: .url)) ?? ""
        
        let strPublishedAt = (try? container.decode(String.self, forKey: .publishedAt)) ?? ""
        publishedAt = FormatHelper.dateFormatterOnServer.date(from: strPublishedAt) ?? Date()
    }
    
    public func encode(to encoder: Encoder) throws {
        // DO NOTHING
    }
}
