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
    var topCurrency: String = "EUR" {
        didSet {
            setupTextField(with: topMoneyTextField, isActive: true, actualCurrency: topCurrency)
        }
    }
    var bottomCurrency: String = "USD" {
        didSet{
            setupTextField(with: bottomMoneyTextField, isActive: false, actualCurrency: bottomCurrency)
        }
    }
    
    // MARK: - Cycle Life

    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    // MARK: - IBAction
    
    @IBAction func switchAction(_ sender: Any) {
        switchTextField()
    }
    
    
    
    @IBAction func convertAction(_ sender: Any) {
        
    }
    
    @IBAction func SettingAction(_ sender: Any) {
        let modal = SettingsExchangeViewController()
        modal.delegate = self
        modal.modalPresentationStyle = .overCurrentContext
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
