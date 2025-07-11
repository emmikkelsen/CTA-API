//
//  RawRouteWrapper.swift
//  CTA Tracker
//
//  Created by Emil Bach Mikkelsen on 12/12/24.
//

public struct RawRouteWrapper: Decodable, EmptyInit {
    let routes: [RawRouteInfo]

    public static func initEmpty() -> RawRouteWrapper {
        return RawRouteWrapper(routes: [])
    }
}

public struct RawRouteInfo: Decodable, Sendable {
    let identifier: String
    let shortName: String
    let longName: String
    let color: String
    let type: String
    let textColor: String

    enum CodingKeys: String, CodingKey {
        case identifier
        case shortName = "short_name"
        case longName = "long_name"
        case color
        case type
        case textColor = "text_color"
    }
}
