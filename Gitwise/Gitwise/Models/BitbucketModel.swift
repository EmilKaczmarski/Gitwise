//
//  BitbucketModel.swift
//  Gitwise
//
//  Created by emil.kaczmarski on 06/06/2021.
//

import Foundation

struct BitbucketModel: Codable {
    
}

extension BitbucketModel {
    struct Request: Encodable {
        struct Repositories {
            let fields: String
            let page: Int
            let pageLen: Int
            
            init(fields: String = "values.name,values.owner,values.description",
                 page: Int = 0,
                 pageLen: Int = 100
            ) {
                self.fields = fields
                self.page = page
                self.pageLen = pageLen
            }
        }
    }
}

extension BitbucketModel {
    struct Response: Codable {
        let values: [Repository]
        
        // MARK: - RepositoryElement
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
            let displayName: String
            let links: Links
            
            enum CodingKeys: String, CodingKey {
                case displayName = "display_name"
                case links
            }
        }
        
        // MARK: - Links
        struct Links: Codable {
            let avatar: Avatar
        }
        
        // MARK: - Avatar
        struct Avatar: Codable {
            @FailableCodable var avatarURL: URL?
            
            enum CodingKeys: String, CodingKey {
                case avatarURL = "href"
            }
        }
    }
}
