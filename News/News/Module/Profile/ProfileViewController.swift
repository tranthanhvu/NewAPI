//
//  ProfileViewController.swift
//  News
//
//  Created by Yoyo on 3/16/21.
//

import UIKit

class ProfileViewController: UIViewController, ViewBindableProtocol {

    // MARK: - Rx + Data
    var viewModel: ProfileViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func bindViewModel() {
        let input = ProfileViewModel.Input()
        
        let output = viewModel.transform(input)
    }
}
