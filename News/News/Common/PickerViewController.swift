//
//  PickerViewController.swift
//  News
//
//  Created by Yoyo on 3/18/21.
//

import UIKit
import RxSwift

class PickerViewController: UIViewController {
    
    // MARK: - UI
    lazy var picker: UIPickerView = {
        return UIPickerView()
    }()
    
    // MARK: - Rx
    let disposeBag = DisposeBag()
    var action: ((Int) -> Void)? = nil
    
    // MARK: - life cycle
    override func loadView() {
        super.loadView()
        view = picker
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func bind(values: [String], selectedIndex: Int = 0) {
        
        
        Observable.just(values)
            .bind(to: picker.rx.itemTitles) { (row, element) in
                return element
            }
            .disposed(by: self.disposeBag)
        
        picker.selectRow(selectedIndex, inComponent: 0, animated: true)
        
        picker.rx.itemSelected
            .subscribe(onNext: { [weak self] index, _ in
                guard let self = self else { return }
                
                self.action?(index)
            })
            .disposed(by: self.disposeBag)
    }
}
