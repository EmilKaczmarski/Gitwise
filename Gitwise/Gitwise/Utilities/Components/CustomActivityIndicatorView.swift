//
//  CustomActivityIndicatorView.swift
//  Gitwise
//
//  Created by emil.kaczmarski on 07/06/2021.
//

import UIKit

final class CustomActivityIndicatorView: UIActivityIndicatorView {
    override init(frame: CGRect = .init(x: 10, y: 5, width: 50, height: 50)) {
        super.init(frame: frame)
        setupView()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupView() {
        hidesWhenStopped = true
        style = .large
        color = .black
        //ngIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
    }
}
