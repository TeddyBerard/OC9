//
//  WeatherTests.swift
//  TravelTests
//
//  Created by Teddy Bérard on 14/07/2019.
//  Copyright © 2019 TeddyBerard. All rights reserved.
//

import XCTest
@testable import Travel

class WeatherTests: XCTestCase {
    
    var weather: Weather!

    override func setUp() {
        super.setUp()
        weather = Weather()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testDownloadCorrectCity() {
        let expectation = self.expectation(description: "CorrectCity")
        var weatherCity: WeatherCity? = nil
        
        weather.download(city: 2990440, completion: {
            weatherCity = $0
            expectation.fulfill()

        }, completionErr: { _ in })
        
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertEqual(weatherCity?.name, "Nice")
    }
    
    func testDownloadNewCity() {
        let expectation = self.expectation(description: "NewCity")
        var weatherCity: WeatherCity? = nil
        
        weather.downloadCity(city: 2968815, completion: {
            weatherCity = $0
            expectation.fulfill()
        }, completionErr: { _ in })
        
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertEqual(weatherCity?.name, "Paris")
    }
    
    func resetCities() {
        User.shared.userDefaults.set([2990440], forKey: Const.UserDefaultsKey.cities)
        User.shared.userDefaults.synchronize()
        User.shared.addCity(cityId: 2968815)
    }
    
    func testAddNewCity() {
        resetCities()
        
        let expectation = self.expectation(description: "NewCity")
        var weatherCities: [WeatherCity] = []
        
        weather.downloadCities(completion: {
            weatherCities.append($0)
            if weatherCities.count == 2 {
                expectation.fulfill()
            }
        }) { _ in }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        weatherCities = weatherCities.sorted(by: { (firstCity, secondCity) in
            guard let firstName = firstCity.name, let secondName = secondCity.name else { return false }
            
            return firstName < secondName
        } )
        
        XCTAssertEqual(weatherCities[0].name, "Nice")
        XCTAssertEqual(weatherCities[1].name, "Paris")
    }
    
    func testDownloadIncorrentCity() {
        let expectation = self.expectation(description: "IncorrectCity")
        var error: Error? = nil

        weather.download(city: -1, completion: { _ in }, completionErr: { err in
            error = err
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertEqual(error as? Weather.WeatherError, Weather.WeatherError.noCity)
    }
    
    func testWrongUrl() {
        let expectation = self.expectation(description: "IncorrectCity")
        var error: Error? = nil
        
        weather.baseURL = "%"
        weather.download(city: -1, completion: { _ in }, completionErr: { err in
            error = err
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertEqual(error as? Weather.WeatherError, Weather.WeatherError.wrongURL)
    }
    
    func testNoDateAvailable() {
        let expectation = self.expectation(description: "IncorrectCity")
        var error: Error? = nil
        
        weather.baseURL = "https://"
        weather.download(city: -1, completion: { _ in }, completionErr: { err in
            error = err
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertEqual(error as? Weather.WeatherError, Weather.WeatherError.noData)
    }
    
    func testWrongJson() {
        let expectation = self.expectation(description: "IncorrectCity")
        var error: Error? = nil
        
        weather.baseURL = "http://api.plos.org/search?q=title:DNA"
        weather.download(city: -1, completion: { _ in }, completionErr: { err in
            error = err
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertEqual(error as? Weather.WeatherError, Weather.WeatherError.wrongJson)
    }
    
    
    // Disable network to test
    func testNoConnection() {
        let expectation = self.expectation(description: "IncorrectCity")
        var error: Error? = nil
        
        weather.download(city: -1, completion: { _ in }, completionErr: { err in
            error = err
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertEqual(error as? Weather.WeatherError, Weather.WeatherError.noConnection)
    }

}
