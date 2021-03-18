//
//  MockViewModel.swift
//  NewsTests
//
//  Created by Yoyo on 3/19/21.
//

import Foundation
import RxSwift
import RxCocoa
import News

class MockViewModel {
    let newsAPI: NewsAPIProtocol
    
    init(newsAPI: NewsAPIProtocol) {
        self.newsAPI = newsAPI
    }
}

extension MockViewModel: ViewModelProtocol, PagingFeature {
    struct Input {
        let loadTrigger: Driver<Void>
        let reloadTrigger: Driver<Void>
        let loadMoreTrigger: Driver<Void>
    }
    
    struct Output {
        let items: Driver<[Article]>
    }
    
    func transform(_ input: Input) -> Output {
        
        let getPageResults = getPage(loadTrigger: input.loadTrigger,
                                     reloadTrigger: input.reloadTrigger,
                                     loadMoreTrigger: input.loadMoreTrigger,
                                     getItems: { [weak self] offset -> Observable<PagingInfo<Article>> in
                                        guard let self = self else {
                                            return Observable.empty()
                                        }
                                        
                                        return self.newsAPI.fetchHeadlines(offset: offset)
                                     })
        
        let items = getPageResults.page.map({ $0.items })
        
        return Output(items: items)
    }
}
