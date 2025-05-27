//
//  TrainResource.swift
//  CTA Tracker
//
//  Created by Emil Bach Mikkelsen on 11/27/24.
//

import Foundation

public struct TrainResource: APIResource {
    public var methodPath = "ttfollow.aspx"
    public var filter: [URLQueryItem]
    public var apiType: APIType = .train

    public init(runnumber: String) {
        filter = [URLQueryItem(name: "runnumber", value: runnumber)]
    }

    public func decode(response: TrainETAResponse) -> (
        train: Train?, etas: [ETA]
    ) {
        return (
            train: response.ctatt.toTrain(),
            etas: response.ctatt.eta.map { $0.toETA() }
        )
    }
}
