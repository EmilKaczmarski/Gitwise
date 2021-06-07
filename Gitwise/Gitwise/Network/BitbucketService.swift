//
//  BitbucketService.swift
//  Gitwise
//
//  Created by emil.kaczmarski on 06/06/2021.
//

import Foundation
import Moya

enum BitbucketService {
    case repositories(BitbucketModel.Request.Repositories)
}

extension BitbucketService: TargetType {
    var baseURL: URL {
        URL(string: "https://api.bitbucket.org/2.0")!
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
                return .requestParameters(parameters: parameters,
                                          encoding: URLEncoding.default)
        }
    }
    
    var parameters: [String: Any] {
        switch self {
            case let .repositories(payload):
                return [
                    "fields": payload.fields,
                    "page": payload.page,
                    "pagelen": payload.pageLen,
                ]
        }
    }
    
    var headers: [String : String]? {
        nil
    }

}
