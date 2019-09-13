//
//  ViewController.swift
//  Travel
//
//  Created by Teddy Bérard on 24/06/2019.
//  Copyright © 2019 TeddyBerard. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {

    @IBOutlet weak var weatherTableView: UITableView!
    @IBOutlet weak var activityIndicationView: UIActivityIndicatorView!

    var weatherCitys: [WeatherCity] = [] {
        didSet {
            DispatchQueue.main.async {
                self.activityIndicationView.stopAnimating()
                self.activityIndicationView.isHidden = true
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        downloadCitys()
    }

    func setupTableView() {
        weatherTableView.register(UINib(nibName: "WeatherTableViewCell", bundle: nil),
                                  forCellReuseIdentifier: "WeatherCell")
        weatherTableView.separatorStyle = .none
    }

    func downloadCitys() {
        activityIndicationView.startAnimating()
        weatherCitys = []

        Weather.shared.downloadCities(completion: { weatherCity  in
            self.weatherCitys.append(weatherCity)
            DispatchQueue.main.async {
                self.weatherTableView.reloadData()
            }
        }, completionErr: { err in
            self.displayError(with: err)
        })
    }

    func donwloadNewCity(id: Double) {
        self.activityIndicationView.startAnimating()
        self.activityIndicationView.isHidden = false
        Weather.shared.downloadCity(city: id, completion: { weatherCity in
            User.shared.addCity(cityId: id)
            self.weatherCitys.append(weatherCity)
            DispatchQueue.main.async {
                self.weatherTableView.reloadData()
            }
        }, completionErr: { err in
            self.displayError(with: err)
        })
    }

    fileprivate func displayError(with error: Error) {
        DispatchQueue.main.async {
            self.activityIndicationView.isHidden = true
            self.activityIndicationView.stopAnimating()
            switch error {
            case Weather.WeatherError.noConnection:
                self.displayCustomError(message: Const.ErrorAlert.errorNetwork)
            case Weather.WeatherError.noCity:
                self.displayCustomError(message: Const.ErrorAlert.errorCity)
            default:
                self.displayCustomError(message: Const.ErrorAlert.errorDefault)
            }
        }
    }

    @IBAction func addCity(_ sender: Any) {
        let main = UIStoryboard(name: "Main", bundle: nil)
        let secondViewController =
            main.instantiateViewController(withIdentifier:
                "SearchCityViewController") as! SearchCityViewController

        secondViewController.delegate = self
        self.present(secondViewController, animated: true, completion: nil)
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

}

extension WeatherViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 146
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherCitys.count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = weatherTableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath)
            as? WeatherTableViewCell else {
                fatalError("The dequeued cell is not an instance of WeatherTableViewCell.")
        }

        cell.updateCell(weather: weatherCitys[indexPath.row])

        return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let weatherView = WeatherHeaderView(frame: CGRect(origin: .zero,
                                                          size: CGSize(width: view.frame.width, height: 91)))

        return weatherView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 91
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let cell = weatherTableView.cellForRow(at: indexPath) as? WeatherTableViewCell {
                weatherCitys.remove(at: indexPath.row)
                User.shared.removeCity(cityId: cell.id)
                weatherTableView.reloadData()
            }
        }
    }

}

extension WeatherViewController: SearchCityViewDelegate {
    func addCity(with id: Double) {
        donwloadNewCity(id: id)
    }

}
