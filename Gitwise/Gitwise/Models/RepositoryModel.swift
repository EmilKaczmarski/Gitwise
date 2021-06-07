//
//  RepositoryModel.swift
//  Gitwise
//
//  Created by emil.kaczmarski on 02/06/2021.
//

import UIKit

struct RepositoryModel {
    let name: String
    var description: String?
    var owner: User
    let repositoryType: RepositoryType
    
    struct User {
        let nickname: String
        var imageURL: URL?
    }
}
