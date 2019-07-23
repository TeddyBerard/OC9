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
    // "http://api.openweathermap.org/data/2.5/weather?q=Nice&APPID=a2f609206a8846fc64ff22dc5c46abfd"

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
    
    func donwloadNewCity(named: String) {
        self.activityIndicationView.startAnimating()
        self.activityIndicationView.isHidden = false
        Weather.shared.downloadCity(city: named, completion: { weatherCity in
            User.shared.addCity(cityName: named)
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
        let alertController = UIAlertController(title: "Nouvelle météo",
                                                message: "Entrez le nom d'une ville pour recevoir la météo",
                                                preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Ajouter", style: .default) { [weak self] alertAction in
            let textField = alertController.textFields?[0]
            
            guard let cityName = textField?.text else {
                return
            }
            
            if User.shared.getCities().contains(cityName) {
                self?.displayCustomError(message: Const.ErrorAlert.errorAlreayPresent)
                return
            }
            
            self?.donwloadNewCity(named: cityName)
        }
        
        let close = UIAlertAction(title: "Annuler", style: .cancel)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Nom de la ville"
        }
        
        alertController.addAction(action)
        alertController.addAction(close)
        self.present(alertController, animated: true, completion: nil)
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = weatherTableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath)
            as? WeatherTableViewCell else {
                fatalError("The dequeued cell is not an instance of WeatherTableViewCell.")
        }
        
        cell.updateCell(weather: weatherCitys[indexPath.row])
        
        return cell
    }
    
    
}
