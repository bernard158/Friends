//
//  RealmDB.swift
//  Friends
//
//  Created by bernard on 11/06/2018.
//  Copyright © 2018 bernard. All rights reserved.
//

import Foundation
import RealmSwift



//---------------------------------------------------------------------------
func migrationBlock(migration: Migration, oldVersion: UInt64) {
    if oldVersion < 2 {
        migrateFrom1To2(migration)
    }
    if oldVersion < 3 {
        migrateFrom2To3(migration)
    }
    if oldVersion < 4 {
        migrateFrom3To4(migration)
    }
}

//---------------------------------------------------------------------------
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

//---------------------------------------------------------------------------
func migrateFrom2To3(_ migration: Migration) {
    print("Migration from 2 to version 3")
    
    //Boucle sur les personnes
    migration.enumerateObjects(ofType:
    String(describing: Person.self)) { from, to in
        guard let from = from,
            let to = to
            else { return }
        
        // recupérer les dates
        if var date = from["dateNais"] as? Date {
            date += 7200 // correction heure été ??
            let dc = date.componentsDMY()
            to["dateNaisStr"] = dc.stringYMD()
        }
        
        
    }
    
    //Boucle sur les cadeaux
    migration.enumerateObjects(ofType:
    String(describing: Gift.self)) { from, to in
        guard let from = from,
            let to = to
            else { return }
        
        // recupérer les dates
        if let date = from["date"] as? Date {
            let dc = date.componentsDMY()
            to["dateStr"] = dc.stringYMD()
        }
    }
}

//---------------------------------------------------------------------------
func migrateFrom3To4(_ migration: Migration) {
    print("Migration from 3 to version 4")
    
    //Boucle sur les personnes
    migration.enumerateObjects(ofType:
    String(describing: Person.self)) { from, to in
        guard let _ = from,
            let _ = to
            else { return }
        
        // recupérer les dates
      /*  if from["imageData"] as? Data != nil {
            //on crée une image sur disque et on affecte le nom à imagesFilenames
            
            let uuid = UUID().uuidString
            
            //let imagesList = to["imagesFilenames"] as! List<String>

            let imagesList = to["imagesFilenames"] as! List<MigrationObject>

            let imageName = migration.create("String", value: uuid)

            imagesList.append(imageName)
        }
        */
        
    }
    
    //Boucle sur les cadeaux
    migration.enumerateObjects(ofType:
    String(describing: Gift.self)) { from, to in
        guard let _ = from,
            let _ = to
            else { return }
        
        // recupérer les dates
       /* if let date = from["date"] as? Date {
            let dc = date.componentsDMY()
            to["dateStr"] = dc.stringYMD()
        }*/
    }
}

//---------------------------------------------------------------------------
class RealmDB {
    
    static func getRealm() -> Realm? {
        /*
         let conf = Realm.Configuration(
         schemaVersion: 1,
         deleteRealmIfMigrationNeeded: true,
         objectTypes: [Person.self, Gift.self])
         */
        let conf = Realm.Configuration(
            schemaVersion: 4,
            migrationBlock: migrationBlock,
            shouldCompactOnLaunch: { totalBytes, usedBytes in
                // totalBytes refers to the size of the file on disk in bytes (data + free space)
                // usedBytes refers to the number of bytes used by data in the file
                
                // Compact if the file is over 100MB in size and less than 50% 'used'
                let oneHundredMB = 100 * 1024 * 1024
                return (totalBytes > oneHundredMB) && (Double(usedBytes) / Double(totalBytes)) < 0.8
        },
            objectTypes: [Person.self, Gift.self]
        )
        
        return try! Realm(configuration: conf)
    }
}
