//
//  UIAlertController+Extension.swift
//  News
//
//  Created by Yoyo on 3/18/21.
//

import UIKit
import RxSwift

struct AlertAction {
    var title: String?
    var style: UIAlertAction.Style

    static func action(title: String?, style: UIAlertAction.Style = .default) -> AlertAction {
        return AlertAction(title: title, style: style)
    }
}

extension UIAlertController {
    static func present(in viewController: UIViewController, title: String?, message: String?, style: UIAlertController.Style, actions: [AlertAction]) -> Observable<Int> {
        return present(in: viewController, title: title, message: message, style: style, actions: actions, cosmeticBlock: nil)
    }

    static func present(in viewController: UIViewController, title: String?, message: String?, style: UIAlertController.Style, actions: [AlertAction], cosmeticBlock: ((UIAlertAction) -> Void)? ) -> Observable<Int> {
        return Observable.create { observer in
            let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
            
            actions.enumerated().forEach { index, action in
                let uiAction = UIAlertAction(title: action.title, style: action.style) { _ in
                    observer.onNext(index)
                    observer.onCompleted()
                }
                
                cosmeticBlock?(uiAction)
                
                alertController.addAction(uiAction)
            }
            
            viewController.present(alertController, animated: true, completion: nil)
            return Disposables.create { alertController.dismiss(animated: true, completion: nil) }
        }
        .subscribe(on: MainScheduler.instance)
    }
    
    static func present(in viewController: UIViewController, title: String?, message: String?, style: UIAlertController.Style, actions: [AlertAction], setupTextFields: @escaping ((inout UIAlertController) -> Void), cosmeticBlock: ((UIAlertAction) -> Void)? = nil) -> Observable<(Int,[String])> {
        return Observable.create { observer in
            var alertController = UIAlertController(title: title, message: message, preferredStyle: style)

            setupTextFields(&alertController)
            
            actions.enumerated().forEach { index, action in
                let uiAction = UIAlertAction(title: action.title, style: action.style) { _ in
                    let list = alertController.textFields?.map({ $0.text ?? "" }) ?? []
                    observer.onNext((index, list))
                    observer.onCompleted()
                }
                
                cosmeticBlock?(uiAction)
                
                alertController.addAction(uiAction)
            }

            viewController.present(alertController, animated: true, completion: nil)
            return Disposables.create { alertController.dismiss(animated: true, completion: nil) }
        }
        .subscribe(on: MainScheduler.instance)
    }
    
    static func present(in viewController: UIViewController, title: String?, values: [String], selectedIndex: Int) -> Observable<Int> {
        return Observable.create { observer in
            let alertController = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
            
            let controller = PickerViewController()
            controller.preferredContentSize.height = 216
            alertController.preferredContentSize.height = 216
            
            controller.bind(values: values, selectedIndex: selectedIndex)
            
            controller.action = { index in
                observer.onNext(index)
                observer.onCompleted()
            }
            
            alertController.setValue(controller, forKey: "contentViewController")

            alertController.addAction(UIAlertAction(title: "Done", style: .cancel, handler: nil))
            
            viewController.present(alertController, animated: true, completion: nil)
            return Disposables.create { alertController.dismiss(animated: true, completion: nil) }
        }
        .subscribe(on: MainScheduler.instance)
    }
}
