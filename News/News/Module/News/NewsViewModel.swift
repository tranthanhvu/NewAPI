//
//  NewsViewModel.swift
//  News
//
//  Created by Yoyo on 3/18/21.
//

import Foundation
import RxSwift
import RxCocoa

class NewsViewModel {
    let navigator: NewsNavigateProtocol
    
    init(navigator: NewsNavigateProtocol) {
        self.navigator = navigator
    }
}

extension NewsViewModel: ViewModelProtocol {
    struct Input {
        let loadTrigger: Driver<Void>
        let reloadTrigger: Driver<Void>
        let loadMoreTrigger: Driver<Void>
        
        let selectCell: Driver<IndexPath>
        let changeCategory: Driver<Category>
    }
    
    struct Output {
        let items: Driver<[Article]>
        let category: Driver<Category>
        let actions: Driver<Void>
    }
    
    func transform(_ input: Input) -> Output {
        
        let category = Driver
            .merge(
                input.loadTrigger,
                AppManager.shared.userInfo.asDriver().mapToVoid())
            .withLatestFrom(AppManager.shared.userInfo.asDriver())
            .map({ $0 == nil ? Category.bitcoin : $0!.category })
            
        let updatedCategory = input.changeCategory
            .do(onNext: {
                AppManager.shared.changeCategory($0)
            })
            .mapToVoid()
        
        let items = Driver
            .merge(
                input.loadTrigger,
                category.mapToVoid())
            .withLatestFrom(category)
            .flatMapFirst ({ category -> Driver<[Article]> in
                let url = Endpoint.news(category).url!
                
                return API.request(url: url)
                    .asDriver(onErrorJustReturn: Response())
                    .map { (response) -> [Article] in
                        return response.articles ?? []
                    }
            })
            .startWith([])

        let openDetail = input.selectCell
            .withLatestFrom(items) { (indexPath, list) -> Article? in
                if list.count > indexPath.row {
                    return list[indexPath.row]
                }
                
                return nil
            }
            .compactMap({ $0 })
            .do(onNext: { [weak self] in
                self?.navigator.openDetail(article: $0)
            })
            .mapToVoid()
        
        let actions = Driver.merge(openDetail, updatedCategory)
        
        return Output(
            items: items,
            category: category,
            actions: actions
        )
    }
}
