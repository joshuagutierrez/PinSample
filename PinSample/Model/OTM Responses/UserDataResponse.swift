//
//  UserDataResponse.swift
//  PinSample
//
//  Created by Josh Gutierrez on 10/25/22.
//  Copyright © 2022 Udacity. All rights reserved.
//

import Foundation

struct User: Codable {
    let firstName: String
    let lastName: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
    }
}
