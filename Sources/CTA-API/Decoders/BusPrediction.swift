//
//  Predictions.swift
//  CTA Tracker
//
//  Created by Emil Bach Mikkelsen on 11/29/24.
//

import Foundation

struct Prediction: Decodable, Identifiable {
    let tmstmp: DateFromString
    let typ: String
    let stpnm: String
    let stpid: String
    let vid: String
    let dstp: Int
    let rt: String // swiftlint:disable:this identifier_name
    let rtdd: String
    let rtdir: String
    let des: String
    let prdtm: DateFromString
    let tablockid: String
    let tatripid: String
    let origtatripno: String
    let dly: Bool
    let dyn: Int
    let prdctdn: String
    let zone: String
    let psgld: String
    let stst: Int
    let stsd: String
    let flagstop: Int

    var id: UUID {
        UUID()
    }

    func toETA() -> ETA {

        return ETA(
            station: Station(name: stpnm, CTAID: stpid), eta: prdtm.value,
            vehicle: Bus(
                destination: des, route: rt, direction: rtdir, CTAID: vid,
                delayed: dly
            ))
    }
}

struct PredictionWrapper: Decodable {
    let prd: [Prediction]
}

public struct PredictionResponse: Decodable, EmptyInit {

    let bustimeResponse: PredictionWrapper

    enum CodingKeys: String, CodingKey {
        case bustimeResponse = "bustime-response"
    }

    public static func initEmpty() -> PredictionResponse {
        PredictionResponse(bustimeResponse: PredictionWrapper(prd: []))
    }
}
