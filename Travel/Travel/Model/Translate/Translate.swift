//
//  Translate.swift
//  Travel
//
//  Created by Teddy Bérard on 09/09/2019.
//  Copyright © 2019 TeddyBerard. All rights reserved.
//

import Foundation

class Translate {

    // MARK: - Properties

    static let shared: Translate = Translate()
    var baseURL = "https://translation.googleapis.com/language/translate/v2?key=AIzaSyCqz6wHGIVwXrzp2PTJjvsRCRfkpEKbUdw"

    enum TranslateError: Error {
        case wrongURL
        case wrongJson
        case noConnection
        case noData
    }

    func getTranslate(text: String, source: String = "fr", target: String = "en",
                      completion: @escaping (String?, Error?) -> Void) {
        guard let url = URL(string: baseURL),
            let httpBody = createBody(text: text, source: source, target: target) else {
                completion(nil, TranslateError.wrongURL)
                return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = httpBody

        URLSession.shared.dataTask(with: request) { data, _, err in
            if err?.localizedDescription == Const.ErrorSpecific.noConnection {
                completion(nil, TranslateError.noConnection)
            }

            guard let data = data, err == nil else {
                completion(nil, TranslateError.noData)
                return
            }

            do {
                let translate = try JSONDecoder().decode(TranslateText.self, from: data)
                completion(translate.data.translations.first?.translatedText, nil)
            } catch {
                completion(nil, TranslateError.wrongJson)
            }

            }.resume()
    }

    func createBody(text: String, source: String, target: String) -> Data? {
        let body = "&q=\(text)&source=\(source)&target=\(target)"

        return body.data(using: .utf8)
    }

}
