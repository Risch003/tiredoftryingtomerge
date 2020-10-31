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
    var address: String?
    

    
    var state: String?
    
    var zip: String?
    
    var phone: String?
    
    var website: String?
    
    init?(value: [String: Any]) {
        let city = value["City"] as! String
        let type = value["Type"] as! String
        let address = value["Address"] as! String
        let zip = value["Zip"] as! String
        let phone = value["Phone"] as! String
        let website = value["Website"] as! String
        let state = value["State"] as! String
        guard let name = value["Name"] as? String,
        let location = value["Location"] as? GeoPoint
            else {
            return nil
        }
        self.address = address
        self.zip = zip
        self.phone = phone
        self.website = website
        self.name = name
        self.city = city
        self.state = state
        var coordinates = CLLocationCoordinate2D()
        coordinates.latitude = location.latitude
        coordinates.longitude = location.longitude
        self.coordinates = coordinates
        self.type = type
    }
    
    init(city: String, coordinates: CLLocationCoordinate2D, name: String, type: String, address: String, website: String, phone: String, state: String, zip: String){
        self.city = city
        self.coordinates = coordinates
        self.name = name
        self.type = type
        self.type = type
        self.address = address
        self.website = website
        self.phone = phone
        self.state = state
        self.zip = zip
        self.type = type
    }
}
