//
//  API.swift
//  News
//
//  Created by Yoyo on 3/16/21.
//

import Foundation
import RxSwift
import RxCocoa

struct APIHelper {
    public static func request(url: URL) -> Observable<Response> {
        let request = URLRequest(url: url)
        
        return URLSession.shared.rx.response(request: request)
            .flatMapLatest ({ (data) -> Observable<Response> in
                do {
                    let obj = try JSONDecoder().decode(Response.self, from: data.data)
                    return Observable.just(obj)
                } catch let error {
                    return Observable.error(error)
                }
            })
    }
}

public protocol NewsAPIProtocol {
    func fetchHeadlines(offset: Int) -> Observable<PagingInfo<Article>>
    func fetchNews(category: Category, offset: Int) -> Observable<PagingInfo<Article>>
}

public struct NewsAPI: NewsAPIProtocol {
    
    public func fetchHeadlines(offset: Int) -> Observable<PagingInfo<Article>> {
        guard let page = Endpoint.getNextPage(offset: offset),
              let url = Endpoint.headlines.getUrl(page: page) else {
            return Observable.empty()
        }
        
        return APIHelper.request(url: url)
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
    
    public func fetchNews(category: Category, offset: Int) -> Observable<PagingInfo<Article>> {
        guard let page = Endpoint.getNextPage(offset: offset),
              let url = Endpoint.news(category).getUrl(page: page) else {
            return Observable.empty()
        }
        
        return APIHelper.request(url: url)
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
