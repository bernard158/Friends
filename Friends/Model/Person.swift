//
//  Person.swift
//  Friends
//
//  Created by bernard on 24/05/2018.
//  Copyright © 2018 bernard. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

//---------------------------------------------------------------------------
class Person: Object {
    @objc dynamic var prenom = "" {
        didSet {
            // Keep the case-free property in sync
            nomPrenomUCD = getNomPrenomUCD
        }
    }
    @objc dynamic var nom = "" {
        didSet {
            // Keep the case-free property in sync
            nomPrenomUCD = getNomPrenomUCD
        }
    }
    @objc dynamic var nomPrenomUCD = ""
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
    
    //non enregistrable
    public var checked = false

    //---------------------------------------------------------------------------
    convenience init(prenom: String, nom: String) {
        self.init()
        self.prenom = prenom
        self.nom = nom
    }
    
    // Contructeur de copie pour déconnecter de Realm
    //---------------------------------------------------------------------------
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
    
    //---------------------------------------------------------------------------
    override static func primaryKey() -> String? {
        return "id"
    }
}

extension Person {
    
    //---------------------------------------------------------------------------
    public var fullName: String {
        if nom == "" {
            return prenom
        }
        return "\(prenom) \(nom)"
    }
    
    //---------------------------------------------------------------------------
    public var strDateNais: String {
        return strDateFormat(dateNais)
    }
    
    //---------------------------------------------------------------------------
    public var strAge: String {
        guard dateNais != nil else { return "" }
        return String(age()!)
    }
    
    //---------------------------------------------------------------------------
    public var getNomPrenomUCD: String {
        return "\(nom) \(prenom)".uppercased().folding(options: .diacriticInsensitive, locale: .current)
    }
    
    //---------------------------------------------------------------------------
    public func cadeauxOffertsAppendGift(_ gift: Gift) {
        //le cadeau est-il déjà dans les cadeaux offerts ?
        for cadeau in cadeauxOfferts {
            if cadeau == gift { return }
        }
        cadeauxOfferts.append(gift)
    }
    
    //---------------------------------------------------------------------------
    public func cadeauxRecusAppendGift(_ gift: Gift) {
        //le cadeau est-il déjà dans les cadeaux recus ?
        for cadeau in cadeauxRecus {
            if cadeau == gift { return }
        }
        cadeauxRecus.append(gift)
    }
    
    //---------------------------------------------------------------------------
    public func cadeauxIdeesAppendGift(_ gift: Gift) {
        //le cadeau est-il déjà dans les cadeaux idées ?
        for cadeau in cadeauxIdees {
            if cadeau == gift { return }
        }
        cadeauxIdees.append(gift)
    }
    
    //---------------------------------------------------------------------------
  public func age() -> Int? {
        if let dateNaisDate = dateNais {
            let now = Date()
            let calendar = Calendar.current
            
            let ageComponents = calendar.dateComponents([.year], from: dateNaisDate, to: now)
            return ageComponents.year!
        }
        return nil
    }
    
    //---------------------------------------------------------------------------
    public func save() {
        let realm = RealmDB.getRealm()!
        try! realm.write {
            realm.add(self, update: true)
        }
    }
    
    //---------------------------------------------------------------------------
    static func == (lhs: Person, rhs: Person) -> Bool {
        return lhs.id == rhs.id
    }
    
    //---------------------------------------------------------------------------
    
    
    //---------------------------------------------------------------------------
    public func cadeauxRecusSortedByDonateur(color: UIColor) -> NSAttributedString {
        let realm = RealmDB.getRealm()!

        let strRetour = NSMutableAttributedString(string: "")
        let donateurNonConnu = Person(prenom: "", nom: "?")
        
        //Liste des donateurs uniques
        var lesDonateurs = [Person]()
        for gift in cadeauxRecus {
            if gift.donateurs .isEmpty {
                //cadeau sans donateur
                if !lesDonateurs.contains(donateurNonConnu) {
                    lesDonateurs.append(donateurNonConnu)
                }

            } else {
                for aDonateur in gift.donateurs {
                    if !lesDonateurs.contains(aDonateur) {
                        lesDonateurs.append(aDonateur)
                    }
                }
            }
        }
        //on trie les donnateurs alpha
        lesDonateurs.sort {
            ($0.nom + $0.prenom) < ($1.nom + $1.prenom)
        }
        
        for aDonateur in lesDonateurs {
            //Mettre le donateur en couleur
           let attrs: [NSAttributedStringKey: Any] = [.font: UIFont(name: "AvenirNext-DemiBold", size: 14)!, NSAttributedStringKey.foregroundColor: color]
            let attStrDonateur = NSAttributedString(string: aDonateur.fullName, attributes: attrs)

            strRetour.append(NSAttributedString(string: "• de "))
            strRetour.append(attStrDonateur)
            strRetour.append(NSAttributedString(string: " : "))
           // récupérer les cadeaux du donateur concerné
            var cadeaux = realm.objects(Gift.self).filter("ANY donateurs == %@ AND ANY beneficiaires == %@", aDonateur, self).sorted(byKeyPath: "date", ascending: false)
            if cadeaux.isEmpty {
                //on a un cadeau sans donateur connu
                cadeaux = realm.objects(Gift.self).filter("ANY donateurs.@count == %d AND ANY beneficiaires == %@", 0, self).sorted(byKeyPath: "date", ascending: false)
           }
            
            for aCadeau in cadeaux {
                strRetour.append(NSAttributedString(string: aCadeau.nom))
                if aCadeau == cadeaux.last {
                    strRetour.append(NSAttributedString(string: "\n"))
                } else {
                    strRetour.append(NSAttributedString(string: ", "))
                }
            }
        }
        return strRetour
    }
    
    //---------------------------------------------------------------------------
    public func cadeauxOffertsSortedByBeneficiaire(color: UIColor) -> NSAttributedString {
        let realm = RealmDB.getRealm()!

        let strRetour = NSMutableAttributedString(string: "")
        let beneficiaireNonConnu = Person(prenom: "", nom: "?")

        //Liste des bénéficiaires uniques
        var lesBeneficiaires = [Person]()
        for gift in cadeauxOfferts {
            if gift.beneficiaires .isEmpty {
                //cadeau sans bénéficiaire
                if !lesBeneficiaires.contains(beneficiaireNonConnu) {
                    lesBeneficiaires.append(beneficiaireNonConnu)
                }
            } else {
                for aBeneficiaire in gift.beneficiaires {
                    if !lesBeneficiaires.contains(aBeneficiaire) {
                        lesBeneficiaires.append(aBeneficiaire)
                    }
                }
            }
        }
        //on trie les bénéficiaires alpha
        lesBeneficiaires.sort {
            ($0.nom + $0.prenom) < ($1.nom + $1.prenom)
        }
        
        for aBeneficiaire in lesBeneficiaires {
            let attrs: [NSAttributedStringKey: Any] = [.font: UIFont(name: "AvenirNext-DemiBold", size: 14)!, NSAttributedStringKey.foregroundColor: color]
            let attStrBeneficiaire = NSAttributedString(string: aBeneficiaire.fullName, attributes: attrs)

            strRetour.append(NSAttributedString(string: "• à "))
            strRetour.append(attStrBeneficiaire)
            strRetour.append(NSAttributedString(string: " : "))
            // récupérer les cadeaux du donateur concerné
            var cadeaux = realm.objects(Gift.self).filter("ANY donateurs == %@ AND ANY beneficiaires == %@", self, aBeneficiaire).sorted(byKeyPath: "date", ascending: false)
            if cadeaux.isEmpty {
                //on a un cadeau sans bénéficiaire connu
                cadeaux = realm.objects(Gift.self).filter("ANY beneficiaires.@count == %d AND ANY donateurs == %@", 0, self).sorted(byKeyPath: "date", ascending: false)
            }

            for aCadeau in cadeaux {
                strRetour.append(NSAttributedString(string: aCadeau.nom))
                if aCadeau == cadeaux.last {
                    strRetour.append(NSAttributedString(string: "\n"))
                } else {
                    strRetour.append(NSAttributedString(string: ", "))
                }
            }
        }
        return strRetour
    }

    //---------------------------------------------------------------------------
    public func ideesCadeaux() -> String {
        let sortedCadeaux = cadeauxIdees.sorted(byKeyPath: "date", ascending: false)
        
        var strRetour = ""
        
        for aCadeau in sortedCadeaux {
            strRetour += aCadeau.nom
            if aCadeau == sortedCadeaux.last {
                strRetour += ""
            } else {
                strRetour += ", "
            }
        }
        return strRetour
    }
}

