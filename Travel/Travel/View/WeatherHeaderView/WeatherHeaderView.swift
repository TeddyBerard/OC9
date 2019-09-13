//
//  WeatherHeaderView.swift
//  Travel
//
//  Created by Teddy Bérard on 17/08/2019.
//  Copyright © 2019 TeddyBerard. All rights reserved.
//

import UIKit

class WeatherHeaderView: UIView {

    // MARK: - Property

    @IBOutlet var contentView: UIView!

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    func commonInit() {
        Bundle.main.loadNibNamed("WeatherHeaderView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds

    }

}
