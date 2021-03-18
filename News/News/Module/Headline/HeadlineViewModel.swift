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
    let navigator: HeadlineNavigateProtocol
    let newAPI: NewsAPIProtocol
    
    init(navigator: HeadlineNavigateProtocol, newsAPI: NewsAPIProtocol) {
        self.navigator = navigator
        self.newAPI = newsAPI
    }
}

extension HeadlineViewModel: ViewModelProtocol, PagingFeature {
    struct Input {
        let loadTrigger: Driver<Void>
        let reloadTrigger: Driver<Void>
        let loadMoreTrigger: Driver<Void>
        
        let selectCell: Driver<IndexPath>
    }
    
    struct Output {
        let error: Driver<Error>
        let isLoading: Driver<Bool>
        let isReloading: Driver<Bool>
        let isLoadingMore: Driver<Bool>
        let items: Driver<[Article]>
        let openDetail: Driver<Void>
    }
    
    func transform(_ input: Input) -> Output {
        let getPageResult = getPage(loadTrigger: input.loadTrigger,
                                    reloadTrigger: input.reloadTrigger,
                                    loadMoreTrigger: input.loadMoreTrigger,
                                    getItems: { [weak self] (offset) -> Observable<PagingInfo<Article>> in
                                        guard let self = self else {
                                            return Observable.empty()
                                        }
                                        
                                        return self.newAPI.fetchHeadlines(offset: offset)
                                    })
        
        let items = getPageResult.page.map({ $0.items })

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
            error: getPageResult.error,
            isLoading: getPageResult.isLoading,
            isReloading: getPageResult.isReloading,
            isLoadingMore: getPageResult.isLoadingMore,
            items: items,
            openDetail: openDetail
        )
    }
}
