//
//  Article.swift
//  News
//
//  Created by Yoyo on 3/17/21.
//

import Foundation

struct Article: Codable, Hashable {
    let author: String
    let title: String
    let description: String
    let urlToImage: String
    let url: String
    let publishedAt: Date
}
