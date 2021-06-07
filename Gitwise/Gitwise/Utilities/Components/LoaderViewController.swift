//
//  LoaderViewController.swift
//  Gitwise
//
//  Created by emil.kaczmarski on 05/06/2021.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class LoaderViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoader()
        view.backgroundColor = .clear
    }
    
    private func setupLoader() {
        let loadingIndicator = CustomActivityIndicatorView()
        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        view.addSubview(blurEffectView)
        
        loadingIndicator.center = view.center
        blurEffectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(loadingIndicator)
        loadingIndicator.startAnimating()
    }
}
