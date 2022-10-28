//
//  StudentResponse.swift
//  PinSample
//
//  Created by Josh Gutierrez on 10/27/22.
//  Copyright © 2022 Udacity. All rights reserved.
//

import Foundation

struct StudentResponse: Codable {
    
    let results: [StudentLocations]
    
}

struct StudentLocations: Codable {
    let objectId: String?

    let uniqueKey: String?

    let firstName: String?

    let lastName: String?

    let mapString: String?

    let mediaURL: String?

    let latitude: Float?

    let longitude: Float?
}
