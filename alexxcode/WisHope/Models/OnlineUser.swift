//
//  OnlineUser.swift
//  WisHope
//
//  Created by Kyle Cain on 7/22/20.
//  Copyright © 2020 Kyle Cain. All rights reserved.
//

import Foundation

class OnlineUsers: Codable {
    var firstName: String?
    var lastName: String?
    var online: String?
    var uid: String?
    
    init (firstName: String, lastName: String, online: String, uid: String){
        self.firstName = firstName;
        self.lastName = lastName;
        self.online = online;
        self.uid = uid
    }
}
