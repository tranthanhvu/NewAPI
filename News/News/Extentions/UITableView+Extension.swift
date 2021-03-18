//
//  UITableView+Extension.swift
//  GooDic
//
//  Created by ttvu on 5/22/20.
//  Copyright © 2020 paxcreation. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension UITableView {
    func hideEmptyCells() {
        self.tableFooterView = UIView(frame: .zero)
    }
    
    func getLoadMoreTrigger() -> Driver<Void> {
        self.rx.didScroll
            .map({ [unowned self] _ in
                return self.isNearBottomEdge()
            })
            .distinctUntilChanged()
            .filter({ $0 })
            .mapToVoid()
            .asDriverOnErrorJustComplete()
    }
}
