//
//  Coordinate.swift
//  CTA-API
//
//  Created by Emil Mikkelsen on 6/1/25.
//


public struct Coordinate: Sendable, Codable, Hashable {
    public let latitude: Double
    public let longitude: Double

    public init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}
