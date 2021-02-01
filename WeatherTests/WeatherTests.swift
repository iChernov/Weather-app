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
    
    override func setUpWithError() throws {
        super.setUp()
        let data = try getData(fromJSON: "TestWeatherData")
        localForecast = try JSONDecoder().decode(WeatherData.self, from: data)
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
}
