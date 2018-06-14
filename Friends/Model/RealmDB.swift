//
//  RealmDB.swift
//  Friends
//
//  Created by bernard on 11/06/2018.
//  Copyright © 2018 bernard. All rights reserved.
//

import Foundation
import RealmSwift



func migrationBlock(migration: Migration, oldVersion: UInt64) {
    if oldVersion < 2 {
        migrateFrom1To2(migration)
    }
}

func migrateFrom1To2(_ migration: Migration) {
    print("Migration from 1 to version 2")
    
    //Boucle sur les personnes
    migration.enumerateObjects(ofType:
    String(describing: Person.self)) { from, to in
        guard let from = from,
            let to = to
            else { return }
        
        //supprimer les espaces au début et à la fin des noms et prénoms
        var nom = from["nom"] as! String
        nom = nom.trimmingCharacters(in: .whitespacesAndNewlines)
        to["nom"] = nom
        
        var prenom = from["prenom"] as! String
        prenom = prenom.trimmingCharacters(in: .whitespacesAndNewlines)
        to["prenom"] = prenom
        
        //remplir le champ UCD
        to["nomPrenomUCD"] = "\(nom) \(prenom)".uppercased().folding(options: .diacriticInsensitive, locale: .current)
    }
    
    //Boucle sur les cadeaux
    migration.enumerateObjects(ofType:
    String(describing: Gift.self)) { from, to in
        guard let from = from,
            let to = to
            else { return }
        
        //supprimer les espaces au début et à la fin du nom
        var nom = from["nom"] as! String
        nom = nom.trimmingCharacters(in: .whitespacesAndNewlines)
        to["nom"] = nom
        
        //remplir le champ UCD
        to["nomUCD"] = nom.uppercased().folding(options: .diacriticInsensitive, locale: .current)
    }
    
}
//---------------------------------------


class RealmDB {
    
    static func getRealm() -> Realm? {
        /*
            let conf = Realm.Configuration(
            schemaVersion: 1,
            deleteRealmIfMigrationNeeded: true,
            objectTypes: [Person.self, Gift.self])
        */
        let conf = Realm.Configuration(
            schemaVersion: 2,
            migrationBlock: migrationBlock,
            objectTypes: [Person.self, Gift.self])

        return try! Realm(configuration: conf)

    }
    

}
