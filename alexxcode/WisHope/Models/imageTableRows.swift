//
//  imageTableRows.swift
//  WisHope
//
//  Created by Alex Moeller on 10/28/20.
//  Copyright © 2020 Kyle Cain. All rights reserved.
//

import Foundation
import UIKit

struct ImageTableRows {
    var type: String
    var image: UIImage

    
    init(type: String, image: UIImage){
        self.type = type.uppercased()
        self.image = image
    }
}
