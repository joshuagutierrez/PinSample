//
//  OTMClient.swift
//  PinSample
//
//  Created by Josh Gutierrez on 10/22/22.
//  Copyright © 2022 Udacity. All rights reserved.
//
// ***Some Code Borrowed from Udacity "TheMovieManager" App and uses "PinSample" app as a starting point

import Foundation

class OTMClient {
    
    struct Auth {
        
        static var userId = "" //also known as "key" returned in loginresponse
        static var sessionId = ""
        static var firstName = ""
        static var lastName = ""
        static var objectId = ""
    }
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case getStudentLocation
        case postStudentLocation
        case putStudentLocation
        case login
        case logout
        case getUserData
        
        var stringValue: String {
            switch self {
//            case .getStudentLocation: return Endpoints.base + "/StudentLocationINVALID?order=-updatedAt&limit=100"
            case .getStudentLocation: return Endpoints.base + "/StudentLocation?order=-updatedAt&limit=100" //a code reviewer said the url should be Endpoints.base + "/StudentLocationINVALID?order=-updatedAt&limit=100", but I don't understand, that doesn't seem to work
            case .postStudentLocation: return Endpoints.base + "/StudentLocation"
            case .putStudentLocation: return Endpoints.base + "/StudentLocation/\(Auth.objectId)"
            case .login, .logout: return Endpoints.base + "/session"
            case .getUserData: return Endpoints.base + "/users/" + "\(Auth.userId)"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    //MARK: Auth functions
    
    class func login(udacity: UdacityUserPass, completion: @escaping (Bool, Error?) -> Void) {
        let body = LoginRequest(udacity: udacity)
        taskForPOSTRequest(url: Endpoints.login.url, responseType: AuthSessionResponse.self, body: body) { response, error in
            if let response = response {
                Auth.sessionId = response.session.id
                Auth.userId = response.account.key
                //TODO: Are there other values that need to be set after login? e.g.user
                //TODO: Should user be an int or String?
                //TODO: sessionId will be passed back in the header of the DELETE in order to kill session
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    class func logout(completion: @escaping () -> Void) {
        var request = URLRequest(url: Endpoints.logout.url)
        request.httpMethod = "DELETE"
        let body = LogoutRequest(sessionId: Auth.sessionId)
        request.httpBody = try! JSONEncoder().encode(body)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            //TODO: What should we do if data comes back nil?
            guard let data = data else {
                DispatchQueue.main.async {
                    completion()
                }
                return
            }
            let range = 5..<data.count
            let newData = data.subdata(in: range) /* subset response data! */
            print(String(data: newData, encoding: .utf8)!)
            Auth.sessionId = ""
            completion()
        }
        task.resume()
    }
    
    class func getUserData(completion: @escaping (Bool, Error?) -> Void) {
        taskForGETRequest(url: Endpoints.getUserData.url, responseType: User.self) { response, error in
            if let response = response {
                OTMClient.Auth.firstName = response.firstName
                OTMClient.Auth.lastName = response.lastName
                print("fistname:\(Auth.firstName)" + "lastname:\(Auth.lastName)" )
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    //MARK: Location Functions
    
    //this is to retrieve 100 most recent student locations
    class func getStudentLocation(completion: @escaping ([StudentLocations], Error?) -> Void) {
        taskForGETRequest(url: Endpoints.getStudentLocation.url, responseType: StudentResponse.self) { response, error in
            if let response = response {
                completion(response.results, nil)
            } else {
                completion([], error)
            }
        }
    }
    
    class func postStudentLocation(student: PostStudentRequest, completion: @escaping (Bool, Error?) -> Void) {
        let body = student
        taskForPOSTRequest(url: Endpoints.postStudentLocation.url, responseType: PostStudentResponse.self, body: body) { response, error in
            if let response = response {
                Auth.objectId = response.objectId ?? ""
                completion(true, nil)
            } else {
                completion(false, nil)
            }
        }
    }
    
    class func putStudentLocation(student: PostStudentRequest, completion: @escaping (Bool, Error?) -> Void) {
        let body = student
        taskForPUTRequest(url: Endpoints.putStudentLocation.url, responseType: PutStudentResponse.self, body: body) { response, error in
            if let response = response {
                //TODO: Shouldn't need to set the objectId here, since it was set in initial POST. it should stay preserved
                completion(true, nil)
            } else {
                completion(false, nil)
            }
        }
    }
    
    
    
    //MARK: Flexible functions
    
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionDataTask {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            var newData = data
            if (url == Endpoints.getUserData.url) {
                let range = 5..<data.count
                newData = data.subdata(in: range) /* subset response data! */
            }
            print(String(data: newData, encoding: .utf8)!)
            
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: newData)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(OTMResponse.self, from: newData) as Error
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
            
            var newData = data
            if (url == Endpoints.login.url) {
                let range = 5..<data.count
                newData = data.subdata(in: range) /* subset response data! */
            }
            print("newData" + String(data: newData, encoding: .utf8)!)
            print("data" + String(data: data, encoding: .utf8)!)


            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: newData)
                /* note that 'data' was replaced with 'newData' in the line above to send the proper truncated data to the decoder*/
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(OTMResponse.self, from: newData) as Error
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
    
    class func taskForPUTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.httpBody = try! JSONEncoder().encode(body)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            var newData = data
            if (url == Endpoints.login.url) {
                let range = 5..<data.count
                newData = data.subdata(in: range) /* subset response data! */
            }
            print(String(data: newData, encoding: .utf8)!)


            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: newData)
                /* note that 'data' was replaced with 'newData' in the line above to send the proper truncated data to the decoder*/
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


