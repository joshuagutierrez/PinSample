//
//  LogoutRequest.swift
//  PinSample
//
//  Created by Josh Gutierrez on 10/24/22.
//  Copyright © 2022 Udacity. All rights reserved.
//

import Foundation

struct LogoutRequest: Codable {
    let sessionId: String
    
    enum CodingKeys: String, CodingKey {
        case sessionId = "session_id"
    }
}
