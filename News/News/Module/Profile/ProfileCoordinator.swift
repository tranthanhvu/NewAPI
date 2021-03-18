//
//  ProfileCoordinator.swift
//  News
//
//  Created by Yoyo on 3/18/21.
//

import UIKit

class ProfileCoordinator: CoordinateProtocol {
    var parentCoord: CoordinateProtocol?
    
    weak var viewController: UIViewController!
    
    init(parentCoord: CoordinateProtocol) {
        self.parentCoord = parentCoord
    }
    
    private func createViewControllerIfNeeded() {
        if viewController == nil {
            viewController = ProfileViewController.instantiate(storyboard: .profile)
        }
    }
    
    @discardableResult
    func prepare() -> CoordinateProtocol {
        createViewControllerIfNeeded()
        guard let vc = viewController as? ProfileViewController else {
            return self
        }
        
        let viewModel = ProfileViewModel()
        vc.bindViewModel(viewModel)
        
        return self
    }
}
