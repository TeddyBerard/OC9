//
//  TranslationViewController.swift
//  Travel
//
//  Created by Teddy Bérard on 25/06/2019.
//  Copyright © 2019 TeddyBerard. All rights reserved.
//

import UIKit

class TranslationViewController: UIViewController {

    // MARK: - Properties

    @IBOutlet weak var wantedTranslatedTextView: UITextView!
    @IBOutlet weak var translatedTextView: UITextView!
    @IBOutlet weak var translateButton: UIButton!

    // MARK: - Cycle Life

    override func viewDidLoad() {
        super.viewDidLoad()
        setupButton()
    }

    func setupButton() {
        translateButton.layer.borderWidth = 1
        translateButton.layer.borderColor = UIColor.black.cgColor
    }

    // MARK: - @IBAction

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    @IBAction func translateAction(_ sender: Any) {
        guard wantedTranslatedTextView.text != "" else {
            return
        }

        Translate.shared.getTranslate(text: wantedTranslatedTextView.text, source: "fr", target: "en",
                                      completion: { textTranslated, err  in
                                        guard err == nil else {
                                            return
                                        }

                                        DispatchQueue.main.async {
                                            self.view.endEditing(true)
                                            self.translatedTextView.text = textTranslated
                                        }
        })
    }

    @IBAction func clearAction(_ sender: Any) {
        wantedTranslatedTextView.text = "Entrez un texte à traduire"
    }

}

extension TranslationViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if wantedTranslatedTextView.text == "Entrez un texte à traduire" {
            wantedTranslatedTextView.text = ""
        }
    }
}
