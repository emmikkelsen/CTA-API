//
//  JSONDecoder+ChicagoLocal.swift
//  CTA Tracker
//
//  Created by Emil Bach Mikkelsen on 2/17/25.
//

import Foundation

extension JSONDecoder.DateDecodingStrategy {
    static let chicagoLocal = custom { decoder in
        let dateStr = try decoder.singleValueContainer().decode(String.self)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.timeZone = TimeZone(identifier: "America/Chicago")

        if let date = formatter.date(from: dateStr) {
            return date
        }
        throw DecodingError.dataCorrupted(
            DecodingError.Context(
                codingPath: decoder.codingPath,
                debugDescription: "Invalid date"))
    }
}
