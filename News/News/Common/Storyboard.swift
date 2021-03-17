//
//  Storyboard.swift
//  GooDic
//
//  Created by ttvu on 5/18/20.
//  Copyright © 2020 paxcreation. All rights reserved.
//

import UIKit

enum Storyboard: String {
    case main = "Main"
    case headline = "Headline"
    case news = "News"
    case profile = "Profile"
    case article = "Article"
    
    var storyboard: UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: nil)
    }
}

protocol ViewControllerLoadable {
    static func instantiate(storyboard: Storyboard) -> Self
}

extension UIViewController: ViewControllerLoadable {}

extension ViewControllerLoadable where Self: UIViewController {
    static func instantiate(storyboard: Storyboard) -> Self {
        let id = String(describing: Self.self)
        let vcStoryboard = storyboard.storyboard
                 
        let vc = vcStoryboard.instantiateViewController(withIdentifier: id) as! Self
        return vc
    }
}

extension UIStoryboard {
    static func loadViewController<T>(name: String = String(describing: T.self), bundle: Bundle? = nil) -> T {
        return UIStoryboard(name: name, bundle: bundle).instantiateInitialViewController() as! T
    }
}
