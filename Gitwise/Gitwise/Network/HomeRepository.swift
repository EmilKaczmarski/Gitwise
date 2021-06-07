//
//  HomeRepository.swift
//  Gitwise
//
//  Created by emil.kaczmarski on 03/06/2021.
//

import Foundation
import RxSwift
import RxCocoa
import Moya

protocol HomeRepositoryProtocol {
    func fetchGithubRepositories() -> Single<[RepositoryModel]>
    func fetchBitbucketRepositories() -> Single<[RepositoryModel]>
}

final class HomeRepository: HomeRepositoryProtocol {
    private let networkClient: NetworkClientProtocol
    
    init(networkClient: NetworkClientProtocol = NetworkClient()) {
        self.networkClient = networkClient
    }
    
    func fetchGithubRepositories() -> Single<[RepositoryModel]> {
        let rawResponse: Single<[GithubModel.Response.Repository]> = githubFetch(target: .repositories)
        
        return rawResponse.map(mapToRepositories)
    }
    
    func fetchBitbucketRepositories() -> Single<[RepositoryModel]> {
        let rawResponse: Single<BitbucketModel.Response> = bitbucketFetch(target: .repositories(.init()))
        
        return rawResponse.map(mapToRepositories)
    }
    
    private func githubFetch<Response: Codable>(target: GithubService) -> Single<Response> {
        networkClient.fetch(target: target)
    }
    
    private func bitbucketFetch<Response: Codable>(target: BitbucketService) -> Single<Response> {
        networkClient.fetch(target: target)
    }
}

private extension HomeRepository {
    func mapToRepositories(from model: [GithubModel.Response.Repository]) -> [RepositoryModel] {
        model.map {
            RepositoryModel(name: $0.name,
                  description: $0.repositoryDescription,
                  owner: .init(nickname: $0.owner.login,
                               imageURL: $0.owner.avatarURL),
                  repositoryType: .github)
        }
    }
    
    func mapToRepositories(from model: BitbucketModel.Response) -> [RepositoryModel] {
        model.values.map {
            RepositoryModel(name: $0.name,
                  description: $0.repositoryDescription,
                  owner: .init(nickname: $0.owner.displayName,
                               imageURL: $0.owner.links.avatar.avatarURL),
                  repositoryType: .bitbucket)
        }
    }
}
