//
//  RawStop.swift
//  CTA Tracker
//
//  Created by Emil Bach Mikkelsen on 11/30/24.
//

import Foundation

public struct RawGlobalStop: Decodable, Sendable {
    public let name: String
    public let sub: [String]
    public let lat: Double
    public let lon: Double
    public let pid: String?

    public var isParent: Bool {
        pid != nil
    }
}

public struct RawSubStop: Decodable, Sendable {
    public let stopName: String
    public let stopId: String
    public let routes: [RawRoute]

    enum CodingKeys: String, CodingKey {
        case stopName = "stop_name"
        case stopId = "stop_id"
        case routes
    }
}

public struct RawRoute: Decodable, Sendable {
    public let route: String
    public let direction: String
}

public struct RawGlobalStopWrapper: Decodable, EmptyInit {
    public let stops: [RawGlobalStop]

    public static func initEmpty() -> RawGlobalStopWrapper {
        RawGlobalStopWrapper(stops: [])
    }
}

public struct RawSubStopWrapper: Decodable, EmptyInit {
    public let stops: [RawSubStop]

    public static func initEmpty() -> RawSubStopWrapper {
        RawSubStopWrapper(stops: [])
    }
}
