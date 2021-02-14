//
//  ForecastDataProvider.swift
//  Weather
//
//  Created by IVAN CHERNOV on 14.02.21.
//

import Foundation

// number of forecast data points per day, as defined by openweathermap API
let pointsPerDay = 8

typealias ForecastDataClosure = (Forecast?) -> Void

class ForecastDataProvider {
    func loadForecastData(isLocal: Bool, completion: @escaping ForecastDataClosure) {
        if isLocal {
            loadLocalWeather(completion: completion)
        } else {
            if let city = SettingsStorage.getSavedCity() {
                loadWeather(for: city.name, completion: completion)
            } else {
                completion(nil)
            }
        }
    }
    
    func loadLocalWeather(completion: @escaping ForecastDataClosure) {
        WeatherDataManager.fetchLocalWeather(fileName: "LocalWeatherData", fileType: "json") { weatherData in
            guard let weatherData = weatherData else { completion(nil); return }
            completion(Forecast(weatherData: weatherData))
        }
    }

    func loadWeather(for cityName: String, completion: @escaping ForecastDataClosure) {
        WeatherDataManager.fetchWeather(for: cityName) { weatherData in
            guard let weatherData = weatherData else { completion(nil); return }
            completion(Forecast(weatherData: weatherData))
        }
    }
}




