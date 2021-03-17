//
//  ArticleViewModel.swift
//  News
//
//  Created by Yoyo on 3/17/21.
//

import Foundation
import RxSwift
import RxCocoa

class ArticleViewModel {
    var article: Article
    var navigator: ArticleNavigateProtocol
    
    init(article: Article, navigator: ArticleNavigateProtocol) {
        self.article = article
        self.navigator = navigator
    }
}

extension ArticleViewModel: ViewModelProtocol {
    struct Input {
        let viewDidLoad: Driver<Void>
        let tapDetail: Driver<Void>
    }
    
    struct Output {
        let data: Driver<Article>
        let openWebView: Driver<Void>
    }
    
    func transform(_ input: Input) -> Output {
        
        let data = input.viewDidLoad
            .map({ [article] _ in article })
        
        let openWebView = input.tapDetail
            .withLatestFrom(data)
            .compactMap({ URL(string: $0.url) })
            .do(onNext: { [weak self] in
                self?.navigator.openWebView(url: $0)
            })
            .mapToVoid()
        
        return Output(
            data: data,
            openWebView: openWebView
        )
    }
}
