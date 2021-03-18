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

extension NewsViewModel: ViewModelProtocol, PagingFeature {
    struct Input {
        let loadTrigger: Driver<Void>
        let reloadTrigger: Driver<Void>
        let loadMoreTrigger: Driver<Void>
        
        let selectCell: Driver<IndexPath>
        let changeCategory: Driver<Category>
    }
    
    struct Output {
        let error: Driver<Error>
        let isLoading: Driver<Bool>
        let isReloading: Driver<Bool>
        let isLoadingMore: Driver<Bool>
        let items: Driver<[Article]>
        let category: Driver<Category>
        let actions: Driver<Void>
    }
    
    func transform(_ input: Input) -> Output {
        
        let updatedCategory = input.changeCategory
            .do(onNext: {
                AppManager.shared.changeCategory($0)
            })
            .mapToVoid()
        
        let category = Driver
            .merge(
                input.loadTrigger,
                AppManager.shared.userInfo.asDriver().mapToVoid(),
                updatedCategory)
            .withLatestFrom(AppManager.shared.userInfo.asDriver())
            .map({ $0 == nil ? AppManager.shared.currentCategory : $0!.category })
            .distinctUntilChanged()
        
        let loadTrigger = Driver
            .merge(
                input.loadTrigger,
                category.mapToVoid())
            .withLatestFrom(category)
            .distinctUntilChanged()
            .mapToVoid()
        
        let getPageResult = getPage(loadTrigger: loadTrigger,
                                    reloadTrigger: input.reloadTrigger,
                                    loadMoreTrigger: input.loadMoreTrigger,
                                    getItems: { (offset) -> Observable<PagingInfo<Article>> in
                                        return Observable.just(())
                                            .withLatestFrom(category)
                                            .flatMapFirst({ [weak self] category -> Observable<PagingInfo<Article>> in
                                                guard let self = self else {
                                                    return Observable.empty()
                                                }
                                                
                                                return self.fetchData(category: category, offset: offset)
                                            })
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
        
        let actions = Driver.merge(openDetail, updatedCategory)
        
        return Output(
            error: getPageResult.error,
            isLoading: getPageResult.isLoading,
            isReloading: getPageResult.isReloading,
            isLoadingMore: getPageResult.isLoadingMore,
            items: items,
            category: category,
            actions: actions
        )
    }
    
    func fetchData(category: Category, offset: Int) -> Observable<PagingInfo<Article>> {
        guard let page = Endpoint.getNextPage(offset: offset),
              let url = Endpoint.news(category).getUrl(page: page) else {
            return Observable.empty()
        }
        
        return API.request(url: url)
            .map({ response -> PagingInfo<Article> in
                let items = response.articles ?? []
                let total = response.totalResults ?? 0
                return PagingInfo(offset: offset,
                                  limit: Endpoint.pageSize,
                                  totalItems: response.totalResults ?? 0,
                                  hasMorePages: offset + items.count < total,
                                  items: items)
            })
    }
}
