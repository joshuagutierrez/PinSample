//
//  PutStudentRequest.swift
//  PinSample
//
//  Created by Josh Gutierrez on 10/29/22.
//  Copyright © 2022 Udacity. All rights reserved.
//

import Foundation

struct PutStudentRequest: Codable {
    let uniqueKey: String?
    let firstName: String?
    let lastName: String?
    let mapString: String?
    let mediaURL: String?
    let latitude: Double?
    let longitude: Double?
}
