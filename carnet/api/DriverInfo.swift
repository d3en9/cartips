//
//  DriverInfo.swift
//  carnet
//
//  Created by Evgeniy Makhalin on 08.07.2022.
//

import Foundation

struct Driver : Decodable {
    let name: String
    let phone_number: String
}

struct AutoMainInfo : Decodable {
    let body_type: String
    let model: String
    let state_number: String
    let vin_number: String
    let color: String
    let release_year: Int16
    let vrc_number: String
}

struct Auto : Decodable {
    let alarm_system: String
    let mileage: Int32
    let main_info: AutoMainInfo
}

struct Location: Decodable {
    let address: String
    let longitude: Double
    let latitude: Double
}

struct Autoservice : Decodable {
    let autoservice_name: String
    let location: Location
}

struct DriverInfo : Decodable {
    let driver: Driver
    let auto: Auto
    let favorite_autoservice: Autoservice
}
