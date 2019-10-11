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
    @objc dynamic var nom = "" {
        didSet {
            // Keep the case-free property in sync
            nomUCD = getNomUCD
        }
    }
    @objc dynamic var nomUCD = ""
    //@objc dynamic var date: Date?
    @objc dynamic var dateStr: String?
    @objc dynamic var note = ""
    @objc dynamic var prix: Double = 0.0
    @objc dynamic var magasin = ""
    @objc dynamic var url = ""
    @objc dynamic var imageData: Data?
    @objc dynamic var id = UUID().uuidString
    
    let beneficiaires = LinkingObjects(fromType: Person.self, property: "cadeauxRecus")
    let donateurs = LinkingObjects(fromType: Person.self, property: "cadeauxOfferts")
    let personnesIdee = LinkingObjects(fromType: Person.self, property: "cadeauxIdees")
    
    //---------------------------------------------------------------------------
    public var getNomUCD: String {
        return nom.uppercased().folding(options: .diacriticInsensitive, locale: .current)
    }
    
    //---------------------------------------------------------------------------
  convenience init(_ nom: String) {
        self.init()
        self.nom = nom
    }
    
    // Contructeur de copie pour déconnecter de Realm
    //---------------------------------------------------------------------------
    convenience init(_ gift: Gift) {
        self.init()
        self.nom = gift.nom
        self.dateStr = gift.dateStr
        self.note = gift.note
        self.prix = gift.prix
        self.magasin = gift.magasin
        self.url = gift.url
        self.imageData = gift.imageData
        self.id = gift.id
        //self.beneficiaires = gift.beneficiaires
        //self.donateurs = gift.donateurs
        //self.personnesIdee = gift.personnesIdee
    }
    
    //---------------------------------------------------------------------------
   override static func primaryKey() -> String? {
        return "id"
    }

}

extension Gift {
    public var giftFrom: String {
        if donateurs.count == 0 {
            return nom
        }
        var strRetour = ""
        let deLaPart = "de la part de"
        
        for person in donateurs {
            strRetour += person.fullName
            if person != donateurs.last {
                strRetour += ", "
            }
        }
        return "\(nom): \(deLaPart) \(strRetour)"
    }
    
    public var giftFor: String {
        if beneficiaires.count == 0 {
            return nom
        }
        var strRetour = ""
        let pour = "à"
        
        for person in beneficiaires {
            strRetour += person.fullName
            if person != beneficiaires.last {
                strRetour += ", "
            }
        }
        return "\(nom): \(pour) \(strRetour)"
    }
    
    public var strDateCadeau: String {
        return strDateFormat(getDate())
    }

    //---------------------------------------------------------------------------
    public func getDate() -> Date? {
        let df = DateFormatter()
        df.dateFormat = "yyyy'-'MM'-'dd"
        
        if let str = dateStr, let aDate = df.date(from: str) {
            return aDate
        }
        return nil
    }
    
    //---------------------------------------------------------------------------
    public func setDate(year: Int, month: Int, day: Int) {
        let dateComponents = DateComponents(calendar: nil, timeZone: nil, era: nil, year: year, month: month, day: day, hour: nil, minute: nil, second: nil, nanosecond: nil, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil)
        dateStr = dateComponents.stringYMD()
    }
    
    //---------------------------------------------------------------------------
   public func save() {
        let realm = RealmDB.getRealm()!
        try! realm.write {
            nomUCD = getNomUCD
            //realm.add(self, update: true)
            realm.add(self, update: .all)
        }
    }
    
    //---------------------------------------------------------------------------


}
