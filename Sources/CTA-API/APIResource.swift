//
//  APIResource.swift
//  CTA Tracker
//
//  Created by Emil Bach Mikkelsen on 11/27/24.
//

import Foundation

public protocol EmptyInit {
    static func initEmpty() -> Self
}

public enum APIType: Sendable {
    case bus
    case train
}

public protocol APIResource {
    associatedtype APIModelType: Decodable, EmptyInit
    associatedtype Resource
    var methodPath: String { get }
    var filter: [URLQueryItem] { get }
    var apiType: APIType { get }
    func decode(response: APIModelType) -> Resource
}

extension APIResource {
    var url: URL {
        switch apiType {
        case .bus:
            return URL(string: "https://www.ctabustracker.com/bustime/api/v3/")!
                .appendingPathComponent(methodPath)
                .appending(
                    queryItems: filter + [
                        URLQueryItem(name: "format", value: "json")
                    ])
        case .train:
            return URL(string: "https://lapi.transitchicago.com/api/1.0/")!
                .appendingPathComponent(methodPath)
                .appending(
                    queryItems: filter + [
                        URLQueryItem(name: "outputType", value: "JSON")
                    ])
        }
    }
}
