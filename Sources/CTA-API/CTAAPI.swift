//
//  CTAAPI.swift
//  CTA Tracker
//
//  Created by Emil Bach Mikkelsen on 11/27/24.
//

import Foundation

#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif

public struct CTAAPI: Sendable {
    let busKey: String
    let trainKey: String
    let caller: @Sendable (URL) async throws -> (Data, URLResponse)

    public init(
        busKey: String, trainKey: String,
        caller: @escaping @Sendable (URL) async throws -> (Data, URLResponse) = { URL in
            try await URLSession.shared.data(from: URL)
        }
    ) {
        self.busKey = busKey
        self.trainKey = trainKey
        self.caller = caller
    }

    private func addKeyToURL(_ url: URL, type: APIType) -> URL {
        return url.appending(queryItems: [
            URLQueryItem(
                name: "key",
                value: ((type == APIType.bus) ? self.busKey : self.trainKey))
        ])
    }

    public func get<T: APIResource>(resource: T) async throws -> T.Resource {
        let url = addKeyToURL(resource.url, type: resource.apiType)
        let (data, _) = try await caller(url)
        var wrapper: T.APIModelType?
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .chicagoLocal
            wrapper = try decoder.decode(T.APIModelType.self, from: data)
        } catch {
            print("Decoding error: \(error)")
            print(String(data: data, encoding: .utf8) ?? "")
            wrapper = T.APIModelType.initEmpty()
        }
        return resource.decode(response: wrapper!)
    }
}
