//
//  Pattern.swift
//  CTA Tracker
//
//  Created by Emil Bach Mikkelsen on 11/27/24.
//

import Foundation
import MapKit

public enum PatternNodeType: String, Decodable, Sendable {
    case stop = "S"
    case waypoint = "W"

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let status = try? container.decode(String.self)
        switch status {
        case "S": self = .stop
        case "W": self = .waypoint
        default:
            self = .waypoint
        }
    }

    public init(str: String) {
        switch str {
        case "S": self = .stop
        default:
            self = .waypoint
        }
    }
}

public struct PatternPoint: Decodable, Sendable {
    public let seq: Int
    public let lat: Double
    public let lon: Double
    public let typ: PatternNodeType
    public let stpid: String?
    public let stpnm: String?
    let pdist: Float

    public init(
        seq: Int, lat: Double, lon: Double, typ: PatternNodeType,
        stpid: String?, stpnm: String?, pdist: Float
    ) {
        self.seq = seq
        self.lat = lat
        self.lon = lon
        self.typ = typ
        self.stpid = stpid
        self.stpnm = stpnm
        self.pdist = pdist
    }
}

public struct Pattern: Decodable, Sendable {
    public let pt: [PatternPoint]  // swiftlint:disable:this identifier_name
    let pid: Int
    public let ln: Double  // swiftlint:disable:this identifier_name
    public let rtdir: String
    let dtrpt: String?
    let dtrid: String?

    public init(
        pt: [PatternPoint], pid: Int, ln: Double, rtdir: String, dtrpt: String?,
        dtrid: String?
    ) {
        self.pt = pt
        self.pid = pid
        self.ln = ln
        self.rtdir = rtdir
        self.dtrpt = dtrpt
        self.dtrid = dtrid
    }
}

struct PatternContainer {
    let pattern: Pattern

    func toCoordinates() -> [CLLocationCoordinate2D] {
        return pattern.pt.map({ (point) -> CLLocationCoordinate2D in
            return CLLocationCoordinate2D(
                latitude: point.lat, longitude: point.lon)
        })
    }
}

struct PatternWrapper: Decodable {
    let ptr: [Pattern]
}

public struct PatternResponse: Decodable, EmptyInit {
    public static func initEmpty() -> PatternResponse {
        PatternResponse(bustimeResponse: PatternWrapper(ptr: []))
    }

    let bustimeResponse: PatternWrapper

    enum CodingKeys: String, CodingKey {
        case bustimeResponse = "bustime-response"
    }
}
