//
//  AuthSessionResponse.swift
//  PinSample
//
//  Created by Josh Gutierrez on 10/21/22.
//  Copyright © 2022 Udacity. All rights reserved.
//

import Foundation

struct AuthSessionResponse: Codable {
    let account: AccountResponse?
    let session: SessionResponse?
}

struct AccountResponse: Codable {
    let registered: Bool
    let key: String
}

struct SessionResponse: Codable {
    let id: String?
    let expiration: String?
}
