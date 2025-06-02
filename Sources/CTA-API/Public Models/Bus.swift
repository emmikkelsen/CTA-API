//
//  Bus.swift
//  CTA Tracker
//
//  Created by Emil Bach Mikkelsen on 11/27/24.
//

import Foundation

public struct Bus: GenericVehicle {
    public let destination: String
    public let route: String
    public var direction: String
    public let CTAID: String
    public let patternId: Int?
    public var location: Coordinate?
    public let delayed: Bool
    public let vehicleType: VehicleType = .bus

    public init(
        destination: String, route: String, direction: String = "UNKNOWN",
        CTAID: String, patternId: Int? = nil,
        location: Coordinate? = nil,
        delayed: Bool = false
    ) {
        self.destination = destination
        self.route = route
        self.direction = direction
        self.CTAID = CTAID
        self.patternId = patternId
        self.location = location
        self.delayed = delayed
    }
}
