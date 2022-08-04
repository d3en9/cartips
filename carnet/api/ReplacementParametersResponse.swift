//
//  ReplacementParametersResponse.swift
//  carnet
//
//  Created by Evgeniy Makhalin on 15.07.2022.
//

import Foundation

enum ReplacementParameterState : String, Codable {
    case replaceAfter = "replace_after"
    case replaced = "replaced"
    case replaceRequired = "replace_required"
    case notRemember = "not_remember"
}

struct ReplacementParameter : Codable, Identifiable {
    let id: Int
    let titles: ReplacementParameterTitle
    let def_value: Int
    let cur_value: Int
    let unit: String
    let state: ReplacementParameterState
    let active: Bool
    
    var unitValueMessage: String {
        get {
            "\(def_value - cur_value) \(unit)"
        }
    }
    
    private func replaceMessage() -> String {
        switch (state) {
        case .replaceAfter:
            return "До замены"
        case .replaced:
            return "Заменено"
        case .replaceRequired:
            return "Требуется замена"
        case .notRemember:
            return "Не помню"
        }
    }
    
    var titleMessage: String {
        get{
            "\(replaceMessage()) \(titles.list_name)"
        }
    }
}

struct ReplacementParameterTitle : Codable {
    let name: String
    let list_name: String
    let add_info_name: String
}

struct ReplacementParametersResponse : Codable {
    let replacement_parameters: [ReplacementParameter]
}
