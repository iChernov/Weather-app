//
//  WeatherTests.swift
//  WeatherTests
//
//  Created by IVAN CHERNOV on 24.01.21.
//

import XCTest
@testable import Weather

class WeatherTests: XCTestCase {
    
    var localForecast: WeatherData!
    var referenceDate: Date!
    
    override func setUpWithError() throws {
        super.setUp()
        let data = try getData(fromJSON: "TestWeatherData")
        localForecast = try JSONDecoder().decode(WeatherData.self, from: data)
        
        let components = DateComponents(calendar: Calendar.current,
                                        year: 2021, month: 1, day: 31,
                                        hour: 0, minute: 0, second: 0)
        referenceDate = Calendar.current.date(from: components)
    }
    
    override func tearDownWithError() throws {
        localForecast = nil
        super.tearDown()
    }
    
    func testParsing() throws {
        XCTAssertEqual(localForecast.city.name, "Munich")
        XCTAssertEqual(localForecast.list.first!.main.temp, 2.64)
        XCTAssertEqual(localForecast.list.first!.weather.first!.icon, "10n")
        XCTAssertEqual(localForecast.list.first!.dtTxt, "2021-01-31 00:00:00")
    }
    
    func testDateFormatting() throws {
        let date = DateFormattingHelper.getDate(from: localForecast.list.first!.dtTxt)
        XCTAssertEqual(date, referenceDate)
    }
    
    func testForecastExtraction() throws {
        let forecast = Forecast(weatherData: localForecast)
        
        XCTAssertEqual(forecast.cityName, "Munich")
        XCTAssertEqual(forecast.days, [referenceDate])
        let forecastPoint = forecast.daysForecasts[referenceDate]?.first
        XCTAssertEqual(forecastPoint, ForecastPoint(preciseDate: referenceDate,
                                                    temperature: 2.64,
                                                    iconCode: "10n"))
    }
}
