//
//  Double+Rounded.swift
//  Travel
//
//  Created by Teddy Bérard on 03/09/2019.
//  Copyright © 2019 TeddyBerard. All rights reserved.
//

import Foundation

extension Double {

    /// Rounded value with places
    ///
    /// - Parameter places: places wanted
    /// - Returns: return the value rounded with places wanted
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
