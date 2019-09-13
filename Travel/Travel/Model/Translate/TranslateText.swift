//
//  TranslateText.swift
//  Travel
//
//  Created by Teddy Bérard on 11/09/2019.
//  Copyright © 2019 TeddyBerard. All rights reserved.
//

import Foundation

class TranslateText: Codable {
    let data: Content

    private enum CodingKeys: String, CodingKey {
        case data
    }
}

class Content: Codable {
    let translations: [Translations]

    private enum CodingKeys: String, CodingKey {
        case translations
    }
}

class Translations: Codable {
    let translatedText: String

    private enum CodingKeys: String, CodingKey {
        case translatedText
    }
}
