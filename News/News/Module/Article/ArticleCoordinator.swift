//
//  ArticleCoordinator.swift
//  News
//
//  Created by Yoyo on 3/17/21.
//

import UIKit
import SafariServices

protocol ArticleNavigateProtocol {
    func openWebView(url: URL)
}

class ArticleCoordinator: CoordinateProtocol {
    var parentCoord: CoordinateProtocol?
    
    weak var viewController: UIViewController!
    
    init(parentCoord: CoordinateProtocol) {
        self.parentCoord = parentCoord
    }
    
    private func createViewControllerIfNeeded() {
        if viewController == nil {
            viewController = ArticleViewController.instantiate(storyboard: .article)
        }
    }
    
    @discardableResult
    func prepare(article: Article) -> CoordinateProtocol {
        createViewControllerIfNeeded()
        guard let vc = viewController as? ArticleViewController else {
            return self
        }
        
        let viewModel = ArticleViewModel(article: article,
                                         navigator: self)
        vc.bindViewModel(viewModel)
        
        return self
    }
}

extension ArticleCoordinator: ArticleNavigateProtocol {
    func openWebView(url: URL) {
        let safari = SFSafariViewController(url: url)
        viewController.present(safari, animated: true, completion: nil)
    }
}
