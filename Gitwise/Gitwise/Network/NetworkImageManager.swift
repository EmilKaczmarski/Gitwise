//
//  NetworkImageManager.swift
//  Gitwise
//
//  Created by emil.kaczmarski on 07/06/2021.
//

import UIKit
import RxSwift

protocol NetworkImageManagerProtocol {
    func fetchImage(with url: URL?) -> Single<UIImage>
}

extension NetworkImageManagerProtocol {
    func fetchImage(with url: URL?) -> Single<UIImage> {
        NetworkImageManager.shared.fetchImage(with: url)
    }
}

final class NetworkImageManager: NetworkImageManagerProtocol {
    
    static let shared = NetworkImageManager()
    
    private init() { }
    
    func fetchImage(with url: URL?) -> Single<UIImage> {
        Single<UIImage>.create { single in
                
            DispatchQueue.global(qos: .background).async {
                if let url = url,
                   let data = try? Data(contentsOf: url),
                   let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        single(.success(image))
                    }
                
                } else {
                    DispatchQueue.main.async {
                        single(.failure(NetworkError.wrongImageData))
                    }
                    
                }
            }
            return Disposables.create()
        }
    }
}
