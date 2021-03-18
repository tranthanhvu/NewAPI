//
//  ProfileViewModel.swift
//  News
//
//  Created by Yoyo on 3/18/21.
//

import Foundation
import RxSwift
import RxCocoa

public enum CellType: Equatable {
    case userInfo(String)
    case categoryInfo(String)
    case register
    case signOut
}

public class ProfileViewModel {
    public init() {}
}

extension ProfileViewModel: ViewModelProtocol {
    public struct Input {
        public let userInfo: Driver<User?>
        public let registerWithName: Driver<String>
        public let changeCategory: Driver<Category>
        public let signOut: Driver<Void>
        
        public init(userInfo: Driver<User?>, registerWithName: Driver<String>, changeCategory: Driver<Category>, signOut: Driver<Void>) {
            self.userInfo = userInfo
            self.registerWithName = registerWithName
            self.changeCategory = changeCategory
            self.signOut = signOut
        }
    }
    
    public struct Output {
        public let items: Driver<[CellType]>
        public let selectedCell: Driver<Void>
    }
    
    public func transform(_ input: Input) -> Output {
        let loadDataTrigger = Driver.just(())
        
        let items = Driver.merge(loadDataTrigger, input.userInfo.mapToVoid())
            .withLatestFrom(input.userInfo)
            .distinctUntilChanged()
            .map({ user -> [CellType] in
                if let user = user {
                    return [
                        .userInfo(user.name),
                        .categoryInfo(user.category.rawValue),
                        .signOut
                    ]
                } else {
                    return [.register]
                }
            })
        
        let registered = input.registerWithName
            .filter({ !$0.isEmpty })
            .do(onNext: { name in
                AppManager.shared.registerUser(name: name)
            })
            .mapToVoid()
        
        let changedCategory = input.changeCategory
            .do(onNext: { category in
                AppManager.shared.changeCategory(category)
            })
            .mapToVoid()
        
        let signedOut = input.signOut
            .do(onNext: {
                AppManager.shared.signOut()
            })
        
        let selectedCell = Driver.merge(registered, changedCategory, signedOut)
        
        return Output(
            items: items,
            selectedCell: selectedCell
        )
    }
}
