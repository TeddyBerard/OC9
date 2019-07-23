//
//  Weather.swift
//  Travel
//
//  Created by Teddy Bérard on 05/07/2019.
//  Copyright © 2019 TeddyBerard. All rights reserved.
//

import Foundation

struct WeatherCity: Codable {
    
    let name: String?
    let statusCode: Int?
    let statusCodeErr: String?
    let weather: [WeatherDescription]?
    let main: WeatherMain?
    
    private enum CodingKeys: String, CodingKey {
        case name = "name"
        case weather = "weather"
        case main = "main"
        case statusCode = "cod"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try? container.decode(String.self, forKey: .name)
        statusCode = try? container.decode(Int.self, forKey: .statusCode)
        statusCodeErr = try? container.decode(String.self, forKey: .statusCode)
        weather = try? container.decode([WeatherDescription].self, forKey: .weather)
        main = try? container.decode(WeatherMain.self, forKey: .main)

    }
}

struct WeatherMain: Codable {
    let temp: Float?
    let tempMax: Float?
    let tempMin: Float?
    let pressure: Float?
    let humidity: Float?
    
    private enum CodingKeys: String, CodingKey {
        case temp = "temp"
        case tempMax = "temp_max"
        case tempMin = "temp_min"
        case pressure = "pressure"
        case humidity = "humidity"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        temp = try? container.decode(Float.self, forKey: .temp)
        tempMax = try? container.decode(Float.self, forKey: .tempMax)
        tempMin = try? container.decode(Float.self, forKey: .tempMin)
        pressure = try? container.decode(Float.self, forKey: .pressure)
        humidity = try? container.decode(Float.self, forKey: .humidity)
    }
}

struct WeatherDescription: Codable {
    let description: String?
    let icon: String?
    
    private enum CodingKeys: String, CodingKey {
        case description
        case icon
    }
    
    private enum iconImage: String {
        case clearSkyDay = "01d"
        case clearSkyNight = "01n"
        case fewCloudsDay = "02d"
        case fewCloudsNight = "02n"
        case scatteredCloudsDay = "03d"
        case scatteredCloudsNight = "03n"
        case brokenCloudsDay = "04d"
        case brokenCloudsNight = "04n"
        case showerRainDay = "09d"
        case showerRainNight = "09n"
        case rainDay = "10d"
        case rainNight = "10n"
        case thunderstormDay = "11d"
        case thunderstormNight = "11n"
        case snowDay = "13d"
        case snowNight = "13n"
        case mistDay = "50d"
        case mistNight = "50n"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        description = try? container.decode(String.self, forKey: .description)
        icon = try? container.decode(String.self, forKey: .icon)
    }
    
    func getImageName() -> String? {
        guard let icon = self.icon,
            let iconImage = iconImage(rawValue: icon) else { return nil }
        
        switch iconImage {
        case .clearSkyDay:
            return "clearSkyDay"
        case .clearSkyNight:
            return "clearSkyNight"
        case .fewCloudsDay:
            return "cloudDay"
        case .fewCloudsNight:
            return "cloudNight"
        case .scatteredCloudsDay, .scatteredCloudsNight, .brokenCloudsDay, .brokenCloudsNight:
            return "cloud"
        case .rainDay, .rainNight, .showerRainDay, .showerRainNight:
            return "rain"
        case .thunderstormDay, .thunderstormNight:
            return "thunder"
        case .snowDay, .snowNight:
            return "snow"
        case .mistDay, .mistNight:
            return "mist"
        }
    }
}
