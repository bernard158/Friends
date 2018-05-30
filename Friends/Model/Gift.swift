//
//  Gift.swift
//  Friends
//
//  Created by bernard on 28/05/2018.
//  Copyright © 2018 bernard. All rights reserved.
//

import Foundation
import RealmSwift

class Gift: Object {
    @objc dynamic var name = ""
    @objc dynamic var date: Date?
    @objc dynamic var note = ""
    @objc dynamic var imageData: Data?
    @objc dynamic var id = UUID().uuidString
    
    let beneficiaires = LinkingObjects(fromType: Person.self, property: "cadeauxRecus")
    let donateurs = LinkingObjects(fromType: Person.self, property: "cadeauxOfferts")
    let personnesIdee = LinkingObjects(fromType: Person.self, property: "cadeauxIdees")
    
    convenience init(_ name: String) {
        self.init()
        self.name = name
    }
}

extension Gift {
    public var giftFrom: String {
        if donateurs.count == 0 {
            return name
        }
        var strRetour = ""
        
        for person in donateurs {
            strRetour += person.fullName
            if person != donateurs.last {
                strRetour += ", "
            }
        }
        return "\(name): from \(strRetour)"
    }
    
    public var giftFor: String {
        if beneficiaires.count == 0 {
            return name
        }
        var strRetour = ""
        
        for person in beneficiaires {
            strRetour += person.fullName
            if person != beneficiaires.last {
                strRetour += ", "
            }
        }
        return "\(name): for \(strRetour)"
    }
}
