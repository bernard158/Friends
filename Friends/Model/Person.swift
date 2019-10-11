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
            nomPrenomUCD = getNomPrenomUCD
        }
    }
    @objc dynamic var nom = "" {
        didSet {
            nomPrenomUCD = getNomPrenomUCD
        }
    }
    @objc dynamic var nomPrenomUCD = ""
    //@objc dynamic var dateNais: Date?
    @objc dynamic var dateNaisStr: String?
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
    let imagesFilenames = List<String>()
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
        //self.dateNais = person.dateNais
        self.dateNaisStr = person.dateNaisStr
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
        let df = DateFormatter()
        df.dateFormat = "yyyy'-'MM'-'dd"
        
        if let str = dateNaisStr, let aDateNais = df.date(from: str) {
            return strDateFormat(aDateNais)
        }
        return ""
    }
    
    //---------------------------------------------------------------------------
    public var strAge: String {
        guard dateNaisStr != nil else { return "" }
        var str = String(age()!)
        if age()! <= 1 {
            str += " an"
        } else {
            str += " ans"
        }
        return str
    }
    
    //---------------------------------------------------------------------------
    public var getNomPrenomUCD: String {
        return "\(nom) \(prenom)".uppercased().folding(options: .diacriticInsensitive, locale: .current)
    }
    
    //---------------------------------------------------------------------------
    public func setDateNais(year: Int, month: Int, day: Int) {
        let dateComponents = DateComponents(calendar: nil, timeZone: nil, era: nil, year: year, month: month, day: day, hour: nil, minute: nil, second: nil, nanosecond: nil, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil)
        dateNaisStr = dateComponents.stringYMD()
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
    public func getDate() -> Date? {
        let df = DateFormatter()
        df.dateFormat = "yyyy'-'MM'-'dd"
        
        if let str = dateNaisStr, let aDateNais = df.date(from: str) {
            return aDateNais
        }
        return nil
    }
    
    //---------------------------------------------------------------------------
    public func age() -> Int? {
        let df = DateFormatter()
        df.dateFormat = "yyyy'-'MM'-'dd"
        
        if let aDateNais = getDate() {
            let now = Date()
            let calendar = Calendar.current
            
            let ageComponents = calendar.dateComponents([.year], from: aDateNais, to: now)
            return ageComponents.year!
        }
        return nil
    }
    
    //---------------------------------------------------------------------------
    public func save() {
        let realm = RealmDB.getRealm()!
        try! realm.write {
            nomPrenomUCD = getNomPrenomUCD
           // realm.add(self, update: true)
            realm.add(self, update: .all)
        }
    }
    
    //---------------------------------------------------------------------------
    static func == (lhs: Person, rhs: Person) -> Bool {
        return lhs.id == rhs.id
    }
    
    //---------------------------------------------------------------------------
    func attrStrGroupe(_ aGroup: [Person], attributes: [NSAttributedString.Key: Any]) -> NSAttributedString {
        //Cette fonction retourne une chaîne sous la forme "Clarisse, Denis et Nathalie Rollier-Sigallet"
        let strRetour = NSMutableAttributedString(string: "")
        let maxIndexGroup = aGroup.count - 1
        
        for index in 0...maxIndexGroup {
            let aPerson1 = aGroup[index]
            if (index + 2) <= maxIndexGroup
            { //2 positions après, c'est toujours le même nom
                let aPerson3 = aGroup[index + 2]
                if aPerson1.nom == aPerson3.nom
                {
                    strRetour.append(NSAttributedString(string: aPerson1.prenom, attributes: attributes))
                    strRetour.append(NSAttributedString(string: ", "))
                }
                else if (index + 1) <= maxIndexGroup
                {  //le suivant, c'est toujours le même nom
                    let aPerson2 = aGroup[index + 1]
                    if aPerson1.nom == aPerson2.nom {
                        strRetour.append(NSAttributedString(string: aPerson1.prenom, attributes: attributes))
                        strRetour.append(NSAttributedString(string: " et "))
                    }
                    else
                    {    //il n'y a pas de suivant ou le suivant n'a pas le même nom
                        strRetour.append(NSAttributedString(string: aPerson1.fullName, attributes: attributes))
                        if index < maxIndexGroup {
                            strRetour.append(NSAttributedString(string: ", "))
                        }
                    }
                }
            }
            else if (index + 1) <= maxIndexGroup
            {  //le suivant, c'est toujours le même nom
                let aPerson2 = aGroup[index + 1]
                if aPerson1.nom == aPerson2.nom {
                    strRetour.append(NSAttributedString(string: aPerson1.prenom, attributes: attributes))
                    strRetour.append(NSAttributedString(string: " et "))
                }
                else
                {    //il n'y a pas de suivant ou le suivant n'a pas le même nom
                    strRetour.append(NSAttributedString(string: aPerson1.fullName, attributes: attributes))
                    if index < maxIndexGroup {
                        strRetour.append(NSAttributedString(string: ", "))
                    }
                }
            }
            else
            {    //il n'y a pas de suivant ou le suivant n'a pas le même nom
                strRetour.append(NSAttributedString(string: aPerson1.fullName, attributes: attributes))
                if index < maxIndexGroup {
                    strRetour.append(NSAttributedString(string: ", "))
                }
            }
        }
        
        return strRetour
    }
    
    //---------------------------------------------------------------------------
    public func cadeauxRecusSortedByGroupesDonateurs(color: UIColor) -> NSAttributedString {
        let realm = RealmDB.getRealm()!
        
        let strRetour = NSMutableAttributedString(string: "")
        let donateurNonConnu = [Person(prenom: "", nom: "?")]
        
        //Liste des groupes donateurs
        var lesGroupes = [[Person]]()
        
        for gift in cadeauxRecus {
            if gift.donateurs .isEmpty {
                //cadeau sans donateur
                if !lesGroupes.contains(donateurNonConnu) {
                    lesGroupes.append(donateurNonConnu)
                }
                
            } else {
                var aGroup = [Person]()
                for aDonateur in gift.donateurs {
                    aGroup.append(aDonateur)
                }
                aGroup.sort {
                    ($0.nom + $0.prenom) < ($1.nom + $1.prenom)
                }
                if !lesGroupes.contains(aGroup) {
                    lesGroupes.append(aGroup)
                }
            }
        }
        
        for aGroup in lesGroupes {
            //Mettre le donateur en couleur
            let attrs: [NSAttributedString.Key: Any] = [.font: UIFont(name: "AvenirNext-DemiBold", size: 14)!, NSAttributedString.Key.foregroundColor: color]
            let attStrDonateur = attrStrGroupe(aGroup, attributes: attrs)
            
            strRetour.append(NSAttributedString(string: "• de "))
            strRetour.append(attStrDonateur)
            strRetour.append(NSAttributedString(string: " : "))
            // récupérer les cadeaux du donateur concerné
            var cadeaux = realm.objects(Gift.self).filter("ANY donateurs == %@ AND ANY beneficiaires == %@", aGroup.first!, self).sorted(byKeyPath: "dateStr", ascending: false)
            
            // l'opérateur d'agrégation ALL n'existe pas dans realm... il faut faire le boulot à la main
            var lesCadeaux = [Gift]()
            for aCadeau in cadeaux {
                var aCadeauOK = true
                for aPerson in aGroup {
                    if aCadeau.donateurs.count != aGroup.count {
                        aCadeauOK = false
                    } else if !aCadeau.donateurs.contains(aPerson) {
                        //le cadeau ne correspond pas à ce groupe
                        aCadeauOK = false
                    }
                }
                if aCadeauOK {
                    lesCadeaux.append(aCadeau)
                }
            }
            
            
            if lesCadeaux.isEmpty {
                //on a un cadeau sans bénéficiaire connu
                cadeaux = realm.objects(Gift.self).filter("ANY donateurs.@count == %d AND ANY beneficiaires == %@", 0, self).sorted(byKeyPath: "dateStr", ascending: false)
                for aCadeau in cadeaux {
                    lesCadeaux.append(aCadeau)
                }
                
            }
            
            let strCadeaux = attrStrCadeaux(lesCadeaux: lesCadeaux)
            strRetour.append(strCadeaux)
        }
        return strRetour
        
    }
    
    //---------------------------------------------------------------------------
    public func cadeauxOffertsSortedByGroupesBeneficiaires(color: UIColor) -> NSAttributedString {
        let realm = RealmDB.getRealm()!
        
        let strRetour = NSMutableAttributedString(string: "")
        let beneficiaireNonConnu = [Person(prenom: "", nom: "?")]
        
        //Liste des groupes beneficiaires
        var lesGroupes = [[Person]]()
        
        for gift in cadeauxOfferts {
            if gift.beneficiaires.isEmpty {
                //cadeau sans beneficiaires
                if !lesGroupes.contains(beneficiaireNonConnu) {
                    lesGroupes.append(beneficiaireNonConnu)
                }
                
            } else {
                var aGroup = [Person]()
                for aBeneficiaire in gift.beneficiaires {
                    aGroup.append(aBeneficiaire)
                }
                aGroup.sort {
                    ($0.nom + $0.prenom) < ($1.nom + $1.prenom)
                }
                if !lesGroupes.contains(aGroup) {
                    lesGroupes.append(aGroup)
                }
            }
        }
        
        for aGroup in lesGroupes {
            /* print("----------------------")
             for aPerson in aGroup {
             print(aPerson.fullName)
             }*/
            //Mettre le beneficiaire en couleur
            let attrs: [NSAttributedString.Key: Any] = [.font: UIFont(name: "AvenirNext-DemiBold", size: 14)!, NSAttributedString.Key.foregroundColor: color]
            let attStrBeneficaires = attrStrGroupe(aGroup, attributes: attrs)
            
            strRetour.append(NSAttributedString(string: "• à "))
            strRetour.append(attStrBeneficaires)
            strRetour.append(NSAttributedString(string: " : "))
            // récupérer les cadeaux des beneficiaire concernés
            var cadeaux = realm.objects(Gift.self).filter("ANY donateurs == %@ AND ANY beneficiaires IN %@", self, aGroup).sorted(byKeyPath: "dateStr", ascending: false)
            
            // l'opérateur d'agrégation ALL n'existe pas dans realm... il faut faire le boulot à la main
            var lesCadeaux = [Gift]()
            for aCadeau in cadeaux {
                var aCadeauOK = true
                for aPerson in aGroup {
                    if aCadeau.beneficiaires.count != aGroup.count {
                        aCadeauOK = false
                    } else if !aCadeau.beneficiaires.contains(aPerson) {
                        //le cadeau ne correspond pas à ce groupe
                        aCadeauOK = false
                    }
                }
                if aCadeauOK {
                    lesCadeaux.append(aCadeau)
                }
            }
            
            
            if lesCadeaux.isEmpty {
                //on a un cadeau sans bénéficiaire connu
                cadeaux = realm.objects(Gift.self).filter("ANY beneficiaires.@count == %d AND ANY donateurs == %@", 0, self).sorted(byKeyPath: "dateStr", ascending: false)
                for aCadeau in cadeaux {
                    lesCadeaux.append(aCadeau)
                }
                
            }
            
            let strCadeaux = attrStrCadeaux(lesCadeaux: lesCadeaux)
            strRetour.append(strCadeaux)
        }
        return strRetour
    }
    
    //---------------------------------------------------------------------------
    public func ideesCadeaux() -> NSAttributedString {
        
        let strRetour = NSMutableAttributedString(string: "")
        let cadeaux = cadeauxIdees.sorted(byKeyPath: "dateStr", ascending: false)
        
        //On tranforme en tableau de cadeaux pour appel fontion attrStrCadeaux
        var lesCadeaux = [Gift]()
        for aCadeau in cadeaux {
            lesCadeaux.append(aCadeau)
        }
        let strCadeaux = attrStrCadeaux(lesCadeaux: lesCadeaux)
        strRetour.append(strCadeaux)
        
        return strRetour
    }
    
    //---------------------------------------------------------------------------
    // retourne la liste des cadeaux avec leur image si il y a lieu
    private func attrStrCadeaux(lesCadeaux: [Gift]) -> NSAttributedString {
        
        let strRetour = NSMutableAttributedString(string: "")
        
        for aCadeau in lesCadeaux {
            /*if let imageData = aCadeau.imageData { // si on a une image du cadeau, on l'affiche en tout petit
             let imageAttachment = NSTextAttachment()
             imageAttachment.image = resizeImage(image: UIImage(data: imageData)!, targetSize: CGSize(width: 50, height: 36))
             
             if let image = imageAttachment.image{
             let font = UIFont.systemFont(ofSize: 16) //set accordingly to your font
             let y = (font.ascender-font.capHeight/2-image.size.height/2)
             imageAttachment.bounds = CGRect(x: 0, y: y, width: image.size.width, height: image.size.height).integral
             }
             
             // wrap the attachment in its own attributed string so we can append it
             let imageString = NSAttributedString(attachment: imageAttachment)
             strRetour.append(imageString)
             strRetour.append(NSAttributedString(string: "\u{a0}")) // espace insécable - non breaking space
             }*/
            
            strRetour.append(NSAttributedString(string: aCadeau.nom))
            if aCadeau == lesCadeaux.last {
                strRetour.append(NSAttributedString(string: "\n"))
            } else {
                strRetour.append(NSAttributedString(string: ", "))
            }
        }
        return strRetour
    }
}

