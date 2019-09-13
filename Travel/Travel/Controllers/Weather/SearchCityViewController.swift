//
//  SearchCityViewController.swift
//  Travel
//
//  Created by Teddy Bérard on 24/07/2019.
//  Copyright © 2019 TeddyBerard. All rights reserved.
//

import UIKit

protocol SearchCityViewDelegate: class {
    func addCity(with id: Double)
}

class SearchCityViewController: UIViewController {

    // MARK: - IBOutlet

    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var countResultLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    // MARK: - Properties

    fileprivate var cities: [City] = []
    fileprivate var result: [String] = []
    fileprivate var alreadySaved: Bool = User.shared.alreadySaveCities()
    weak var delegate: SearchCityViewDelegate?

    // MARK: - Cycle Life

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isDownloadingCities()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    func setupView() {
        countResultLabel.text = ""
        searchTextField.delegate = self
    }

    func isDownloadingCities() {
        if !alreadySaved {
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            checkStopDownloading()
        } else {
            activityIndicator.isHidden = true
        }
    }

    func checkStopDownloading() {
        DispatchQueue.global(qos: .userInteractive).async {
            while !self.alreadySaved {
                self.alreadySaved = User.shared.alreadySaveCities()
                if self.alreadySaved {
                    Thread.sleep(forTimeInterval: TimeInterval(0.5))
                }
            }

            DispatchQueue.main.async {
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
            }

        }
    }

    func searchCities() {
        guard let search = searchTextField.text,
            !search.isEmpty,
            alreadySaved else {
                return
        }

        cities = City.searchCity(by: search).sorted(by: { guard let firstCountry = $0.country,
            let secondCountry = $1.country else { return false}

            return firstCountry > secondCountry
        })
        countResultLabel.text = "Resulat(\(cities.count))"
        searchTableView.reloadData()
    }

    // MARK: - IBAction

    @IBAction func closeAction(_ sender: Any) {
        guard alreadySaved else { return }

        self.dismiss(animated: true, completion: nil)
    }
}

extension SearchCityViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = searchTableView.dequeueReusableCell(withIdentifier: "searchCell") as?
            SearchTableViewCell else { return UITableViewCell() }

        cell.updateText(cityName: cities[indexPath.row].name,
                        country: cities[indexPath.row].country)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.addCity(with: cities[indexPath.row].id)
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITextField

extension SearchCityViewController: UITextFieldDelegate {

    func textFieldDidEndEditing(_ textField: UITextField) {
        searchCities()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        cities = []
        searchTableView.reloadData()
        return true
    }

    @IBAction func editingChangedTextField(_ sender: Any) {
        searchCities()
    }

}
