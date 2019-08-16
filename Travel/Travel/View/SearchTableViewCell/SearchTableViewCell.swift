//
//  SearchTableViewCell.swift
//  Travel
//
//  Created by Teddy Bérard on 24/07/2019.
//  Copyright © 2019 TeddyBerard. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var searchLabel: UILabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateText(cityName: String?, country: String?) {
        
        searchLabel.text = "\(cityName!), \(country!)"
    }

}
