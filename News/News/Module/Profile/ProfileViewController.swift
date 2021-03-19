//
//  ProfileViewController.swift
//  News
//
//  Created by Yoyo on 3/16/21.
//

import UIKit
import RxSwift
import RxCocoa

class ProfileViewController: UIViewController, ViewBindableProtocol {

    struct Constant {
        static let valueIdentifier = "valueIdentifier"
    }
    
    // MARK: - UI
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Rx + Data
    let disposeBag = DisposeBag()
    var viewModel: ProfileViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
        bindUI()
    }
    
    private func setupUI() {
        let cellName = String(describing: ButtonTVC.self)
        let nib = UINib(nibName: cellName, bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: ButtonTVC.reuseIdentifier)
        
        tableView.register(InfoTVC.self, forCellReuseIdentifier: InfoTVC.reuseIdentifier)
        
        tableView.rowHeight = 44
        tableView.estimatedRowHeight = 44
        
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
        let registerWithName = PublishSubject<String>()
        let changeCategory = PublishSubject<Category>()
        let signOut = PublishSubject<Void>()
        
        let input = ProfileViewModel.Input(
            userInfo: AppManager.shared.userInfo.asDriver(),
            registerWithName: registerWithName.asDriverOnErrorJustComplete(),
            changeCategory: changeCategory.asDriverOnErrorJustComplete(),
            signOut: signOut.asDriverOnErrorJustComplete()
        )
        
        let output = viewModel.transform(input)
        
        output.items
            .drive(self.tableView.rx.items) { tv, row, item -> UITableViewCell in
                switch item {
                case .register:
                    let cell = tv.dequeueReusableCell(withIdentifier: ButtonTVC.reuseIdentifier, for: IndexPath(row: row, section: 0)) as! ButtonTVC
                    cell.bind(text: L10n.Profile.register, color: .systemBlue)
                    
                    return cell
                    
                case .signOut:
                    let cell = tv.dequeueReusableCell(withIdentifier: ButtonTVC.reuseIdentifier, for: IndexPath(row: row, section: 0)) as! ButtonTVC
                    cell.bind(text: L10n.Profile.signOut, color: .systemRed)
                    
                    return cell
                    
                case .userInfo(let name):
                    let cell = tv.dequeueReusableCell(withIdentifier: InfoTVC.reuseIdentifier, for: IndexPath(row: row, section: 0)) as! InfoTVC
                    
                    cell.textLabel?.text = L10n.Profile.userName
                    cell.detailTextLabel?.text = name
                    cell.accessoryType = .none
                    cell.selectionStyle = .none
                    
                    return cell
                    
                case .categoryInfo(let name):
                    let cell = tv.dequeueReusableCell(withIdentifier: InfoTVC.reuseIdentifier, for: IndexPath(row: row, section: 0)) as! InfoTVC
                    
                    cell.textLabel?.text = L10n.Profile.category
                    cell.detailTextLabel?.text = name
                    cell.accessoryType = .disclosureIndicator
                    cell.selectionStyle = .default
                    
                    return cell
                }
            }
            .disposed(by: self.disposeBag)
        
        output.selectedCell
            .drive()
            .disposed(by: self.disposeBag)
        
        let selectedType = tableView.rx.itemSelected
            .withLatestFrom(output.items) { (indexPath, list) -> CellType? in
                if list.count > indexPath.row {
                    return list[indexPath.row]
                }
                
                return nil
            }
            .compactMap({ $0 })
        
        selectedType
            .filter({ $0 == .register })
            .mapToVoid()
            .flatMapFirst { [weak self] (_) -> Observable<String> in
                guard let self = self else { return Observable.empty() }
                
                let actions = [
                    AlertAction(title: L10n.Profile.InputName.cancel, style: .cancel),
                    AlertAction(title: L10n.Profile.InputName.ok, style: .default)
                ]

                return UIAlertController
                    .present(in: self,
                             title: L10n.Profile.InputName.title,
                             message: L10n.Profile.InputName.message,
                             style: .alert,
                             actions: actions,
                             setupTextFields: { (alertController) in
                                alertController.addTextField(configurationHandler: nil)
                             })
                    .filter({ $0.0 == 1 })
                    .compactMap({ $0.1.first?.isEmpty == false ? $0.1.first : nil })
            }
            .subscribe(onNext: { name in
                registerWithName.onNext(name)
            })
            .disposed(by: self.disposeBag)
        
        selectedType
            .compactMap({ (type) -> String? in
                switch type {
                case .categoryInfo(let name): return name
                default: return nil
                }
            })
            .flatMapFirst({ (categoryName) -> Observable<Category> in
                let values = Category.allCases.map({ $0.rawValue })
                let selectedIndex = values.firstIndex(of: categoryName) ?? 0
                
                return UIAlertController.present(in: self,
                                                 title: L10n.Profile.SelectCategory.title,
                                                 message: L10n.Profile.SelectCategory.message,
                                                 values: values,
                                                 selectedIndex: selectedIndex)
                    .map({ Category.allCases[$0] })
            })
            .subscribe(onNext: { category in
                changeCategory.onNext(category)
            })
            .disposed(by: self.disposeBag)
        
        selectedType
            .filter({ $0 == .signOut })
            .subscribe(onNext: { _ in
                signOut.onNext(())
            })
            .disposed(by: self.disposeBag)
            
    }
}
