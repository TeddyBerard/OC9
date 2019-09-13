//
//  ExchangeSymbole.swift
//  Travel
//
//  Created by Teddy Bérard on 26/08/2019.
//  Copyright © 2019 TeddyBerard. All rights reserved.
//

import Foundation

class ExchangeSymbole: Codable {
    let succes: Bool?
    let symbols: [String: String]?

    private enum CodingKeys: String, CodingKey {
        case succes
        case symbols
    }
}
