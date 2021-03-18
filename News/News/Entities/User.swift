//
//  User.swift
//  News
//
//  Created by Yoyo on 3/17/21.
//

import Foundation

struct User: Codable {
    let name: String
    var category: Category = .bitcoin
}
