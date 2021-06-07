//
//  FailableURL.swift
//  Gitwise
//
//  Created by emil.kaczmarski on 02/06/2021.
//

import Foundation

@propertyWrapper
struct FailableCodable<T: Codable>: Codable {
    var wrappedValue: T?

    init (value: T?) {
        self.wrappedValue = value
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if T.self == URL.self, let value = try? container.decode(String.self) {
            wrappedValue = URL(string: value) as? T
        } else {
            wrappedValue = try? container.decode(T.self)
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try? container.encode(wrappedValue)
    }
}
