//
//  Utils.swift
//  WisHope
//
//  Created by Kyle Cain on 5/11/20.
//  Copyright © 2020 Kyle Cain. All rights reserved.
//

import Foundation
// Helper to determine if we're running on simulator or device
struct PlatformUtils {
    static let isSimulator: Bool = {
        var isSim = false
        #if arch(i386) || arch(x86_64)
            isSim = true
        #endif
        return isSim
    }()
}
