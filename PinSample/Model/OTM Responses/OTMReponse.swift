//
//  OTMReponse.swift
//  PinSample
//
//  Created by Josh Gutierrez on 10/22/22.
//  Copyright © 2022 Udacity. All rights reserved.
//

import Foundation

struct OTMResponse: Codable {
    let statusCode: Int
    let statusMessage: String
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case statusMessage = "status_message"
    }
}

extension OTMResponse: LocalizedError {
    var errorDescription: String? {
        return statusMessage
    }
}
