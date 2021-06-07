//
//  Collection+Extension.swift
//  Gitwise
//
//  Created by emil.kaczmarski on 03/06/2021.
//

import Foundation

extension Collection {
    subscript (safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
