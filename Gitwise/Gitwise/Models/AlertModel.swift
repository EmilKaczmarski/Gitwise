//
//  AlertModel.swift
//  Gitwise
//
//  Created by emil.kaczmarski on 07/06/2021.
//

import UIKit

struct AlertModel {
    
    let title: String
    let message: String?
    let actionTitle: String
    let action: ((UIAlertAction) -> Void)?
    
    init(title: String,
         message: String? = nil,
         actionTitle: String,
         action: ((UIAlertAction) -> Void)? = nil) {
        self.title = title
        self.message = message
        self.actionTitle = actionTitle
        self.action = action
    }
}
