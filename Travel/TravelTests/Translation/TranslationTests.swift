//
//  TranslationTests.swift
//  TravelTests
//
//  Created by Teddy Bérard on 11/09/2019.
//  Copyright © 2019 TeddyBerard. All rights reserved.
//

import XCTest
@testable import Travel

class TranslationTests: XCTestCase {

    var translate: Translate!

    override func setUp() {
        super.setUp()
        translate = Translate()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testWrongUrl() {
        let expectation = self.expectation(description: "IncorrectText")
        var error: Error?

        translate.baseURL = "%"
        translate.getTranslate(text: "Hello", source: "en", target: "fr", completion: { _, err in
            error = err
            expectation.fulfill()
        })

        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertEqual(error as? Translate.TranslateError, Translate.TranslateError.wrongURL)
    }

    func testTranslate() {
        let expectation = self.expectation(description: "IncorrectText")
        var text: String?

        translate.getTranslate(text: "Hello", source: "en", target: "fr", completion: { translate, _ in
            text = translate
            expectation.fulfill()
        })

        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertEqual(text, "Bonjour")
    }

    func testWrongJson() {
        let expectation = self.expectation(description: "IncorrectText")
        var error: Error?

        translate.getTranslate(text: "Hello", source: "WRONGSOURCE", target: "fr", completion: { _, err in
            error = err
            expectation.fulfill()
        })

        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertEqual(error as? Translate.TranslateError, Translate.TranslateError.wrongJson)
    }

    func testNoData() {
        let expectation = self.expectation(description: "IncorrectText")
        var error: Error?

        translate.baseURL = "https://"
        translate.getTranslate(text: "Hello", source: "en", target: "fr", completion: { _, err in
            error = err
            expectation.fulfill()
        })

        waitForExpectations(timeout: 5, handler: nil)

        XCTAssertEqual(error as? Translate.TranslateError, Translate.TranslateError.noData)
    }

    func testCreateBody() {
        let text = "test"
        let source = "en"
        let target = "fr"
        let body = String(data: translate.createBody(text: text, source: source, target: target)!, encoding: .utf8)

        XCTAssertEqual(body, "&q=\(text)&source=\(source)&target=\(target)")
    }

}
