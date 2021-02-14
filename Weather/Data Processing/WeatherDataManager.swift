//
//  WeatherDataManager.swift
//  Weather
//
//  Created by IVAN CHERNOV on 24.01.21.
//

import Foundation
import UIKit

class WeatherDataManager {
    static fileprivate let apiKey: String = "5452871acf042b9cc2c36467611209f6"
    class func fetchWeather(for cityName: String, completion: @escaping (WeatherData?) -> Void) {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/forecast?q=\(cityName)&units=metric&appid=\(WeatherDataManager.apiKey)") else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if let error = error {
                print("Error with fetching films: \(error)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                // we can make some meaningful logging here
                completion(nil)
                print("Error with the response, unexpected status code: \(String(describing: response))")
                return
            }
            
            if let data = data,
               let weatherData = try? JSONDecoder().decode(WeatherData.self, from: data) {
                completion(weatherData)
            }
        })
        task.resume()
    }
    
    class func fetchLocalWeather(fileName: String, fileType: String, completion: @escaping (WeatherData?) -> Void) {
        if let path = Bundle.main.path(forResource: fileName, ofType: fileType) {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                if let weatherData = try? JSONDecoder().decode(WeatherData.self, from: data) {
                    completion(weatherData)
                } else {
                    completion(nil)
                }
            } catch {
                completion(nil)
            }
        }
    }
    
}
