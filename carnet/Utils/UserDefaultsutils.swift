//
//  UserDefaultsutils.swift
//  carnet
//
//  Created by Evgeniy Makhalin on 15.07.2022.
//

import Foundation

class UserDefaultsUtils {
    static var shared = UserDefaultsUtils()
    
    func setDarkMode(enable: Bool) {
        let defaults = UserDefaults.standard
        defaults.set(enable, forKey: Constants.DARK_MODE)
    }
    
    func getDarkMode() -> Bool {
        let defaults = UserDefaults.standard
        return defaults.bool(forKey: Constants.DARK_MODE)
    }
}
