//
//  StudentsData.swift
//  PinSample
//
//  Created by Josh Gutierrez on 10/25/22.
//  Copyright © 2022 Udacity. All rights reserved.
//

import Foundation

class StudentsData: NSObject {
    
    var students = [StudentLocations]()

    class func sharedInstance() -> StudentsData {
        struct Singleton {
            static var sharedInstance = StudentsData()
        }
        return Singleton.sharedInstance
    }
}
