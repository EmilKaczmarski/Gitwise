//
//  UIFont+Extension.swift
//  Gitwise
//
//  Created by emil.kaczmarski on 03/06/2021.
//

import UIKit

enum GitWiseFontType {
    case bold
    case regural
    case italic
    case boldItalic
    
    var name: String {
        switch self {
            case .bold:
                return "NotoSans-Bold"
            case .regural:
                return "NotoSans-Regural"
            case .italic:
                return "NotoSans-Italic"
            case .boldItalic:
                return "NotoSans-BoldItalic"
        }
    }
}

extension UIFont {
    
    static func gitwiseFont(type: GitWiseFontType = .regural, customSize: CGFloat? = nil) -> UIFont? {
        UIFont(name: type.name, size: customSize ?? .fontRegural)
    }
}
