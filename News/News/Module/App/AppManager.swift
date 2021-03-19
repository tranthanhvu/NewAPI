//
//  AppManager.swift
//  News
//
//  Created by Yoyo on 3/16/21.
//

import Foundation
import RxSwift
import RxCocoa

public class AppData {
    @Storage(key: "user", defaultValue: nil)
    static var user: User?
}

public class AppManager {
    public static let shared = AppManager()
    
    let disposeBag = DisposeBag()
    
    public let userInfo = BehaviorRelay<User?>(value: AppData.user)
    public var currentCategory: Category = .bitcoin
    
    public func start() {
        if let user = AppData.user {
            currentCategory = user.category
        }
        
        self.userInfo
            .asObservable()
            .skip(1)
            .bind(onNext: { value in
                AppData.user = value
            })
            .disposed(by: self.disposeBag)
    }
    
    public func changeCategory(_ category: Category) {
        if var info = userInfo.value, info.category != category {
            info.category = category
            userInfo.accept(info)
        }
        
        AppManager.shared.currentCategory = category
    }
    
    public func registerUser(name: String) {
        let newUser = User(name: name, category: currentCategory)
        userInfo.accept(newUser)
    }
    
    public func signOut() {
        userInfo.accept(nil)
    }
}
