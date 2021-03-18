//
//  ViewModelProtocol.swift
//  News
//
//  Created by Yoyo on 3/17/21.
//

import Foundation

public protocol ViewModelProtocol {
    associatedtype Input
    associatedtype Output
    
    func transform(_ input: Input) -> Output
}
