//
//  TrainETA.swift
//  CTA Tracker
//
//  Created by Emil Bach Mikkelsen on 11/27/24.
//

import Foundation
import MapKit

struct TrainETA: Decodable, Identifiable {
    let staId: String
    let stpId: String
    let staNm: String
    let stpDe: String
    let rn: String  // swiftlint:disable:this identifier_name
    let rt: String  // swiftlint:disable:this identifier_name
    let destSt: String
    let destNm: String
    let trDr: String
    let prdt: Date
    let arrT: Date
    let isApp: IntFromString
    let isSch: IntFromString
    let isDly: IntFromString
    let isFlt: IntFromString
    let flags: String?

    public var id: UUID {
        UUID()
    }

    func toETA() -> ETA {
        return ETA(
            station: Station(name: staNm, CTAID: stpId), eta: arrT,
            vehicle: Train(
                destination: destNm, route: rt, direction: trDr, CTAID: rn,
                delayed: isDly.value == 1))
    }
}

struct TrainPosition: Decodable {
    let lat: DoubleFromString?
    let lon: DoubleFromString?
    let heading: DoubleFromString?
}

struct TrainWrapper: Decodable {
    let tmst: Date
    let errCd: String
    let errName: String?
    let position: TrainPosition
    let eta: [TrainETA]

    func toTrain() -> Train? {
        let location: CLLocationCoordinate2D?
        if self.position.lat?.value != nil && self.position.lat?.value != nil {
            location = CLLocationCoordinate2D(
                latitude: self.position.lat!.value,
                longitude: self.position.lon!.value)
        } else {
            location = nil
        }

        let firstETA = self.eta.first

        if firstETA?.rt == nil {
            return nil
        }

        return Train(
            destination: firstETA?.destNm ?? "",
            route: firstETA?.rt ?? "",
            CTAID: firstETA?.rn ?? "",
            location: location
        )
    }
}

public struct TrainETAResponse: Decodable, EmptyInit {
    public static func initEmpty() -> TrainETAResponse {
        return TrainETAResponse(
            ctatt: TrainWrapper(
                tmst: Date(), errCd: "0", errName: nil,
                position: TrainPosition(lat: nil, lon: nil, heading: nil),
                eta: []))
    }

    let ctatt: TrainWrapper
}
 
