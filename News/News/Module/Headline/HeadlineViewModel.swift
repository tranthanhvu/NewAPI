//
//  HeadlineViewModel.swift
//  News
//
//  Created by Yoyo on 3/17/21.
//

import Foundation
import RxSwift
import RxCocoa

class HeadlineViewModel {
    
}

extension HeadlineViewModel: ViewModelProtocol {
    struct Input {
        let loadTrigger: Driver<Void>
        let reloadTrigger: Driver<Void>
        let loadMoreTrigger: Driver<Void>
    }
    
    struct Output {
        let items: Driver<[Article]>
    }
    
    func transform(_ input: Input) -> Output {
        let items = input.loadTrigger
            .flatMapFirst ({ _ -> Driver<[Article]> in
                let url = Endpoint.headlines.url!
                return API.request(url: url)
                    .asDriver(onErrorJustReturn: Response())
                    .map { (response) -> [Article] in
                        return response.articles ?? []
                    }
                    .debug("bbb")
            })
            .startWith([])
            .debug("aaa")
            
        
//            Driver.just([
//            Article(author: "1", title: "1", description: "1", urlToImage: "1", url: "1", publishedAt: Date()),
//            Article(author: "2", title: "2", description: "2", urlToImage: "2", url: "2", publishedAt: Date())
//        ])
        
        
        return Output(items: items)
    }
}
