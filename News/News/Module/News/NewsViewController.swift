//
//  NewsViewController.swift
//  News
//
//  Created by Yoyo on 3/16/21.
//

import UIKit
import RxSwift
import RxCocoa

class NewsViewController: UIViewController, ViewBindableProtocol {

    // MARK: - UI
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var categoryButton: UIBarButtonItem!
    
    // MARK: - Rx & Data
    let disposeBag = DisposeBag()
    var viewModel: NewsViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
        bindUI()
    }
    
    private func setupUI() {
        let cellName = String(describing: NewsTVC.self)
        let nib = UINib(nibName: cellName, bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: NewsTVC.reuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        
        tableView.hideEmptyCells()
    }
    
    private func bindUI() {

    }
    
    func bindViewModel() {
        let loadTrigger = self.rx.viewDidAppear.take(1).asDriverOnErrorJustComplete().mapToVoid()
        let reloadTrigger = Driver<Void>.empty()
        let loadMoreTrigger = Driver<Void>.empty()
        let changeCategory = PublishSubject<Category>()
            
        let input = NewsViewModel.Input(
            loadTrigger: loadTrigger,
            reloadTrigger: reloadTrigger,
            loadMoreTrigger: loadMoreTrigger,
            selectCell: tableView.rx.itemSelected.asDriver(),
            changeCategory: changeCategory.asDriverOnErrorJustComplete()
        )
        
        let output = viewModel.transform(input)
        
        output.items
            .drive(self.tableView.rx.items(cellIdentifier: NewsTVC.reuseIdentifier, cellType: NewsTVC.self), curriedArgument: { index, model, cell in
                cell.bind(article: model)
            })
            .disposed(by: self.disposeBag)
        
        output.actions
            .drive()
            .disposed(by: self.disposeBag)
        
        output.category
            .drive(onNext: { [weak self] category in
                self?.categoryButton.title = category.rawValue
            })
            .disposed(by: self.disposeBag)
        
        categoryButton.rx.tap
            .asObservable()
            .withLatestFrom(output.category.asObservable())
            .flatMapFirst({ (category) -> Observable<Category> in
                let values = Category.allCases.map({ $0.rawValue })
                let selectedIndex = values.firstIndex(of: category.rawValue) ?? 0
                
                return UIAlertController.present(in: self, title: "Category", values: values, selectedIndex: selectedIndex)
                    .map({ Category.allCases[$0] })
            })
            .subscribe(onNext: { category in
                changeCategory.onNext(category)
            })
            .disposed(by: self.disposeBag)
    }
}
