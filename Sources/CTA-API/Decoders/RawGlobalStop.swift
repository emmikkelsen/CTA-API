//
//  RawStop.swift
//  CTA Tracker
//
//  Created by Emil Bach Mikkelsen on 11/30/24.
//

import Foundation

public struct RawGlobalStop: Decodable, Sendable {
    let name: String
    let sub: [String]
    let lat: Double
    let lon: Double
    let pid: String?

    var isParent: Bool {
        pid != nil
    }
}

public struct RawSubStop: Decodable, Sendable {
    let stopName: String
    let stopId: String
    let routes: [RawRoute]

    enum CodingKeys: String, CodingKey {
        case stopName = "stop_name"
        case stopId = "stop_id"
        case routes
    }
}

public struct RawRoute: Decodable, Sendable {
    let route: String
    let direction: String
}

public struct RawGlobalStopWrapper: Decodable, EmptyInit {
    let stops: [RawGlobalStop]

    public static func initEmpty() -> RawGlobalStopWrapper {
        RawGlobalStopWrapper(stops: [])
    }
}

public struct RawSubStopWrapper: Decodable, EmptyInit {
    let stops: [RawSubStop]

    public static func initEmpty() -> RawSubStopWrapper {
        RawSubStopWrapper(stops: [])
    }
}
