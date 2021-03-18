//
//  MockNewsAPI.swift
//  NewsTests
//
//  Created by Yoyo on 3/19/21.
//

import Foundation
import RxSwift
import News

struct MockNewsAPI: NewsAPIProtocol {
    let totalItems: Int
    
    func fetchHeadlines(offset: Int) -> Observable<PagingInfo<Article>> {
        guard
            offset < totalItems,
            let _ = Endpoint.getNextPage(offset: offset) else {
            return Observable.error(NSError())
        }
        
        let maxOffset = min(offset + Endpoint.pageSize, totalItems)
        let items = (offset..<maxOffset).map({ index -> Article in
            let str = "\(index)"
            return Article(author: str, title: str, description: str, content: str, urlToImage: "", url: "", publishedAt: Date())
        })
        
        let pagingInfo = PagingInfo(offset: offset,
                                    limit: Endpoint.pageSize,
                                    totalItems: totalItems,
                                    hasMorePages: offset + items.count < totalItems,
                                    items: items)
        
        return Observable.just(pagingInfo)
    }
    
    func fetchNews(category: News.Category, offset: Int) -> Observable<PagingInfo<Article>> {
        Observable.empty()
    }
}
