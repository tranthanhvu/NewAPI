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
        let openDetail: Driver<Void>
    }
    
    func transform(_ input: Input) -> Output {
        
        let defaultCategory = Driver.just(Category.bitcoin)
        
        let category = Driver.just(Category.bitcoin)
            
        let items = input.changeCategory
            .do(onNext: {
                AppManager.shared.changeCategory($0)
            })
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
        
        return Output(
            items: items,
            category: category,
            openDetail: openDetail
        )
    }
}
