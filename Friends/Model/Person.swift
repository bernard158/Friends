//
//  Person.swift
//  Friends
//
//  Created by bernard on 24/05/2018.
//  Copyright © 2018 bernard. All rights reserved.
//

import Foundation
import RealmSwift

class Person: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var originalID = ""
    @objc dynamic var firstName = ""
    @objc dynamic var lastName = ""
    @objc dynamic var born: Date?
    var emails = List<String>()
    var phones = List<String>()
    var addresses = List<String>()
    @objc dynamic var likeYes = ""
    @objc dynamic var likeNo = ""
    @objc dynamic var note = ""
    @objc dynamic var imageData: Data?

    public var fullNameLowercase: String {
        if lastName == "" {
            return firstName.lowercased()
        }
        
        return "\(firstName) \(lastName)".lowercased()
    }

}

extension Person {
    
    public var fullName: String {
        if lastName == "" {
            return firstName
        }
        
        return "\(firstName) \(lastName)"
    }
    
}
