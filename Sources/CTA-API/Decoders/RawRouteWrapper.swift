//
//  RawRouteWrapper.swift
//  CTA Tracker
//
//  Created by Emil Bach Mikkelsen on 12/12/24.
//

public struct RawRouteWrapper: Decodable, EmptyInit {
    public let routes: [RawRouteInfo]

    public static func initEmpty() -> RawRouteWrapper {
        return RawRouteWrapper(routes: [])
    }
}

public struct RawRouteInfo: Decodable, Sendable {
    public let identifier: String
    public let shortName: String
    public let longName: String
    public let color: String
    public let type: String
    public let textColor: String

    enum CodingKeys: String, CodingKey {
        case identifier
        case shortName = "short_name"
        case longName = "long_name"
        case color
        case type
        case textColor = "text_color"
    }
}
