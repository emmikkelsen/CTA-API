//
//  Pattern.swift
//  CTA Tracker
//
//  Created by Emil Bach Mikkelsen on 11/27/24.
//

import Foundation
import MapKit

struct TrainPatternPoint: Decodable {
    let seq: Int
    let lat: Double
    let lon: Double
    let typ: Typ
    let stpid: String?
    let stpnm: String?
    let pdist: Float

    enum Typ: String, Decodable {
        case stop = "S"
        case waypoint = "W"

        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            let status = try? container.decode(String.self)
            switch status {
            case "S": self = .stop
            case "W": self = .waypoint
            default:
                self = .waypoint
            }
        }

        init(str: String) {
            switch str {
            case "S": self = .stop
            default:
                self = .waypoint
            }
        }
    }
}

struct TrainPattern: Decodable {
    let pt: [TrainPatternPoint] // swiftlint:disable:this identifier_name
    let pid: Int
    let ln: Double // swiftlint:disable:this identifier_name
    let rtdir: String
    let dtrpt: String?
    let dtrid: String?
}

struct TrainPatternContainer {
    let pattern: TrainPattern

    func toCoordinates() -> [CLLocationCoordinate2D] {
        return pattern.pt.map({ (point) -> CLLocationCoordinate2D in
            return CLLocationCoordinate2D(
                latitude: point.lat, longitude: point.lon)
        })
    }
}

struct TrainPatternWrapper: Decodable {
    let ptr: [TrainPattern]
}

struct TrainPatternResponse: Decodable, EmptyInit {
    static func initEmpty() -> TrainPatternResponse {
        TrainPatternResponse(bustimeResponse: TrainPatternWrapper(ptr: []))
    }

    let bustimeResponse: TrainPatternWrapper

    enum CodingKeys: String, CodingKey {
        case bustimeResponse = "bustime-response"
    }
}
