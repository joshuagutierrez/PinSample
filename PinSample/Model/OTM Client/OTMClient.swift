//
//  OTMClient.swift
//  PinSample
//
//  Created by Josh Gutierrez on 10/22/22.
//  Copyright © 2022 Udacity. All rights reserved.
//
// ***Some Code Borrowed from Udacity "TheMovieManager" App

import Foundation

class OTMClient {
    
    struct Auth {
        
        static var userId = "" //also known as "key" returned in loginresponse
        static var sessionId = ""
    }
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case getStudentLocation
        case createStudentLocation
        case editStudentLocation
        case login
        case logout
        case getPublicUserData
        
        var stringValue: String {
            switch self {
            case .getStudentLocation: return Endpoints.base + "/StudentLocation"
            case .createStudentLocation: return ""
            case .editStudentLocation: return ""
            case .login: return Endpoints.base + "/session"
            case .logout: return ""
            case .getPublicUserData: return ""
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func login(udacity: UdacityUserPass, completion: @escaping (Bool, Error?) -> Void) {
        let body = LoginRequest(udacity: udacity)
        taskForPOSTRequest(url: Endpoints.login.url, responseType: AuthSessionResponse.self, body: body) { response, error in
            if let response = response {
                Auth.sessionId = response.session?.id ?? ""
                Auth.userId = response.account?.key ?? ""
                //TODO: Are there other values that need to be set after login? e.g.user
                //TODO: Should user be an int or String?
                completion(true, nil)
            } else {
                completion(false, nil)
            }
        }
    }
    
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionDataTask {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(OTMResponse.self, from: data) as Error
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
        
        return task
    }
    
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try! JSONEncoder().encode(body)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let range = 5..<data.count
            let newData = data.subdata(in: range) /* subset response data! */
            print(String(data: newData, encoding: .utf8)!)
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(OTMResponse.self, from: data) as Error
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
    }
    
}


