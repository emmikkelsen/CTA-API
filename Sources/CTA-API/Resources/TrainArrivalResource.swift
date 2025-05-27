//
//  TrainArrivalResource.swift
//  CTA Tracker
//
//  Created by Emil Bach Mikkelsen on 11/27/24.
//

import Foundation

public struct TrainArrivalResource: APIResource {
    public var methodPath = "ttarrivals.aspx"
    public var filter: [URLQueryItem]
    public var apiType: APIType = .train

    public init(mapid: String) {
        filter = [URLQueryItem(name: "mapid", value: mapid)]
    }

    public init(stpid: String) {
        filter = [URLQueryItem(name: "stpid", value: stpid)]
    }

    public func decode(response: TrainPredictionResponse) -> [ETA] {
        return response.ctatt.eta.map { $0.toETA() }
    }
}
