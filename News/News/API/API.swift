//
//  API.swift
//  News
//
//  Created by Yoyo on 3/16/21.
//

import Foundation
import RxSwift
import RxCocoa

public enum APIError: Error {
    case other(Int, String) // code, message
}

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
            .timeout(.seconds(5), scheduler: MainScheduler.instance)
            .retry(3, shouldRetry: { !($0 is APIError) })
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
            .flatMap({ (response) -> Observable<PagingInfo<Article>> in
                let parser = NewsAPI.parse(response: response, offset: offset)
                
                switch parser {
                case .success(let paging): return Observable.just(paging)
                case .failure(let error): return Observable.error(error)
                }
            })
    }
    
    public func fetchNews(category: Category, offset: Int) -> Observable<PagingInfo<Article>> {
        guard let page = Endpoint.getNextPage(offset: offset),
              let url = Endpoint.news(category).getUrl(page: page) else {
            return Observable.empty()
        }
        
        return APIHelper.request(url: url)
            .flatMap({ (response) -> Observable<PagingInfo<Article>> in
                let parser = NewsAPI.parse(response: response, offset: offset)
                
                switch parser {
                case .success(let paging): return Observable.just(paging)
                case .failure(let error): return Observable.error(error)
                }
            })
    }
    
    static func parse(response: Response, offset: Int) -> Result<PagingInfo<Article>, APIError> {
        if response.status == .ok {
            let items = response.articles ?? []
            let total = response.totalResults ?? 0
            let paging = PagingInfo(offset: offset,
                                    limit: Endpoint.pageSize,
                                    totalItems: response.totalResults ?? 0,
                                    hasMorePages: offset + items.count < total,
                                    items: items)
            
            return Result.success(paging)
        } else {
            let code = Int(response.code ?? "0") ?? 0
            let message = response.message ?? ""
            
            return Result.failure(APIError.other(code, message))
        }
    }
}
