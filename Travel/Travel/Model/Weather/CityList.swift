//
//  CityList.swift
//  Travel
//
//  Created by Teddy Bérard on 05/08/2019.
//  Copyright © 2019 TeddyBerard. All rights reserved.
//

import Foundation

class CityList {
    
    static let shared: CityList = CityList()
    
    func getCitiesList(completion: @escaping () -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            if let path = Bundle.main.path(forResource: "ListCity", ofType: "json") {
                do {
                    let data = try Data(contentsOf: URL(fileURLWithPath: path))
                    let jsonResult = try JSONSerialization.jsonObject(with: data)
                    if let jsonResults = jsonResult as? Array<NSDictionary>  {
                        for (index, jsonResult) in jsonResults.enumerated() {
                            print("City number add \(index)")
                            City.addCity(city: jsonResult)
                        }
                        City.save()
                        completion()
                    }
                } catch {
                    // handle error
                }
            }
        }
    }
}
