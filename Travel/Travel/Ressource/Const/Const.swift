//
//  Const.swift
//  Travel
//
//  Created by Teddy Bérard on 06/07/2019.
//  Copyright © 2019 TeddyBerard. All rights reserved.
//

import Foundation

struct Const {
    
    struct UserDefaultsKey {
        static let cities = "Cities"
    }
    
    struct ErrorSpecific {
        static let noConnection = "The Internet connection appears to be offline."
    }
    
    struct ErrorAlert {
        static let errorOccured = "Une erreur est survenue."
        static let errorNetwork = "Veuillez vérifier votre connection internet."
        static let errorDefault = "Si le probème persiste veuillez nous contacter."
        static let errorCity = "Veuillez vérifier l'orthographe de la ville souhaiter."
        static let errorAlreayPresent = "Cette ville est déjà présente dans votre liste."
    }
    
}
