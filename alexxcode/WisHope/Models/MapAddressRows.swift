//
//  MapAddressRows.swift
//  WisHope
//
//  Created by Alex Moeller on 10/27/20.
//  Copyright © 2020 Kyle Cain. All rights reserved.
//

import Foundation

import Foundation
import UIKit

struct MapAddressRows {
    
    var image: UIImage
    var address: String
    var city: String
    var state: String
    var zip: String
    

    
    init(image: UIImage, address: String, city: String, state: String, zip: String){
        self.image = image
        self.address = address
        self.city = city
        self.state = state
        self.zip = zip
    }
}
