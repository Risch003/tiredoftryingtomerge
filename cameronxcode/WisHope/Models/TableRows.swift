//
//  TableRows.swift
//  WisHope
//
//  Created by Doug Cash on 3/29/20.
//  Copyright © 2020 Kyle Cain. All rights reserved.
//

import Foundation
import UIKit

struct TableRows {
    var type: String
    var color: UIColor
    
    init(type: String, color: UIColor){
        self.type = type.uppercased()
        self.color = color
    }
}
