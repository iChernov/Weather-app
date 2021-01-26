//
//  WeatherStructs.swift
//  Weather
//
//  Created by IVAN CHERNOV on 26.01.21.
//

import Foundation

// MARK: - WeatherData
struct WeatherData: Codable {
    let cod: String
    let message, cnt: Int
    let list: [CityData]
    let city: City
}

// MARK: - City
struct City: Codable {
    let id: Int
    let name: String
    let coord: Coordinates
    let country: String
    let timezone, sunrise, sunset: Int
}

// MARK: - Coord
struct Coordinates: Codable {
    let lat, lon: Double
}

// MARK: - List of weather data
struct CityData: Codable {
    let dt: Int
    let main: Main
    let weather: [Weather]
    let clouds: Clouds
    let wind: Wind
    let visibility: Int
    let pop: Double
    let rain: Rain?
    let sys: Sys
    let dtTxt: String

    enum CodingKeys: String, CodingKey {
        case dt, main, weather, clouds, wind, visibility, pop, rain, sys
        case dtTxt = "dt_txt"
    }
}

// MARK: - Clouds
struct Clouds: Codable {
    let all: Int //  Cloudiness, %
}

// MARK: - Main
struct Main: Codable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, seaLevel, grndLevel, humidity: Int
    let tempKf: Double

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case humidity
        case tempKf = "temp_kf"
    }
}

// MARK: - Rain
struct Rain: Codable {
    let volumeForLast3Hours: Double

    enum CodingKeys: String, CodingKey {
        case volumeForLast3Hours = "3h"
    }
}

// MARK: - Sys
struct Sys: Codable {
    let pod: String
}

// MARK: - Weather
struct Weather: Codable {
    let id: Int
    let main, weatherDescription, icon: String

    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double
    let deg: Int
}
