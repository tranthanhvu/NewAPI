//
//  UIViewController+Alert.swift
//  GooDic
//
//  Created by ttvu on 5/18/20.
//  Copyright © 2020 paxcreation. All rights reserved.
//

import UIKit

extension UIViewController {
    func alert(message: String, title: String = "", okActionTitle: String = "Close") {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: okActionTitle, style: .cancel, handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        })
    }
}

