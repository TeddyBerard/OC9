//
//  User.swift
//  Travel
//
//  Created by Teddy Bérard on 06/07/2019.
//  Copyright © 2019 TeddyBerard. All rights reserved.
//

import Foundation

class User {
    
    static let shared: User = User()
    
    let userDefaults: UserDefaults = UserDefaults.standard
    
    // MARK: - Weather
    
    func getCities() -> [String] {
        return userDefaults.stringArray(forKey: Const.UserDefaultsKey.cities) ?? ["Nice"]
    }
    
    func addCity(cityName: String?) {
        guard let cityName = cityName else {
            return
        }
        
        var citys = getCities()
        
        guard !citys.contains(cityName) else {
            return
        }
        
        citys.append(cityName)
        userDefaults.set(citys, forKey: Const.UserDefaultsKey.cities)
        userDefaults.synchronize()
    }
    
    func removeCity(cityName: String) {
        var citys = getCities()
        
        if let indexCityToRemove = citys.firstIndex(of: cityName) {
            citys.remove(at: indexCityToRemove)
            userDefaults.set(citys, forKey: Const.UserDefaultsKey.cities)
            userDefaults.synchronize()
        }
    }
    
    func alreadySaveCities() -> Bool {
        return userDefaults.bool(forKey: Const.UserDefaultsKey.alreadySave)
    }
    
    func setAlreadySave() {
        userDefaults.set(true, forKey: Const.UserDefaultsKey.alreadySave)
        userDefaults.synchronize()
    }
}
