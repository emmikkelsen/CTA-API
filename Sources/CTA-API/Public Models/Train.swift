//
//  Train.swift
//  CTA Tracker
//
//  Created by Emil Bach Mikkelsen on 11/27/24.
//

import Foundation
import MapKit

public struct Train: GenericVehicle {
    public let destination: String
    public let route: String
    public var direction: String
    public let CTAID: String
    public let patternId: String
    public var location: CLLocationCoordinate2D?
    public let delayed: Bool
    public let vehicleType: VehicleType = .train

    public init(
        destination: String, route: String, direction: String = "UNKNOWN",
        CTAID: String, patternId: String = "",
        location: CLLocationCoordinate2D? = nil, delayed: Bool = false
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
