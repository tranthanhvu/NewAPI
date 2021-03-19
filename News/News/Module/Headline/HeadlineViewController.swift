//
//  HeadlineViewController.swift
//  News
//
//  Created by Yoyo on 3/16/21.
//

import UIKit
import RxSwift
import RxCocoa

class HeadlineViewController: PagingViewController, ViewBindableProtocol {
    
    // MARK: - Data
    var viewModel: HeadlineViewModel!
    
    // MARK: - Func
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        bindUI()
    }
    
    override func setupUI() {
        super.setupUI()
        
        let cellName = String(describing: NewsTVC.self)
        let nib = UINib(nibName: cellName, bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: NewsTVC.reuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        
        tableView.hideEmptyCells()
    }
    
    func bindUI() {
        tableView.rx
            .itemSelected
            .subscribe(onNext: { indexPath in
                self.tableView.deselectRow(at: indexPath, animated: true)
            })
            .disposed(by: self.disposeBag)
    }
    
    func bindViewModel() {
        let loadTrigger = self.rx.viewDidAppear.take(1).asDriverOnErrorJustComplete().mapToVoid()
        let reloadTrigger = self.refreshControl.rx.controlEvent(.valueChanged).asDriverOnErrorJustComplete()
        let loadMoreTrigger = self.tableView.getLoadMoreTrigger()
        
        let input = HeadlineViewModel.Input(
            loadTrigger: loadTrigger,
            reloadTrigger: reloadTrigger,
            loadMoreTrigger: loadMoreTrigger,
            selectCell: tableView.rx.itemSelected.asDriver()
        )
        
        let output = viewModel.transform(input)
        
        output.items
            .drive(self.tableView.rx.items(cellIdentifier: NewsTVC.reuseIdentifier, cellType: NewsTVC.self), curriedArgument: { index, model, cell in
                cell.bind(article: model)
            })
            .disposed(by: self.disposeBag)
        
        output.openDetail
            .drive()
            .disposed(by: self.disposeBag)
        
        output.error
            .drive(onNext: { [weak self] error in
                guard let self = self else { return }

                if let error = error as? APIError {
                    switch error {
                    case let .other(code, message):
                        self.alert(message: message, title: "CODE: \(code)")
                    }

                    return
                }

                let error = error as NSError
                if error.domain == NSURLErrorDomain {
                    self.alert(message: error.localizedDescription)
                } else {
                    self.alert(message: error.description)
                }
            })
            .disposed(by: self.disposeBag)
        
        bindReloading(output.isReloading)
        
        bindLoadMore(output.isLoadingMore)
    }
}
