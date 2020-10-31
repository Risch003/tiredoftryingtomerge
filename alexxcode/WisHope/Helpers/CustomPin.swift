//
//  CustomPin.swift
//  WisHope
//
//  Created by Alex Moeller on 10/24/20.
//  Copyright © 2020 Kyle Cain. All rights reserved.
//

import Foundation
import MapKit



// Class so that the pin can change color based on location extends from

// MKAnnotation



class CustomPin: NSObject, MKAnnotation {

    

    var title: String?

    var lat: Double

    var long: Double
    
    var type: String?
    
    var name: String?
    
    var address: String?
    
    var city: String?
    
    var state: String?
    
    var zip: String?
    
    var phone: String?
    
    var website: String?
    
    var coordinate: CLLocationCoordinate2D {

        return CLLocationCoordinate2D(latitude: lat, longitude: long)

    }

    

    init(lat: Double, long: Double) {

        self.lat = lat

        self.long = long

        super.init()

    }

    

    // Function that changes the color of the pin

    // Note that there needs to be another method similar to this for older iphone

    // versions since .pinColor has been depricated

    func newPinImage() -> UIImage{

        switch type {

        case "ADOLESCENTS" :

            return #imageLiteral(resourceName: "adolesents")
            
        case "OUTPATIENT" :

            return #imageLiteral(resourceName: "outpatient")
            
        case "RESOURCE / COMM ORG" :

            return #imageLiteral(resourceName: "resourcePin")
            
        case "RESIDENTIAL" :

            return #imageLiteral(resourceName: "residential")
            
        case "SOBER LIVING" :

            return #imageLiteral(resourceName: "sober")
       
        case "HOMELESS SHELTER" :

            return #imageLiteral(resourceName: "homeless_shelter")

        default :

            return #imageLiteral(resourceName: "no_Type")

        }

    }

    

}
