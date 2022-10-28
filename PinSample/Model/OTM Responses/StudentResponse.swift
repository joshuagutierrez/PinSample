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
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.objectId = try container.decodeIfPresent(String.self, forKey: .objectId) ?? ""
        self.uniqueKey = try container.decodeIfPresent(String.self, forKey: .uniqueKey) ?? ""
        self.firstName = try container.decodeIfPresent(String.self, forKey: .firstName) ?? "[no firstname]"
        self.lastName = try container.decodeIfPresent(String.self, forKey: .lastName) ?? "[no lastname]"
        self.mapString = try container.decodeIfPresent(String.self, forKey: .mapString) ?? ""
        self.mediaURL = try container.decodeIfPresent(String.self, forKey: .mediaURL) ?? "[no mediaURL]"
        self.latitude = try container.decodeIfPresent(Float.self, forKey: .latitude) ?? 0
        self.longitude = try container.decodeIfPresent(Float.self, forKey: .longitude) ?? 0
    }
}
