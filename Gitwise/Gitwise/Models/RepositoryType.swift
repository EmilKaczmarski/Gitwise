//
//  RepositoryType.swift
//  Gitwise
//
//  Created by emil.kaczmarski on 03/06/2021.
//

import UIKit

protocol Theme {
    var primary: UIColor { get }
    var secondary: UIColor { get }
    var tertiary: UIColor { get }
    
    var defaultImage: UIImage? { get }
}

enum RepositoryType: String, Codable, Theme {
    case github
    case bitbucket
    
    var primary: UIColor {
        switch self {
            case .github:
                return .wiseDeepGrey
            case .bitbucket:
                return .wiseDeepBlue
        }
    }
    
    var secondary: UIColor {
        switch self {
            case .github:
                return .wiseLightGrey
            case .bitbucket:
                return .wiseLightBlue
        }
    }
    
    var tertiary: UIColor {
        switch self {
            case .github:
                return .wiseGrey
            case .bitbucket:
                return .wiseBlue
        }
    }
    
    var defaultImage: UIImage? {
        switch self {
            case .github:
                return UIImage(named: "github")
            case .bitbucket:
                return UIImage(named: "bitbucket")
        }
    }
}
