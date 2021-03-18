//
//  AppCoordinator.swift
//  News
//
//  Created by Yoyo on 3/17/21.
//

import UIKit

class AppCoordinator: CoordinateProtocol {
    var parentCoord: CoordinateProtocol?
    
    weak var viewController: UIViewController!
    var tabBarController: MainViewController {
        viewController as! MainViewController
    }
    
    private var window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func createViewControllerIfNeeded() {
        if viewController == nil {
            viewController = MainViewController.instantiate(storyboard: .main)
        }
    }
    
    @discardableResult
    func prepare() -> AppCoordinator {
        createViewControllerIfNeeded()

        tabBarController.viewControllers?.forEach({ (vc) in
            if let nc = vc as? UINavigationController {
                if let headlineVC = nc.viewControllers.first as? HeadlineViewController {
                    let coord = HeadlineCoordinator(parentCoord: self)
                    coord.viewController = headlineVC
                    coord.prepare()
                }
                else if let newsVC = nc.viewControllers.first as? NewsViewController {
                    let coord = NewsCoordinator(parentCoord: self)
                    coord.viewController =  newsVC
                    coord.prepare()
                }
                else if let profileVC = nc.viewControllers.first as? ProfileViewController {
                    let coord = ProfileCoordinator(parentCoord: self)
                    coord.viewController = profileVC
                    coord.prepare()
                }
            }
        })
        
        makeCosmetics()
        
        return self
    }
    
    func start() {
        self.window.rootViewController = viewController
        self.window.makeKeyAndVisible()
    }
    
    private func makeCosmetics() {
        self.window.backgroundColor = UIColor.white
    }
}
