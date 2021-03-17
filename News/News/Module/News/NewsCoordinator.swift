//
//  NewsCoordinator.swift
//  News
//
//  Created by Yoyo on 3/18/21.
//

import UIKit

protocol NewsNavigateProtocol {
    func openDetail(article: Article)
}

class NewsCoordinator: CoordinateProtocol {
    var parentCoord: CoordinateProtocol?
    
    weak var viewController: UIViewController!
    
    init(parentCoord: CoordinateProtocol) {
        self.parentCoord = parentCoord
    }
    
    private func createViewControllerIfNeeded() {
        if viewController == nil {
            viewController = NewsViewController.instantiate(storyboard: .news)
        }
    }
    
    @discardableResult
    func prepare() -> CoordinateProtocol {
        createViewControllerIfNeeded()
        guard let vc = viewController as? NewsViewController else {
            return self
        }
        
        let viewModel = NewsViewModel(navigator: self)
        vc.bindViewModel(viewModel)
        
        return self
    }
}

extension NewsCoordinator: NewsNavigateProtocol {
    func openDetail(article: Article) {
        ArticleCoordinator(parentCoord: self)
            .prepare(article: article)
            .push()
    }
}
