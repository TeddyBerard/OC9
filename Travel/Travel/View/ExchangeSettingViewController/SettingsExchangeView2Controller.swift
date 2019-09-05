//
//  SettingsExchange2ViewController.swift
//  Travel
//
//  Created by Teddy Bérard on 21/08/2019.
//  Copyright © 2019 TeddyBerard. All rights reserved.
//

import UIKit

protocol SettingsExchangeViewControllerDelegate: class {
    func saveCurrencies(topCurrency: String, bottomCurrency: String)
}

class SettingsExchangeViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet weak var topMoneyPickerView: UIPickerView!
    @IBOutlet weak var bottomMoneyPickerView: UIPickerView!
    @IBOutlet weak var validateButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var downloadDateLabel: UILabel!

    weak var delegate: SettingsExchangeViewControllerDelegate?
    var symboles: [String] = []
    var firstSymbole: String?
    var secondSymbole: String?
    var date: String?

    // MARK: - Cycle Life
    

    override func viewDidLoad() {
        super.viewDidLoad()

        setupButton()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupPicker()
        downloadDateLabel.text = date
        downloadDateLabel.isHidden = false
    }

    func setupView() {
        containerView.layer.cornerRadius = 20
    }
    
    func setupPicker() {
        for index in 1...2 {
            topMoneyPickerView.subviews[index].isHidden = true
            bottomMoneyPickerView.subviews[index].isHidden = true
        }
        setupSymbole()
    }

    func setupButton() {
        validateButton.layer.borderWidth = 1
        resetButton.layer.borderWidth = 1
        validateButton.layer.borderColor = UIColor.black.cgColor
        resetButton.layer.borderColor = UIColor.black.cgColor
    }

    func setupSymbole() {
        guard let first = firstSymbole, let second = secondSymbole else {
            return
        }

        topMoneyPickerView.selectRow(symboles.firstIndex(where: { $0 == first }) ?? 0,
                                     inComponent: 0,
                                     animated: true)
        bottomMoneyPickerView.selectRow(symboles.firstIndex(where: { $0 == second }) ?? 0,
                                     inComponent: 0,
                                     animated: true)
    }
    
    // MARK: - IBAction
    
    @IBAction func switchAction(_ sender: Any) {
        let bottomSelectedRow = bottomMoneyPickerView.selectedRow(inComponent: 0)
        bottomMoneyPickerView.selectRow(topMoneyPickerView.selectedRow(inComponent: 0), inComponent: 0, animated: true)
        topMoneyPickerView.selectRow(bottomSelectedRow, inComponent: 0, animated: true)
    }
    
    @IBAction func validateAction(_ sender: Any) {
        delegate?.saveCurrencies(topCurrency: symboles[topMoneyPickerView.selectedRow(inComponent: 0)],
                                 bottomCurrency: symboles[bottomMoneyPickerView.selectedRow(inComponent: 0)])
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func resetAction(_ sender: Any) {
        setupSymbole()
    }
    
}

extension SettingsExchangeViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return symboles.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 60
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return symboles[row]
    }

}
