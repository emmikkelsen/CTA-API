//
//  StopMappingResource.swift
//  CTA Tracker
//
//  Created by Emil Bach Mikkelsen on 07/10/25.
//

import Foundation

public struct StopMappingResource: APIResource {

    public var methodPath = "main_to_sub_stop.json"
    public var filter: [URLQueryItem]
    public var apiType: APIType

    public init(apiType: ChicagoETAType) {
        filter = []
        self.apiType = .ChicagoETA(apiType: apiType)
    }

    public func decode(response: RawGlobalStopWrapper) -> [RawGlobalStop] {
        return response.stops
    }
}
