//
//  RealmDB.swift
//  Friends
//
//  Created by bernard on 11/06/2018.
//  Copyright © 2018 bernard. All rights reserved.
//

import Foundation
import RealmSwift


class RealmDB {
    
    static func getRealm() -> Realm? {
        let conf = Realm.Configuration(
            schemaVersion: 1,
            deleteRealmIfMigrationNeeded: true,
            objectTypes: [Person.self, Gift.self])
        
        return try! Realm(configuration: conf)

    }
}
