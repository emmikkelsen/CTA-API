//
//  ETA.swift
//  CTA API
//
//  Created by Emil Bach Mikkelsen on 1/6/25.
//

import Foundation

public struct Station: Sendable {
    public let name: String
    public let CTAID: String

    public init(name: String, CTAID: String) {
        self.name = name
        self.CTAID = CTAID
    }
}

public struct ETA: Identifiable, Sendable {
    public let station: Station
    public let eta: Date
    public let vehicle: GenericVehicle
    public var id: UUID {
        UUID()
    }

    public init(station: Station, eta: Date, vehicle: GenericVehicle) {
        self.station = station
        self.eta = eta
        self.vehicle = vehicle
    }
}
