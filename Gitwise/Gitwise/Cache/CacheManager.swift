//
//  CacheManager.swift
//  Gitwise
//
//  Created by emil.kaczmarski on 05/06/2021.
//

import Foundation
import RealmSwift

protocol CacheManagerProtocol {
    func read<T: Decodable>() -> T?
    func store<T: Encodable>(data: T, for storageTime: StorageTime)
}

final class CacheManager: CacheManagerProtocol {
    
    private let realm = try! Realm()
    
    private var timestamp: Int {
        Int(Date().timeIntervalSince1970)
    }
    
    func store<T: Encodable>(data: T, for storageTime: StorageTime) {
        guard let encodedData = try? JSONEncoder().encode(data) else { return }
        let cacheObject = CacheObject()
        cacheObject.data = encodedData
        cacheObject.className = "\(T.self)"
        cacheObject.timestamp = timestamp
        cacheObject.storageTime = storageTime.seconds
        
        try! realm.write { [weak self] in
            self?.realm.add(cacheObject)
        }
    }
    
    func read<T: Decodable>() -> T? {
        let storedObjects = realm.objects(CacheObject.self).filter { object in
            object.className == "\(T.self)"
        }
        
        guard storedObjects.count == 1,
              let cacheObject = storedObjects.first
        else { return nil }
        
        if !isTimeValid(for: cacheObject) {
            remove(object: cacheObject)
            return nil
        }
        
        return try? JSONDecoder().decode(T.self, from: cacheObject.data)
    }
    
    private func remove(object: Object) {
        try! realm.write { [weak self] in
            self?.realm.delete(object)
        }
    }
    
    private func isTimeValid(for object: CacheObject) -> Bool {
        object.timestamp + object.storageTime > timestamp
    }
}

class CacheObject: Object {
    @objc dynamic var data = Data()
    @objc dynamic var className = ""
    @objc dynamic var timestamp = 0
    @objc dynamic var storageTime = 0
}

enum StorageTime {
    case minutes(Int)
    case hours(Int)
    
    var seconds: Int {
        switch self {
            case .minutes(let value):
                return value*60
            case .hours(let value):
                return value*3600
        }
    }
}
