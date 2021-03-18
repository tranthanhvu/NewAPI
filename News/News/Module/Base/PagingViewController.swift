//
//  PagingViewController.swift
//  News
//
//  Created by Yoyo on 3/18/21.
//

import UIKit
import RxSwift
import RxCocoa

class PagingViewController: UIViewController {
    
    struct Constant {
        static let small: CGFloat = 30
    }
    
    // MARK: - UI
    @IBOutlet weak var tableView: UITableView!
    lazy var refreshControl: UIRefreshControl = {
        return UIRefreshControl()
    }()
    
    lazy var footer: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        
        view.addSubview(bottomActivityIndicator)
        
        bottomActivityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.bottomActivityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.bottomActivityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            self.bottomActivityIndicator.widthAnchor.constraint(equalToConstant: self.bottomActivityIndicator.bounds.width),
            self.bottomActivityIndicator.heightAnchor.constraint(equalToConstant: self.bottomActivityIndicator.bounds.height)
        ])
        
        return view
    }()
    
    lazy var bottomActivityIndicator: UIActivityIndicatorView = {
        let control = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: Constant.small, height: Constant.small))
        
        NSLayoutConstraint.activate([
            control.heightAnchor.constraint(equalToConstant: control.bounds.width),
            control.widthAnchor.constraint(equalToConstant: control.bounds.height)
        ])
        
        return control
    }()
    
    // MARK: - Rx
    let disposeBag = DisposeBag()
    
    // MARK: - Func
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    func setupUI() {
        tableView.refreshControl = self.refreshControl
    }
    
    func bindReloading(_ driver: Driver<Bool>) {
        driver
            .drive(self.refreshControl.rx.isRefreshing)
            .disposed(by: self.disposeBag)
    }
    
    func bindLoadMore(_ driver: Driver<Bool>) {
        driver
            .drive(onNext: { [weak self] (isLoading) in
                guard let self = self else { return }
                
                if isLoading {
                    self.tableView.tableFooterView = self.footer
                } else {
                    self.tableView.hideEmptyCells()
                }
            })
            .disposed(by: self.disposeBag)
        
        driver
            .drive(self.bottomActivityIndicator.rx.isAnimating)
            .disposed(by: self.disposeBag)
    }
    
}
