//
//  Locations.swift
//  WisHope
//
//  Created by Kyle Cain on 2/21/20.
//  Copyright © 2020 Kyle Cain. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import Firebase

struct Location {
    var city: String
    var coordinates: CLLocationCoordinate2D
    var name: String
    var type: String
    
    init?(value: [String: Any]) {
        let city = value["City"] as! String
        let type = value["Type"] as! String
        guard let name = value["Name"] as? String,
        let location = value["Location"] as? GeoPoint
            else {
            return nil
        }
        self.name = name
        self.city = city
        var coordinates = CLLocationCoordinate2D()
        coordinates.latitude = location.latitude
        coordinates.longitude = location.longitude
        self.coordinates = coordinates
        self.type = type
    }
    
    init(city: String, coordinates: CLLocationCoordinate2D, name: String, type: String){
        self.city = city
        self.coordinates = coordinates
        self.name = name
        self.type = type
    }
}
