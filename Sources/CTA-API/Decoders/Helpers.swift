//
//  Helpers.swift
//  CTA Tracker
//
//  Created by Emil Bach Mikkelsen on 11/27/24.
//

import Foundation

struct DoubleFromString: Decodable {
    let value: Double
    init(_ double: Double) {
        value = double
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        value = try Double(container.decode(String.self))!
    }
}

struct IntFromString: Decodable {
    let value: Int

    init(_ int: Int) {
        value = int
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        value = try Int(container.decode(String.self))!
    }
}

struct DateFromString: Decodable {
    let value: Date

    init(_ date: Date) {
        value = date
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        value = try Date(
            timeIntervalSince1970: Double(container.decode(String.self))! / 1000
        )
    }
}
