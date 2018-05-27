//
//  ImportContacts.swift
//  Friends
//
//  Created by bernard on 24/05/2018.
//  Copyright © 2018 bernard. All rights reserved.
//

import Foundation
import Contacts
import RealmSwift


class ContactIOS {
    var contact = CNContact()
    var isImported = false
    
    //-------------------------------------------------------
    var isAlreadyImported: Bool {
        let realm = try! Realm()
        let persons = realm.objects(Person.self)
            .filter("originalID = %d", contact.identifier)
        return persons.count > 0
    }
    
    //-------------------------------------------------------
    var isValidToImport: Bool {
        return contact.familyName.count > 0
    }
    
    //-------------------------------------------------------
    var lastFirstName: String {
        if contact.givenName == "" {
            return contact.familyName
        }
        
        return "\(contact.familyName) \(contact.givenName)"
    }
    
    //-------------------------------------------------------
    var fullName: String {
        if contact.familyName == "" {
            return contact.givenName
        }
        
        return "\(contact.givenName) \(contact.familyName)"
    }
    
    //-------------------------------------------------------
    //Fonction non utilisée pour le moment
    public func CreateMediasDirectory() -> URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let dataPath = documentsDirectory.appendingPathComponent("Medias")
        
        do {
            try FileManager.default.createDirectory(atPath: dataPath.path, withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError {
            print("Error creating directory: \(error.localizedDescription)")
        }
        return dataPath
    }
    
    //-------------------------------------------------------
    public func adresses() -> String {
        var addresses: [String] = []
        
        //boucle sur les adresses
        for postalAddress in contact.postalAddresses {
            let address = postalAddress.value.street.count > 0 ?"\(postalAddress.value.street) - " : ""
            let city = postalAddress.value.city.count > 0 ?"\(postalAddress.value.city) " : ""
            let state = postalAddress.value.state.count > 0 ?"\(postalAddress.value.state) " : ""
            let postalCode = postalAddress.value.postalCode.count > 0 ?"\(postalAddress.value.postalCode) " : ""
            let country = postalAddress.value.country.count > 0 ?"- \(postalAddress.value.country)" : ""
            
            //supprimer les retours ligne et les doubles espaces
            var strAdresse = address + postalCode + city + state + country
            strAdresse = strAdresse.replacingOccurrences(of: "\n", with: " - ")
            strAdresse = strAdresse.replacingOccurrences(of: "  ", with: " ")
            addresses.append(strAdresse)
        }
        var strRetour = ""
        
        var cpt = 0
        for str in addresses {
            strRetour += str
            cpt += 1
            if cpt <= addresses.count {
                strRetour += "\n"
            }
        }
        if strRetour.count > 0 {
            print(strRetour)
            print("----------------")
        }
        
        return strRetour
    }
    
    //-------------------------------------------------------
    public func addToRealm() {
        
        if isAlreadyImported { return }
        if !isValidToImport { return }
        
        let aPerson = Person()
        
        aPerson.originalID = contact.identifier
        aPerson.firstName = contact.givenName
        aPerson.lastName = contact.familyName
        
        //boucle sur les adresses
        for postalAddress in contact.postalAddresses {
            let address = postalAddress.value.street.count > 0 ?"\(postalAddress.value.street) - " : ""
            let city = postalAddress.value.city.count > 0 ?"\(postalAddress.value.city) " : ""
            let state = postalAddress.value.state.count > 0 ?"\(postalAddress.value.state) " : ""
            let postalCode = postalAddress.value.postalCode.count > 0 ?"\(postalAddress.value.postalCode) " : ""
            let country = postalAddress.value.country.count > 0 ?"- \(postalAddress.value.country)" : ""
            
            //supprimer les retours ligne et les doubles espaces
            var strAdresse = address + postalCode + city + state + country
            strAdresse = strAdresse.replacingOccurrences(of: "\n", with: " - ")
            strAdresse = strAdresse.replacingOccurrences(of: "  ", with: " ")
            aPerson.addresses.append(strAdresse)
            //print(strAdresse)
        }
        
        //boucle sur les téléphones
        for phoneNumber in contact.phoneNumbers {
            var strPhone = ""
            
            switch phoneNumber.label {
            case CNLabelHome:
                strPhone = "Home"
            case CNLabelPhoneNumberiPhone:
                strPhone = "iPhone"
            case CNLabelOther:
                strPhone = "Other"
            case CNLabelWork:
                strPhone = "Work"
            case CNLabelPhoneNumberMain:
                strPhone = "Main Phone"
            case CNLabelPhoneNumberMobile:
                strPhone = "Mobile"
            case CNLabelPhoneNumberPager:
                strPhone = "Pager"
            case CNLabelPhoneNumberHomeFax:
                strPhone = "Home Fax"
            case CNLabelPhoneNumberWorkFax:
                strPhone = "Work Fax"
            case CNLabelPhoneNumberOtherFax:
                strPhone = "Other Fax"
            default:
                strPhone = "Other"
                break
            }
            strPhone += ": "
            
            let aPhoneNumber = phoneNumber.value.stringValue
            //supprimer les retours ligne et les doubles espaces
            strPhone += aPhoneNumber
            strPhone = strPhone.replacingOccurrences(of: "\n", with: " - ")
            strPhone = strPhone.replacingOccurrences(of: "  ", with: " ")
            aPerson.phones.append(strPhone)
            //print(strPhone)
        }
        
        //boucle sur les emails
        for email in contact.emailAddresses {
            var strEmail = ""
            
            switch email.label {
            case CNLabelHome:
                strEmail = "Home"
            case CNLabelWork:
                strEmail = "Work"
            case CNLabelOther:
                strEmail = "Other"
            default:
                strEmail = "Other"
                break
            }
            strEmail += ": "
            
            let anEmail = email.value as String
            //supprimer les retours ligne et les doubles espaces
            strEmail += anEmail
            strEmail = strEmail.replacingOccurrences(of: "\n", with: " - ")
            strEmail = strEmail.replacingOccurrences(of: "  ", with: " ")
            aPerson.emails.append(strEmail)
            //print(strEmail)
        }
        
        //boucle sur les réseaux sociaux
        for socialProfile in contact.socialProfiles {
            var strSocialProfile = ""
            
            switch socialProfile.value.service {
            case CNSocialProfileServiceFlickr:
                strSocialProfile = "Flickr"
            case CNSocialProfileServiceTwitter:
                strSocialProfile = "Twitter"
            case CNSocialProfileServiceFacebook:
                strSocialProfile = "Facebook"
            case CNSocialProfileServiceLinkedIn:
                strSocialProfile = "LinkedIn"
            case CNSocialProfileServiceYelp:
                strSocialProfile = "Yelp"
            case CNSocialProfileServiceMySpace:
                strSocialProfile = "MySpace"
            default:
                strSocialProfile = "Other"
                break
            }
            strSocialProfile += ": "
            
            let aSocialProfile = socialProfile.value.urlString as String
            //supprimer les retours ligne et les doubles espaces
            strSocialProfile += aSocialProfile
            strSocialProfile = strSocialProfile.replacingOccurrences(of: "\n", with: " - ")
            strSocialProfile = strSocialProfile.replacingOccurrences(of: "  ", with: " ")
            aPerson.socialProfiles.append(strSocialProfile)
            //print(strSocialProfile)
        }
        
        //Date de naissance
        let calendar = NSCalendar.current
        if let birthday = contact.birthday, let date = calendar.date(from: birthday) {
            aPerson.born = date
        }
        
        //NOTE
        aPerson.note = contact.note
        
        /* if aPerson.note.count > 0 {
         print(aPerson.note)
         print("------")
         }*/
        
        //image
        if let imageData = contact.imageData {
            aPerson.imageData = imageData
            //let image = UIImage(data: imageData)
            print(imageData)
            //print(image)
            
            
        }
        let realm = try! Realm()
        try! realm.write {
            realm.add(aPerson)
        }
    }
}

class ImportContacts {
    
    public static func loadCNContacts() -> [ContactIOS] {
        var results: [ContactIOS] = []
        
        let fetchRequest = CNContactFetchRequest(keysToFetch: [CNContactIdentifierKey as CNKeyDescriptor,
                                                               CNContactGivenNameKey as CNKeyDescriptor,
                                                               CNContactMiddleNameKey as CNKeyDescriptor,
                                                               CNContactEmailAddressesKey as CNKeyDescriptor,
                                                               CNContactFamilyNameKey as CNKeyDescriptor,
                                                               CNContactPhoneNumbersKey as CNKeyDescriptor,
                                                               CNContactImageDataKey as CNKeyDescriptor,
                                                               CNContactBirthdayKey as CNKeyDescriptor,
                                                               CNContactSocialProfilesKey as CNKeyDescriptor,
                                                               CNContactNoteKey as CNKeyDescriptor,
                                                               CNContactPostalAddressesKey as CNKeyDescriptor
            ])
        
        fetchRequest.sortOrder = CNContactSortOrder.userDefault
        
        let store = CNContactStore()
        
        do {
            try store.enumerateContacts(with: fetchRequest, usingBlock: { (contact, stop) -> Void in
                //print("\(contact.givenName) \(contact.familyName)")
                //print(contact.phoneNumbers.first?.value ?? "no")
                let cnCtct = ContactIOS()
                cnCtct.contact = contact
                cnCtct.isImported = cnCtct.isAlreadyImported
                if cnCtct.isValidToImport {
                    results.append(cnCtct)
                }
                
                
                //cnCtct.addToRealm()
                
                
                
            })
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
        return results
    }
}
