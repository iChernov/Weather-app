//
//  WeatherDataManager.swift
//  Weather
//
//  Created by IVAN CHERNOV on 24.01.21.
//

import Foundation

class WeatherDataManager {
    static fileprivate let apiKey: String = "29d458fa0f12cf490759b24728e13689"
    //http://api.openweathermap.org/data/2.5/forecast?q=munich&appid=29d458fa0f12cf490759b24728e13689
    
    func fetchWeather(for city: UserCity, completionHandler: @escaping (WeatherData?) -> Void) {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/forecast?q=munich&appid=\(WeatherDataManager.apiKey)") else {
            completionHandler(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if let error = error {
                print("Error with fetching films: \(error)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("Error with the response, unexpected status code: \(response)")
                return
            }
            
            if let data = data,
               let weatherData = try? JSONDecoder().decode(WeatherData.self, from: data) {
                    completionHandler(weatherData)
            }
        })
        task.resume()
    }
    
}



