//
//  PredictionResource.swift
//  CTA Tracker
//
//  Created by Emil Bach Mikkelsen on 11/27/24.
//

import Foundation

public struct PredictionResource: APIResource {
    public var methodPath = "getpredictions"
    public var filter: [URLQueryItem]
    public var apiType: APIType = .bus

    public init(vid: String) {
        filter = [
            URLQueryItem(name: "vid", value: vid),
            URLQueryItem(name: "unixTime", value: "true")
        ]
    }

    public init(stpid: String) {
        filter = [
            URLQueryItem(name: "stpid", value: stpid),
            URLQueryItem(name: "unixTime", value: "true")
        ]
    }

    public init(stpids: any Sequence<String>) {
        filter = [
            URLQueryItem(name: "stpid", value: stpids.joined(separator: ",")),
            URLQueryItem(name: "unixTime", value: "true")
        ]
    }

    public init(stpid: String, route: String) {
        filter = [
            URLQueryItem(name: "stpid", value: stpid),
            URLQueryItem(name: "rt", value: route),
            URLQueryItem(name: "unixTime", value: "true")
        ]
    }

    public func decode(response: PredictionResponse) -> [ETA] {
        return response.bustimeResponse.prd.map { $0.toETA() }
    }
}
