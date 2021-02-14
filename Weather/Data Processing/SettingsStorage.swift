//
//  SettingsStorage.swift
//  Weather
//
//  Created by IVAN CHERNOV on 24.01.21.
//

import Foundation

class SettingsStorage {
    class func getSavedCity() -> UserCity? {
        let defaults = UserDefaults.standard
        if let cityData = defaults.object(forKey: "SavedCity") as? Data {
            let decoder = JSONDecoder()
            if let loadedCity = try? decoder.decode(UserCity.self, from: cityData) {
                return loadedCity
            }
        }
        return nil
    }
    
    class func saveCity(city: UserCity) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(city) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "SavedCity")
        }
    }
}
