//
//  HomeInteractor.swift
//  Gitwise
//
//  Created by emil.kaczmarski on 03/06/2021.
//

import Foundation
import RxSwift
import RxCocoa
import Moya

protocol HomeInteractorProtocol: NetworkImageManagerProtocol {
    func fetchGithubRepositories() -> Single<[RepositoryModel]>
    func fetchBitbucketRepositories() -> Single<[RepositoryModel]>
}

final class HomeInteractor: HomeInteractorProtocol {
    
    private let repository: HomeRepositoryProtocol
    
    init(repository: HomeRepositoryProtocol = HomeRepository()) {
        self.repository = repository
    }
    
    func fetchGithubRepositories() -> Single<[RepositoryModel]> {
        repository.fetchGithubRepositories()
    }
    
    func fetchBitbucketRepositories() -> Single<[RepositoryModel]> {
        repository.fetchBitbucketRepositories()
    }
}
