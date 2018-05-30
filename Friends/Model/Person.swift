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
    @objc dynamic var prenom = ""
    @objc dynamic var nom = ""
    @objc dynamic var dateNais: Date?
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

    
    convenience init(prenom: String, nom: String) {
        self.init()
        self.prenom = prenom
        self.nom = nom
    }
}

extension Person {
    
    public var fullName: String {
        if nom == "" {
            return prenom
        }
        return "\(prenom) \(nom)"
    }
    
    public func age() -> Int? {
        if let dateNaisDate = dateNais {
            let now = Date()
            let calendar = Calendar.current
            
            let ageComponents = calendar.dateComponents([.year], from: dateNaisDate, to: now)
            return ageComponents.year!
        }
        return nil
    }
}
