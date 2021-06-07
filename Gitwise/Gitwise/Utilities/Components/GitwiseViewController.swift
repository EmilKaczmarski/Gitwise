//
//  GitwiseViewController.swift
//  Gitwise
//
//  Created by emil.kaczmarski on 05/06/2021.
//

import UIKit
import RxSwift

protocol GitwiseViewControllerProtocol: UIViewController {
    
}

class GitwiseViewController: UIViewController, GitwiseViewControllerProtocol {
    
    private var loaderViewController: LoaderViewController?
    private var alerts: [AlertModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func showPopup(with model: AlertModel) {
        
        if loaderViewController != nil {
            alerts += [model]
            return
        }
        forceShowPopup(with: model)
    }
    
    private func forceShowPopup(with model: AlertModel) {
        let action = UIAlertAction(title: model.actionTitle,
                                   style: .default,
                                   handler: model.action)
        
        let alertViewController = UIAlertController(title: title, message: model.message, preferredStyle: .alert)
        
        alertViewController.addAction(action)
        alertViewController.modalPresentationStyle = .overCurrentContext
        present(alertViewController, animated: true)
    }
    
    func startLoader() {
        loaderViewController = LoaderViewController()
        loaderViewController?.modalPresentationStyle = .overFullScreen
        if let viewController = loaderViewController {
            present(viewController, animated: true)
        }
    }
    
    func stopLoader() {
        loaderViewController?.dismiss(animated: true) { [weak self] in
            self?.loaderViewController = nil
            self?.showAlerts()
        }
    }
    
    private func showAlerts() {
        alerts.forEach(forceShowPopup)
        alerts = []
    }
}

extension Reactive where Base: GitwiseViewController {
    var loaderTrigger: Binder<Bool> {
        Binder(base.self) { vc, showLoader in
            showLoader ? vc.startLoader() : vc.stopLoader()
        }
    }
}
