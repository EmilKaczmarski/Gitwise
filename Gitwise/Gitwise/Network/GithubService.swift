//
//  GithubService.swift
//  Gitwise
//
//  Created by emil.kaczmarski on 03/06/2021.
//

import Foundation
import Moya

enum GithubService {
    case repositories
}

extension GithubService: TargetType {
    var baseURL: URL {
        URL(string: "https://api.github.com")!
    }
    
    var path: String {
        switch self {
            case .repositories:
                return "/repositories"
        }
    }
    
    var method: Moya.Method {
        switch self {
            case .repositories:
                return .get
        }
    }
    
    var sampleData: Data {
        Data()
    }
    
    var task: Task {
        switch self {
            case .repositories:
                return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        nil
    }
}
