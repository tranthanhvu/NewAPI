//
//  ProfileViewModel.swift
//  News
//
//  Created by Yoyo on 3/18/21.
//

import Foundation
import RxSwift
import RxCocoa

enum CellType: Equatable {
    case userInfo(String)
    case categoryInfo(String)
    case register
    case signOut
}

class ProfileViewModel {
    
}

extension ProfileViewModel: ViewModelProtocol {
    struct Input {
        let registerWithName: Driver<String>
        let changeCategory: Driver<Category>
        let signOut: Driver<Void>
    }
    
    struct Output {
        let items: Driver<[CellType]>
        let selectedCell: Driver<Void>
    }
    
    func transform(_ input: Input) -> Output {
        let loadDataTrigger = Driver.just(())
        
        let items = Driver.merge(loadDataTrigger, AppManager.shared.userInfo.asDriver().mapToVoid())
            .withLatestFrom(AppManager.shared.userInfo.asDriver())
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
