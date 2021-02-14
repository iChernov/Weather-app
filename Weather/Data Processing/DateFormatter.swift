//
//  DateFormatter.swift
//  Weather
//
//  Created by IVAN CHERNOV on 14.02.21.
//

import Foundation

class DateFormattingHelper {
    /// extract date from string, received from openWeatherMap.org
    class func getDate(from apiDateString: String) -> Date? {
        return apiDateString.toDate(dateFormat: "yyyy-MM-dd HH:mm:ss")
    }
    
    class func getSimpleDateString(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy\nHH:mm"
        return dateFormatter.string(from: date)
    }
}
