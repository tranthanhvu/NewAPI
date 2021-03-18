//
//  User.swift
//  News
//
//  Created by Yoyo on 3/17/21.
//

import Foundation

public struct User: Codable, Equatable {
    let name: String
    var category: Category = .bitcoin
}
