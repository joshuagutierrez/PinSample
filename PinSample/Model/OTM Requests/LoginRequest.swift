//
//  LoginRequest.swift
//  PinSample
//
//  Created by Josh Gutierrez on 10/21/22.
//  Copyright © 2022 Udacity. All rights reserved.
//

import Foundation

struct LoginRequest: Codable {
    let udacity: UdacityUserPass
}

struct UdacityUserPass: Codable {
    let username: String
    let password: String
    
    enum CodingKeys: String, CodingKey {
        case username
        case password
    }
}
