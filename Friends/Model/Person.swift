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
    @objc dynamic var emails = ""
    @objc dynamic var phones = ""
    @objc dynamic var addresses = ""
    @objc dynamic var socialProfiles = ""
    @objc dynamic var urls = ""
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
    
    // Contructeur de copie pour déconnecter de Realm
    convenience init(person: Person) {
        self.init()
        self.prenom = person.prenom
        self.nom = person.nom
        self.dateNais = person.dateNais
        self.emails = person.emails
        self.phones = person.phones
        self.addresses = person.addresses
        self.socialProfiles = person.socialProfiles
        self.urls = person.urls
        self.cadeauxRecus = person.cadeauxRecus
        self.cadeauxOfferts = person.cadeauxOfferts
        self.cadeauxIdees = person.cadeauxIdees
        self.likeYes = person.likeYes
        self.likeNo = person.likeNo
        self.note = person.note
        self.imageData = person.imageData
        self.id = person.id
        self.originalID = person.originalID
    }
    
    override static func primaryKey() -> String? {
        return "id"
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
    public func save() {
        /*let realm = try! Realm()
        try! realm.write {
            realm.add(self, update: true)
        }*/
        let realm = try! Realm()
        realm.beginWrite()
        realm.add(self, update: true)
        try! realm.commitWrite()

        
    }
}


