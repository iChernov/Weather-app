//
//  Forecast.swift
//  Weather
//
//  Created by IVAN CHERNOV on 14.02.21.
//

import Foundation

class Forecast {
    let cityName: String
    let days: [Date]
    var daysForecasts: [Date: [ForecastPoint]] = [:]
    
    init(weatherData: WeatherData) {
        self.cityName = weatherData.city.name
        let allForecastPoints: [ForecastPoint] = weatherData.list.compactMap { cityData in
            guard let date = DateFormattingHelper.getDate(from: cityData.dtTxt) else { return nil }
            return ForecastPoint(preciseDate: date,
                                 temperature: cityData.main.temp,
                                 iconCode: cityData.weather.first?.icon)
        }
        
        for forecastPoint in allForecastPoints {
            let midnight = Calendar.current.startOfDay(for: forecastPoint.preciseDate)
            if var forecastPointsArray = self.daysForecasts[midnight] {
                forecastPointsArray.append(forecastPoint)
                self.daysForecasts[midnight] = forecastPointsArray
            } else {
                self.daysForecasts[midnight] = [forecastPoint]
            }
        }
        
        self.days = daysForecasts.keys.sorted(by: { $0 < $1 })
    }
}

struct ForecastPoint {
    let preciseDate: Date
    let temperature: Double
    let iconCode: String?
}
