//
//  Exchange.swift
//  Travel
//
//  Created by Teddy Bérard on 26/08/2019.
//  Copyright © 2019 TeddyBerard. All rights reserved.
//

import Foundation

class Exchange {

    // MARK: - Properties

    static let shared: Exchange = Exchange()
    var baseURL = "http://data.fixer.io/api/"
    fileprivate let key = "d932f4bd372eb3fbf9c0a3bc9c7de17d"

    enum ExchangeError: Error {
        case wrongURL
        case wrongJson
        case noConnection
        case noData
    }

    func downloadSymboles(completion: @escaping ([String]?, Error?) -> Void) {
        guard let url = URL(string: "\(baseURL)symbols?access_key=\(key)") else {
            completion(nil, ExchangeError.wrongURL)
            return
        }

        URLSession.shared.dataTask(with: url) { (data, response, err) in
            if err?.localizedDescription == Const.ErrorSpecific.noConnection {
                completion(nil, ExchangeError.noConnection)
            }

            guard let data = data else {
                completion(nil, ExchangeError.noData)
                return
            }

            do {
                let exchangeSymboles = try JSONDecoder().decode(ExchangeSymbole.self, from: data)
                guard let symboles = exchangeSymboles.symbols else {
                    completion(nil, ExchangeError.wrongJson)
                    return
                }
                completion(symboles.map({ $0.key }), nil)
            } catch _ {
                completion(nil, ExchangeError.wrongJson)
                return
            }
            }.resume()
    }

    func dowloadCurrencies(completion: @escaping (ExchangeCurrencies?, Error?) -> Void) {
        guard let url = URL(string: "\(baseURL)latest?access_key=\(key)") else {
            completion(nil, ExchangeError.wrongURL)
            return
        }

        URLSession.shared.dataTask(with: url) { (data, response, err) in
            if err?.localizedDescription == Const.ErrorSpecific.noConnection {
                completion(nil, ExchangeError.noConnection)
                return
            }

            guard let data = data else {
                completion(nil, ExchangeError.noData)
                return
            }

            do {
                let exchangeCurrencies = try JSONDecoder().decode(ExchangeCurrencies.self, from: data)
                guard exchangeCurrencies.rates != nil,
                    exchangeCurrencies.date != nil else {
                        completion(nil, ExchangeError.wrongJson)
                        return
                }

                completion(exchangeCurrencies, nil)
            } catch _ {
                completion(nil, ExchangeError.wrongJson)
                return
            }
            }.resume()
    }

    func getRate(amound: Double?, first: String,
                 second: String, rates: [String:Double]?) -> Double {
        guard let amound = amound else { return 0 }

        if containsEUR(firstCurrency: first, secondCurrency: second) {
            return convertOtherCurrencies(amound: amound, first: first, second: second, rates: rates) ?? 0
        } else {
            return convertOtherCurrencies(amound: amound,
                                   first: first, second: second,
                                   rates: rates) ?? 0
        }
    }

    func convertCurrencies(amound: Double, first: String,
                           second: String, rates: [String:Double]?,
                           isReverse: Bool) -> Double? {
        guard let rates = rates,
            let rate = getRates(first: first, second: second, rates: rates) else { return nil }

        if isReverse {
            return amound * rate
        } else {
            return amound / rate
        }
    }

    func convertOtherCurrencies(amound: Double, first: String,
                                second: String, rates: [String:Double]?) -> Double? {
        guard let rates = rates,
            let firstRate = rates[first],
            let secondRate = rates[second] else { return nil }

        return ((1 / firstRate) * amound) * secondRate
    }

    func getRates(first: String, second: String, rates: [String:Double]) -> Double? {
        if let firstRate = rates[first], let secondRate = rates[second] {
            return firstRate == 1 ? secondRate : firstRate
        }

        return nil
    }

    func containsEUR(firstCurrency: String, secondCurrency: String) -> Bool {
        if firstCurrency == "EUR" || secondCurrency == "EUR" {
            return true
        }
        return false
    }

}

