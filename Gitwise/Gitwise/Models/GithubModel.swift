//
//  GithubModel.swift
//  Gitwise
//
//  Created by emil.kaczmarski on 03/06/2021.
//

import Foundation

struct GithubModel: Codable {
    struct Response: Codable { }
}

//MARK: - Response

extension GithubModel.Response {
    
    // MARK: - Repository
    struct Repository: Codable {
        let name: String
        let owner: Owner
        let repositoryDescription: String?
        
        enum CodingKeys: String, CodingKey {
            case name
            case owner
            case repositoryDescription = "description"
        }
    }

    // MARK: - Owner
    struct Owner: Codable {
        let login: String
        @FailableCodable var avatarURL: URL?

        enum CodingKeys: String, CodingKey {
            case login
            case avatarURL = "avatar_url"
        }
    }
}
