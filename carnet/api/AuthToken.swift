//
//  authResponse.swift
//  carnet
//
//  Created by Evgeniy Makhalin on 06.07.2022.
//

import Foundation



struct RefreshTokenResponse : Codable {
    let access_token: String
    let refresh_token: String
}

struct AuthToken : Codable {
    var access_token: String?
    var refresh_token: String?
    let registered: Bool?
}
