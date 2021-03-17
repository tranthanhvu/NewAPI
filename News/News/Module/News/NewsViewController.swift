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
        categoryButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.presentPicker()
            })
            .disposed(by: self.disposeBag)
    }
    
    func bindViewModel() {
        let loadTrigger = self.rx.viewDidAppear.take(1).asDriverOnErrorJustComplete().mapToVoid()
        let reloadTrigger = Driver<Void>.empty()
        let loadMoreTrigger = Driver<Void>.empty()
        
        let input = NewsViewModel.Input(
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
    }

    func presentPicker() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let items: Observable<[String]> = Observable.of(Category.allCases.map({ $0.rawValue }))
        
        let controller = UIViewController()
        
        let picker = UIPickerView(frame: CGRect.zero)
                
        alertController.view.addSubview(picker)
        
        
//        let picker = UIPickerView(frame: controller.view.frame)
        items.bind(to: picker.rx.itemTitles) { (row, element) in
            return element
        }
        .disposed(by: self.disposeBag)
        
        controller.view.addSubview(picker)
        
        alertController.setValue(controller, forKey: "contentViewController")

        alertController.addAction(UIAlertAction(title: "Done", style: .cancel, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
