//
//  VehicleResource 2.swift
//  CTA Tracker
//
//  Created by Emil Bach Mikkelsen on 11/27/24.
//

import Foundation

public struct PatternResource: APIResource {

    public var methodPath = "getpatterns"
    public var filter: [URLQueryItem]
    public var apiType: APIType = .CTA(apiType: .bus)

    public init(pid: Int) {
        filter = [URLQueryItem(name: "pid", value: String(pid))]
    }

    public func decode(response: PatternResponse) -> Pattern? {
        return response.bustimeResponse.ptr.first
    }

}
