//
//  GenericVehicle.swift
//  CTA Tracker
//
//  Created by Emil Bach Mikkelsen on 1/6/25.
//

import MapKit

public protocol GenericVehicle: VehicleWithID, Sendable {
    var destination: String { get }
    var route: String { get }
    var vehicleType: VehicleType { get }
    var direction: String { get }
    var CTAID: String { get }
    var location: CLLocationCoordinate2D? { get }
    var delayed: Bool { get }
}

public protocol VehicleWithID {
    var CTAID: String { get }
    var vehicleType: VehicleType { get }
}

public struct BaseVehicle: VehicleWithID {
    public let CTAID: String
    public let vehicleType: VehicleType
    public init(CTAID: String, vehicleType: VehicleType) {
        self.CTAID = CTAID
        self.vehicleType = vehicleType
    }
}

public enum VehicleType: Sendable, Codable {
    case bus
    case train
}
