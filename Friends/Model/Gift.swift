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

    let personnesRecu = LinkingObjects(fromType: Person.self, property: "cadeauxRecus")
    let personnesOffert = LinkingObjects(fromType: Person.self, property: "cadeauxOfferts")
    let personnesIdee = LinkingObjects(fromType: Person.self, property: "cadeauxIdees")
    
    convenience init(_ name: String) {
        self.init()
        self.name = name
    }

}
