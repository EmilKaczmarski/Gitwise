//
//  UIImageView+Extension.swift
//  Gitwise
//
//  Created by emil.kaczmarski on 03/06/2021.
//

import UIKit

extension UIImageView {
    
    func makeRounded() {
        layer.borderWidth = 1
        layer.masksToBounds = false
        layer.borderColor = UIColor.black.cgColor
        layer.cornerRadius = frame.height / 2
        clipsToBounds = true
    }
}
