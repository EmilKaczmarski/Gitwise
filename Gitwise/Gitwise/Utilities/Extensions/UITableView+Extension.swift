//
//  UITableView+Extension.swift
//  Gitwise
//
//  Created by emil.kaczmarski on 03/06/2021.
//

import UIKit

extension UITableView {
    func register<T: UITableViewCell>(_ cellClass: T.Type, customIdentifier: String? = nil) {
        register(cellClass, forCellReuseIdentifier: customIdentifier ?? cellClass.reusableId)
    }

    
    func scrollToTop(_ animated: Bool = true) {
        let indexPath = IndexPath(row: 0, section: 0)
        
        guard  numberOfSections > indexPath.section,
               numberOfRows(inSection: indexPath.section) > indexPath.row
        else { return }
        
        scrollToRow(at: indexPath, at: .top, animated: animated)
    }
}

//podawac w deque class
