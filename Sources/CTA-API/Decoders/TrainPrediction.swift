//
//  Predictions.swift
//  CTA Tracker
//
//  Created by Emil Bach Mikkelsen on 11/29/24.
//

import Foundation

struct Arrival: Decodable, Identifiable {
    let staId: String
    let stpId: String
    let staNm: String
    let stpDe: String
    let rn: String // swiftlint:disable:this identifier_name
    let rt: String // swiftlint:disable:this identifier_name
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
    let lat: DoubleFromString?
    let lon: DoubleFromString?
    let heading: DoubleFromString?

    var id: UUID {
        UUID()
    }

    func toETA() -> ETA {
        return ETA(
            station: Station(name: staNm, CTAID: stpId), eta: arrT,
            vehicle: Train(
                destination: destNm, route: rt, direction: trDr, CTAID: rn))
    }
}

struct ArrivalWrapper: Decodable {
    let eta: [Arrival]
    let tmst: Date
    let errCd: String
    let errNm: String?
}

public struct TrainPredictionResponse: Decodable, EmptyInit {

    let ctatt: ArrivalWrapper

    public static func initEmpty() -> TrainPredictionResponse {
        TrainPredictionResponse(
            ctatt: ArrivalWrapper(eta: [], tmst: Date(), errCd: "0", errNm: ""))
    }
}
