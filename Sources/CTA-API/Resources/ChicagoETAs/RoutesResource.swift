//
//  RoutesResource.swift
//  CTA Tracker
//
//  Created by Emil Bach Mikkelsen on 07/10/25.
//

import Foundation

public struct RoutesResource: APIResource {

    public var methodPath = "routes.json"
    public var filter: [URLQueryItem]
    public var apiType: APIType

    public init(apiType: ChicagoETAType) {
        filter = []
        self.apiType = .ChicagoETA(apiType: apiType)
    }

    public func decode(response: RawRouteWrapper) -> [RawRouteInfo] {
        return response.routes
    }
}
