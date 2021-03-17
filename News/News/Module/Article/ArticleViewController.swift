//
//  ArticleViewController.swift
//  News
//
//  Created by Yoyo on 3/17/21.
//

import UIKit
import RxSwift
import RxCocoa

class ArticleViewController: UIViewController, ViewBindableProtocol {

    // MARK: - UI
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var detailButton: UIButton!
    
    // MARK: - Rx + Data
    let disposeBag = DisposeBag()
    var viewModel: ArticleViewModel!
    
    override func loadView() {
        super.loadView()
        
        bindViewModel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
    }
    
    private func setupUI() {
        detailButton.layer.cornerRadius = detailButton.frame.height * 0.5
    }
    
    func bindViewModel() {
        let input = ArticleViewModel.Input(
            viewDidLoad: self.rx.viewDidLoad.asDriver().mapToVoid(),
            tapDetail: detailButton.rx.tap.asDriver().mapToVoid()
        )
        
        let output = viewModel.transform(input)
        
        output.data
            .drive(onNext: { [weak self] article in
                self?.textView.text = article.description
            })
            .disposed(by: self.disposeBag)
        
        output.openWebView
            .drive()
            .disposed(by: self.disposeBag)
    }
    
}
