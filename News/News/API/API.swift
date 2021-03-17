//
//  API.swift
//  News
//
//  Created by Yoyo on 3/16/21.
//

import Foundation
import RxSwift
import RxCocoa

struct API {
    static func request(url: URL) -> Observable<Response> {
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
