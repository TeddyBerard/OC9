//
//  Weather.swift
//  Travel
//
//  Created by Teddy Bérard on 05/07/2019.
//  Copyright © 2019 TeddyBerard. All rights reserved.
//

import Foundation

class Weather {
    
    static let shared = Weather()
    fileprivate let privateKey: String = "a2f609206a8846fc64ff22dc5c46abfd"
    var baseURL: String = "http://api.openweathermap.org/data/2.5/weather"
    
    enum WeatherError: Error {
        case wrongURL
        case noCity
        case wrongJson
        case noConnection
        case noData
    }
    
    func download(city: String, completion: @escaping (WeatherCity) -> Void,
                  completionErr: @escaping (Error) -> Void) {
        let jsonUrlString = "\(baseURL)?q=\(city)&APPID=\(privateKey)&lang=fr&units=metric"
        guard let url = URL(string: jsonUrlString) else {
            completionErr(WeatherError.wrongURL)
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            if err?.localizedDescription == Const.ErrorSpecific.noConnection {
                completionErr(WeatherError.noConnection)
                return
            }
            
            guard let data = data else {
                completionErr(WeatherError.noData)
                return
            }
            
            do {
                let weatherCity = try JSONDecoder().decode(WeatherCity.self, from: data)
                if let _ = weatherCity.statusCodeErr {
                    completionErr(WeatherError.noCity)
                } else if weatherCity.name != nil {
                    completion(weatherCity)
                } else {
                    completionErr(WeatherError.wrongJson)
                }
            } catch _ {
                completionErr(WeatherError.wrongJson)
            }
            }.resume()
    }
    
    func downloadCities(completion: @escaping (WeatherCity) -> Void,
                       completionErr: @escaping (Error) -> Void) {
        let citys = User.shared.getCities()
        
        for city in citys {
            Weather.shared.download(city: city, completion: completion, completionErr: completionErr)
        }
    }
    
    func downloadCity(city: String, completion: @escaping (WeatherCity) -> Void,
                      completionErr: @escaping (Error) -> Void) {
        Weather.shared.download(city: city, completion: completion, completionErr: completionErr)
    }
}
