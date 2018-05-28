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
    @objc dynamic var firstName = ""
    @objc dynamic var lastName = ""
    @objc dynamic var born: Date?
    var emails = List<String>()
    var phones = List<String>()
    var addresses = List<String>()
    var socialProfiles = List<String>()
    var cadeauxRecus = List<Gift>()
    var cadeauxOfferts = List<Gift>()
    var cadeauxIdees = List<Gift>()
    @objc dynamic var likeYes = ""
    @objc dynamic var likeNo = ""
    @objc dynamic var note = ""
    @objc dynamic var imageData: Data?
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var originalID = ""

    
    convenience init(firstName: String, lastName: String) {
        self.init()
        self.firstName = firstName
        self.lastName = lastName
    }
}

extension Person {
    
    public var fullName: String {
        if lastName == "" {
            return firstName
        }
        
        return "\(firstName) \(lastName)"
    }
    
    public func age() -> Int? {
        if let bornDate = born {
            let now = Date()
            let calendar = Calendar.current
            
            let ageComponents = calendar.dateComponents([.year], from: bornDate, to: now)
            return ageComponents.year!
        }
        return nil
    }
}
