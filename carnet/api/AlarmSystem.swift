//
//  AlarmSystemParam.swift
//  carnet
//
//  Created by Evgeniy Makhalin on 12.07.2022.
//

import Foundation

struct AlarmSystemParam : Codable, Identifiable {
    var id: String { return name }
    
    let name: String
    let description: String
    let value: String
    let unit: String
    let active: Bool
}

struct XYCoordinate : Codable {
    let x: Double
    let y: Double
}

struct AlarmSystem: Codable {
    let parameters: [AlarmSystemParam]
    let last_gps: XYCoordinate
    let message: String
}
