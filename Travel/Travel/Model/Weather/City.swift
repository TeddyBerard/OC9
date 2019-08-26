//
//  City.swift
//  Travel
//
//  Created by Teddy Bérard on 29/07/2019.
//  Copyright © 2019 TeddyBerard. All rights reserved.
//

import Foundation
import CoreData

class City: NSManagedObject {
    
    // MARK: - Property
    
    static var all: [City] {
        let request: NSFetchRequest<City> = City.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        guard let items = try? AppDelegate.viewContext.fetch(request) else { return [] }
        return items
    }
    
    // MARK: - Gestion
    
    static func save() {
        DispatchQueue.main.async {
            try? AppDelegate.viewContext.save()
        }
    }
    
    static func addCity(city: NSDictionary) {
        DispatchQueue.main.async {
            let cityObject = City(context: AppDelegate.viewContext)
            
            if let id = city.object(forKey: "id") as? Double {
                cityObject.id = id
            }
            
            if let name = city.object(forKey: "name") as? String {
                cityObject.name = name
            }
            
            if let country = city.object(forKey: "country") as? String {
                cityObject.country = country
            }
        }
    }
    
    static func removeAll(){
        let context = AppDelegate.viewContext
        for item in all {
            context.delete(item)
        }
    }
    
    static func searchCity(by keyword:String) -> [City] {
        let request: NSFetchRequest<City> = City.fetchRequest()
        request.predicate = NSPredicate(format: "name BEGINSWITH [c] %@", keyword)
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        request.fetchLimit = 50
        guard let items = try? AppDelegate.viewContext.fetch(request) else { return [] }
        return items
    }
    
}


