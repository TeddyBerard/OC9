//
//  ExchangeTests.swift
//  TravelTests
//
//  Created by Teddy Bérard on 05/09/2019.
//  Copyright © 2019 TeddyBerard. All rights reserved.
//

import XCTest
@testable import Travel

class ExchangeTests: XCTestCase {

    var exchange: Exchange!

    override func setUp() {
        super.setUp()
        exchange = Exchange()
    }

    override func tearDown() {
        super.tearDown()
    }

    // MARK: - Network

    func testDownloadSymboles() {
        let expectation = self.expectation(description: "testDownloadSymboles")
        var symboles: [String]?

        exchange.downloadSymboles { (symbole, nil) in
            symboles = symbole
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(symboles?.isEmpty, false)
    }

    func testDownloadCurrencies() {
        let expectation = self.expectation(description: "testDownloadCurrencies")
        var rates: [String: Double]?

        exchange.dowloadCurrencies { (rate, nil) in
            rates = rate?.rates
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(rates?.isEmpty, false)
    }

    func testWrongUrlDowloadCurrencies() {
        let expectation = self.expectation(description: "testWrongUrlDowloadCurrencies")
        var error: Error? = nil

        exchange.baseURL = "%"
        exchange.dowloadCurrencies { (_, err) in
            error = err
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertEqual(error as? Exchange.ExchangeError, Exchange.ExchangeError.wrongURL)
    }

    func testWrongUrlDowloadSymboles() {
        let expectation = self.expectation(description: "testWrongUrlDowloadSymboles")
        var error: Error? = nil

        exchange.baseURL = "%"
        exchange.downloadSymboles { (nil, err) in
            error = err
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertEqual(error as? Exchange.ExchangeError, Exchange.ExchangeError.wrongURL)
    }

    func testNoDateAvailableSymboles() {
        let expectation = self.expectation(description: "testNoDateAvailableSymboles")
        var error: Error? = nil

        exchange.baseURL = "https://"
        exchange.downloadSymboles { (nil, err) in
            error = err
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertEqual(error  as? Exchange.ExchangeError, Exchange.ExchangeError.noData)
    }

    func testNoDateAvailableCurrencies() {
        let expectation = self.expectation(description: "testNoDateAvailableCurrencies")
        var error: Error? = nil

        exchange.baseURL = "https://"
        exchange.dowloadCurrencies { (_, err) in
            error = err
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertEqual(error as? Exchange.ExchangeError, Exchange.ExchangeError.noData)
    }


    // MARK: - Utils

    func testContainsEUR() {
        XCTAssertEqual(exchange.containsEUR(firstCurrency: "EUR", secondCurrency: "GBP"), true)
    }

    func testDontContainsEUR() {
        XCTAssertEqual(exchange.containsEUR(firstCurrency: "USD", secondCurrency: "GBP"), false)
    }

    func testGetRates() {
        let symboles: [String] = ["EUR", "USD"]
        let rates: [String:Double] = ["EUR" : 1 , "USD" : 10]

        XCTAssertEqual(exchange.getRates(first: symboles[0], second: symboles[1], rates: rates), 10)
        XCTAssertEqual(exchange.getRates(first: symboles[1], second: symboles[0], rates: rates), 10)
        XCTAssertEqual(exchange.getRates(first: "nil", second: symboles[0], rates: rates), nil)
    }

    func testGetRate() {
        let symboles: [String] = ["EUR", "USD", "GBP"]
        let rates: [String:Double] = ["EUR" : 1 , "USD" : 10, "GBP" : 4]

        XCTAssertEqual(exchange.getRate(amound: 1, first: symboles[0], second: symboles[1], rates: rates), 10)
        XCTAssertEqual(exchange.getRate(amound: 1, first: symboles[1], second: symboles[0], rates: rates), 0.1)
        XCTAssertEqual(exchange.getRate(amound: 1, first: symboles[2], second: symboles[1], rates: rates), 2.5)
        XCTAssertEqual(exchange.getRate(amound: 1, first: symboles[2], second: symboles[1], rates: nil), 0)
        XCTAssertEqual(exchange.getRate(amound: nil, first: symboles[2], second: symboles[1], rates: nil), 0)

    }

    func testConvertOtherCurrencies() {
        let symboles: [String] = ["GBP", "USD"]
        let rates: [String:Double] = ["GBP" : 4, "USD" : 10]

        XCTAssertEqual(exchange.convertOtherCurrencies(amound: 1, first: symboles[0],
                                                       second: symboles[1], rates: rates), 2.5)
        XCTAssertEqual(exchange.convertOtherCurrencies(amound: 1, first: symboles[0],
                                                       second: symboles[1], rates: nil), nil)
    }

    func testConvertCurrencies() {
        let symboles: [String] = ["EUR", "USD"]
        let rates: [String:Double] = ["EUR" : 1, "USD" : 10]

        XCTAssertEqual(exchange.convertCurrencies(amound: 1, first: symboles[0], second: symboles[1],
                                                  rates: rates, isReverse: true), 10)
        XCTAssertEqual(exchange.convertCurrencies(amound: 1, first: symboles[1], second: symboles[0],
                                                  rates: rates, isReverse: false), 0.1)
        XCTAssertEqual(exchange.convertCurrencies(amound: 1, first: symboles[0], second: symboles[1],
                                                  rates: nil, isReverse: false), nil)
    }

}
