//
//  CustomBlurEffect.swift
//  Gitwise
//
//  Created by emil.kaczmarski on 07/06/2021.
//

import UIKit

final class CustomBlurEffectView: UIVisualEffectView {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    override init(effect: UIVisualEffect? = UIBlurEffect(style: .regular)) {
        super.init(effect: effect)
        setupView()
    }
    
    private func setupView() {
        alpha = 0.7
        
    }
}
