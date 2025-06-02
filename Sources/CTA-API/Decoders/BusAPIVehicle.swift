//
//  Vehicle.swift
//  CTA Tracker
//
//  Created by Emil Bach Mikkelsen on 11/27/24.
//
struct BusAPIVehicle: Decodable {
    let vid: String
    let tmstmp: String
    let lat: DoubleFromString
    let lon: DoubleFromString
    let hdg: DoubleFromString
    let pid: Int
    let rt: String // swiftlint:disable:this identifier_name
    let des: String
    let pdist: Int
    let dly: Bool
    let tatripid: String
    let origtatripno: String
    let tablockid: String
    let zone: String
    let mode: Int
    let psgld: String
    let stst: Int
    let stsd: String

    func toBus() -> Bus {
        return Bus(
            destination: self.des,
            route: self.rt,
            CTAID: self.vid,
            patternId: self.pid,
            location: Coordinate(
                latitude: self.lat.value, longitude: self.lon.value),
            delayed: dly
        )
    }
}

struct VehicleWrapper: Decodable {
    let vehicle: [BusAPIVehicle]
}

public struct VehicleResponse: Decodable, EmptyInit {
    public static func initEmpty() -> VehicleResponse {
        return VehicleResponse(bustimeResponse: VehicleWrapper(vehicle: []))
    }

    let bustimeResponse: VehicleWrapper

    enum CodingKeys: String, CodingKey {
        case bustimeResponse = "bustime-response"
    }
}
