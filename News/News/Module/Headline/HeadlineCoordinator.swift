//
//  HeadlineCoordinator.swift
//  News
//
//  Created by Yoyo on 3/17/21.
//

import UIKit

protocol HeadlineNavigateProtocol {
    func openDetail(article: Article)
}

class HeadlineCoordinator: CoordinateProtocol {
    var parentCoord: CoordinateProtocol?
    
    weak var viewController: UIViewController!
    
    init(parentCoord: CoordinateProtocol) {
        self.parentCoord = parentCoord
    }
    
    private func createViewControllerIfNeeded() {
        if viewController == nil {
            viewController = HeadlineViewController.instantiate(storyboard: .headline)
        }
    }
    
    @discardableResult
    func prepare() -> CoordinateProtocol {
        createViewControllerIfNeeded()
        guard let vc = viewController as? HeadlineViewController else {
            return self
        }
        
        let viewModel = HeadlineViewModel(navigator: self)
        vc.bindViewModel(viewModel)
        
        return self
    }
}

extension HeadlineCoordinator: HeadlineNavigateProtocol {
    func openDetail(article: Article) {
        ArticleCoordinator(parentCoord: self)
            .prepare(article: article)
            .push()
    }
}
