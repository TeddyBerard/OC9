//
//  ExchangeViewController.swift
//  Travel
//
//  Created by Teddy Bérard on 21/08/2019.
//  Copyright © 2019 TeddyBerard. All rights reserved.
//

import UIKit

class ExchangeViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var topMoneyTextField: UITextField!
    @IBOutlet weak var bottomMoneyTextField: UITextField!
    @IBOutlet weak var settingBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var switchButton: UIButton!
    @IBOutlet weak var convertButton: UIButton!
    
    enum ActiveCurrency {
        case top
        case bottom
    }
    
    var activeCurrency: ActiveCurrency = .bottom
    private var symboles: [String] = []
    private var rates: ExchangeCurrencies? = nil
    var topCurrency: String = "EUR" {
        didSet {
            setupTextField(with: topMoneyTextField, isActive: true, actualCurrency: topCurrency)
        }
    }
    var bottomCurrency: String = "GBP" {
        didSet{
            setupTextField(with: bottomMoneyTextField, isActive: false, actualCurrency: bottomCurrency)
        }
    }
    
    // MARK: - Cycle Life

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSymboles()
        setupCurrencies()
        setupTextField(with: topMoneyTextField, isActive: true, actualCurrency: topCurrency)
        setupTextField(with: bottomMoneyTextField, isActive: false, actualCurrency: bottomCurrency)
    }
    
    fileprivate func switchTextField() {
        switch activeCurrency {
        case .top:
            setupTextField(with: topMoneyTextField, isActive: true, actualCurrency: topCurrency)
            setupTextField(with: bottomMoneyTextField, isActive: false, actualCurrency: bottomCurrency)
            activeCurrency = .bottom
        case .bottom:
            setupTextField(with: bottomMoneyTextField, isActive: true, actualCurrency: bottomCurrency)
            setupTextField(with: topMoneyTextField, isActive: false, actualCurrency: topCurrency)
            activeCurrency = .top
            break
        }
    }
    
    fileprivate func setupTextField(with textField: UITextField, isActive: Bool, actualCurrency: String) {
        if isActive {
            textField.isEnabled = isActive
            textField.attributedPlaceholder = NSAttributedString(string: actualCurrency,
                                                            attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        } else {
            textField.isEnabled = isActive
            textField.attributedPlaceholder = NSAttributedString(string: actualCurrency,
                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        }
    }

    // MARK: - Setup Exchange

    fileprivate func setupSymboles() {
        Exchange.shared.downloadSymboles(completion: { [weak self] symboles, error  in
            guard let symboles = symboles else {
                return
            }
            self?.symboles = symboles
        })
    }

    fileprivate func setupCurrencies() {
        Exchange.shared.dowloadCurrencies { [weak self] (rates, error) in
            self?.rates = rates
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    func displayCustomError(message: String) {
        guard self.presentedViewController == nil else { return }

        let alertController = UIAlertController(title: Const.ErrorAlert.errorOccured,
                                                message: message,
                                                preferredStyle: .alert)
        let close = UIAlertAction(title: "Fermer", style: .cancel)
        alertController.addAction(close)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - IBAction
    
    @IBAction func switchAction(_ sender: Any) {
        switchTextField()
    }
    

    @IBAction func convertAction(_ sender: Any) {
        guard rates != nil else {
            setupCurrencies()
            displayCustomError(message: Const.ErrorAlert.errorCurrencies)
            return
        }

        if topMoneyTextField.isEnabled,
            let stringAmound = topMoneyTextField.text,
            let amound = Double(stringAmound) {
            bottomMoneyTextField.text = String(format: "%.2f",
                                               Exchange.shared.getRate(amound: amound, first: topCurrency,
                                                                       second: bottomCurrency,
                                                                       rates: rates?.rates).rounded(toPlaces: 2))
        } else if bottomMoneyTextField.isEnabled,
            let stringAmound = bottomMoneyTextField.text,
            let amound = Double(stringAmound) {
            topMoneyTextField.text = String(format: "%.2f",
                                               Exchange.shared.getRate(amound: amound, first: bottomCurrency,
                                                                       second: topCurrency,
                                                                       rates: rates?.rates).rounded(toPlaces: 2))
        }
    }
    
    @IBAction func SettingAction(_ sender: Any) {
        guard !symboles.isEmpty else {
            setupSymboles()
            displayCustomError(message: Const.ErrorAlert.errorSymboles)
            return
        }

        self.definesPresentationContext = true
        let modal = SettingsExchangeViewController()
        modal.delegate = self
        modal.symboles = symboles.sorted(by: { $0 < $1 })
        modal.modalPresentationStyle = .overCurrentContext
        modal.date = rates?.date
        modal.firstSymbole = topCurrency
        modal.secondSymbole = bottomCurrency
        present(modal, animated: true, completion: nil)
    }
}

// MARK: - SettingsExchangeViewControllerDelegate

extension ExchangeViewController: SettingsExchangeViewControllerDelegate {

    func saveCurrencies(topCurrency: String, bottomCurrency: String) {
        self.topCurrency = topCurrency
        self.bottomCurrency = bottomCurrency
    }
}
