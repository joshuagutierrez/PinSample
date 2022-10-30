//
//  OTMReponse.swift
//  PinSample
//
//  Created by Josh Gutierrez on 10/22/22.
//  Copyright © 2022 Udacity. All rights reserved.
//

import Foundation

struct OTMResponse: Codable {
    let status: Int
    let error: String

}

extension OTMResponse: LocalizedError {
    var errorDescription: String? {
        return error
    }
}
