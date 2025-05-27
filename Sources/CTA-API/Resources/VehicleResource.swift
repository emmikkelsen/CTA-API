//
//  VehicleResource.swift
//  CTA Tracker
//
//  Created by Emil Bach Mikkelsen on 11/27/24.
//

import Foundation

public struct VehicleResource: APIResource {
    public var methodPath = "getvehicles"
    public var filter: [URLQueryItem]
    public var apiType: APIType = .bus

    public init(vid: String) {
        filter = [URLQueryItem(name: "vid", value: vid)]
    }

    public func decode(response: VehicleResponse) -> Bus? {
        return response.bustimeResponse.vehicle.first?.toBus()
    }
}
