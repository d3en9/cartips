//
//  authRequest.swift
//  carnet
//
//  Created by Evgeniy Makhalin on 06.07.2022.
//

import Foundation

struct authRequest : Codable {
    let email: String
    let password: String
}
