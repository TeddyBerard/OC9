//
//  WeatherTableViewCell.swift
//  Travel
//
//  Created by Teddy Bérard on 04/07/2019.
//  Copyright © 2019 TeddyBerard. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var nameCityLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var weatherTemperatureLabel: UILabel!
    @IBOutlet weak var weatherHumidityLabel: UILabel!

    var id: Double = 0

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func updateCell(weather: WeatherCity) {
        id = weather.id ?? 0
        nameCityLabel.text = weather.name ?? ""

        weatherDescriptionLabel.text = weather.weather?.first?.description?.uppercased()
        if let temp = weather.main?.temp?.rounded() {
            weatherTemperatureLabel.text = "\(temp)°"
        }

        if let humidity = weather.main?.humidity?.rounded() {
            weatherHumidityLabel.text = "\(humidity)%"
        }
        if let name = weather.weather?.first?.getImageName() {
            weatherImageView.image = UIImage(named: name)
        }
    }

}
