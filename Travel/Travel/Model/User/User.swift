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
    
    func getCities() -> [Double] {
        return userDefaults.array(forKey: Const.UserDefaultsKey.cities) as? [Double] ?? []
    }
    
    func addCity(cityId: Double?) {
        guard let cityId = cityId else {
            return
        }
        
        var citys = getCities()
        
        guard !citys.contains(cityId) else {
            return
        }
        
        citys.append(cityId)
        userDefaults.set(citys, forKey: Const.UserDefaultsKey.cities)
        userDefaults.synchronize()
    }
    
    func removeCity(cityId: Double) {
        var citys = getCities()
        
        if let indexCityToRemove = citys.firstIndex(of: cityId) {
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
