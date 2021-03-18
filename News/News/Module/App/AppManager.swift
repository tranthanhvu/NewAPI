//
//  AppManager.swift
//  News
//
//  Created by Yoyo on 3/16/21.
//

import Foundation
import RxSwift
import RxCocoa

class AppData {
    @Storage(key: "user", defaultValue: nil)
    static var user: User?
}


class AppManager {
    static let shared = AppManager()
    
    let disposeBag = DisposeBag()
    
    let userInfo = BehaviorRelay<User?>(value: AppData.user)
    var currentCategory: Category = .animal
    
    func start() {
        self.userInfo
            .asObservable()
            .skip(1)
            .bind(onNext: { value in
                AppData.user = value
            })
            .disposed(by: self.disposeBag)
    }
    
    func changeCategory(_ category: Category) {
        if var info = userInfo.value, info.category != category {
            info.category = category
            userInfo.accept(info)
        }
        
        AppManager.shared.currentCategory = category
    }
    
    func registerUser(name: String) {
        let newUser = User(name: name, category: currentCategory)
        userInfo.accept(newUser)
    }
    
    func signOut() {
        userInfo.accept(nil)
    }
}
