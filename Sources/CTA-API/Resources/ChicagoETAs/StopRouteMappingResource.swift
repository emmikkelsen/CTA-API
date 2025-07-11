//
//  StopRouteMappingResource.swift
//  CTA Tracker
//
//  Created by Emil Bach Mikkelsen on 07/10/25.
//

import Foundation

public struct StopRouteMappingResource: APIResource {

    public var methodPath = "stops_to_routes.json"
    public var filter: [URLQueryItem]
    public var apiType: APIType

    public init(apiType: ChicagoETAType) {
        filter = []
        self.apiType = .ChicagoETA(apiType: apiType)
    }

    public func decode(response: RawSubStopWrapper) -> [RawSubStop] {
        return response.stops
    }
}
