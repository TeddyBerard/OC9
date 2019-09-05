//
//  ExchangeCurrency.swift
//  Travel
//
//  Created by Teddy Bérard on 26/08/2019.
//  Copyright © 2019 TeddyBerard. All rights reserved.
//

import Foundation

class ExchangeCurrencies: Codable {
    let date: String?
    let rates: [String:Double]?

    private enum CodingKeys: String, CodingKey {
        case date
        case rates
    }
}
