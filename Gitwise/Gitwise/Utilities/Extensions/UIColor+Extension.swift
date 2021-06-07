//
//  UIColor+Extension.swift
//  Gitwise
//
//  Created by emil.kaczmarski on 03/06/2021.
//

import UIKit

extension UIColor {
    static let wiseDeepGrey = UIColor(rgb: 0x35382F)
    static let wiseGrey = UIColor(rgb: 0xDDDDDD)
    static let wiseLightGrey = UIColor(rgb: 0xF4F5F7)
    
    static let wiseDeepBlue = UIColor(rgb: 0x23547B)
    static let wiseBlue = UIColor(rgb: 0xD0ECFF)
    static let wiseLightBlue = UIColor(rgb: 0xE5F5FF)
}

extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       self.init(red: CGFloat(red) / 255.0,
                 green: CGFloat(green) / 255.0,
                 blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}
 
