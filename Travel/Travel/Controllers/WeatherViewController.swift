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
   // "http://api.openweathermap.org/data/2.5/weather?q=Nice&APPID=a2f609206a8846fc64ff22dc5c46abfd"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
    }
    
    func setupTableView() {
        weatherTableView.register(UINib(nibName: "WeatherTableViewCell", bundle: nil),
                                  forCellReuseIdentifier: "WeatherCell")
        weatherTableView.separatorStyle = .none
    }


}

extension WeatherViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 146
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = weatherTableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath)
            as? WeatherTableViewCell else {
                fatalError("The dequeued cell is not an instance of WeatherTableViewCell.")
        }
        
        return cell
    }
    
    
}

