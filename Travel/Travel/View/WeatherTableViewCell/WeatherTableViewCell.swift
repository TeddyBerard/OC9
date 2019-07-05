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
    @IBOutlet weak var WeatherDescriptionLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
