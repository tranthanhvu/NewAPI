//
//  HeadlineViewController.swift
//  News
//
//  Created by Yoyo on 3/16/21.
//

import UIKit
import RxSwift
import RxCocoa

enum Section: CaseIterable {
    case main
}

class HeadlineViewController: UIViewController {

    // MARK: - UI
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Data
    let disposeBag = DisposeBag()
    var viewModel: HeadlineViewModel = HeadlineViewModel()
    
    
    private lazy var dataSource: UICollectionViewDiffableDataSource<Section, Article> = {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Article> { cell, _, article in
            var content = cell.defaultContentConfiguration()
            content.text = article.title
            
            cell.contentConfiguration = content
        }
        
        return UICollectionViewDiffableDataSource<Section, Article>(collectionView: collectionView) { (collectionView, indexPath, article) -> UICollectionViewCell? in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: article)
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
        bindViewModel()
    }
    
    private func setupUI() {
        let config = UICollectionLayoutListConfiguration(appearance: .plain)
        
        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout.list(using: config)
    }
    
    private func bindViewModel() {
        let loadTrigger = self.rx.viewDidLoad.asDriver().mapToVoid()
        let reloadTrigger = Driver<Void>.empty()
        let loadMoreTrigger = Driver<Void>.empty()
        let input = HeadlineViewModel.Input(
            loadTrigger: loadTrigger,
            reloadTrigger: reloadTrigger,
            loadMoreTrigger: loadMoreTrigger
        )
        
        let output = viewModel.transform(input)
        
        output.items
            .drive(onNext: { [weak self] (articles) in
                self?.applySnapshot(articles: articles, animatingDifferences: true)
            })
            .disposed(by: self.disposeBag)
    }
    
    func applySnapshot(articles: [Article], animatingDifferences: Bool = false) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Article>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(articles)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences, completion: nil)
    }
}
