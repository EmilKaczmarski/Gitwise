//
//  NetworkClient.swift
//  Gitwise
//
//  Created by emil.kaczmarski on 03/06/2021.
//

import Foundation
import Moya
import RxCocoa
import RxSwift

protocol NetworkClientProtocol {
    func fetch<Target: TargetType, Response: Codable>(target: Target, for storageTime: StorageTime) -> Single<Response>
}

extension NetworkClientProtocol {
    func fetch<Target: TargetType, Response: Codable>(target: Target) -> Single<Response> {
        fetch(target: target, for: .minutes(3))
    }
}

final class NetworkClient: NetworkClientProtocol {
    private let provider = MoyaProvider<MultiTarget>()
    private let cacheManager: CacheManagerProtocol
    
    init(cacheManager: CacheManagerProtocol = CacheManager()) {
        self.cacheManager = cacheManager
    }
    
    func fetch<Target: TargetType, Response: Codable>(target: Target, for storageTime: StorageTime) -> Single<Response> {
        
        Single<Response>.create { [weak self] single in
            
            let cachedData: Response? = self?.cacheManager.read()
            if let cachedData = cachedData {
                single(.success(cachedData))
            } else {
                self?.createRequest(target: target, for: storageTime, completion: single)
            }
            
            return Disposables.create()
        }
    }
    
    private func createRequest<Target: TargetType, Response: Codable>(target: Target,
                                                                      for storageTime: StorageTime,
                                                                      completion: @escaping ((Result<Response, Error>) -> Void)) {
        
        provider.request(.target(target)) { [weak self] result in
            switch result {
                case .success(let response):
                    do {
                        let model = try JSONDecoder().decode(Response.self, from: response.data)
                        self?.cacheManager.store(data: model, for: storageTime)
                        completion(.success(model))
                    } catch {
                        completion(.failure(NetworkError.decoding("Decoding error of type: \(Response.self)")))
                    }
                    
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
}

enum NetworkError: Error {
    case decoding(String)
    
    case wrongURL
    case wrongImageData
}
