//
//  AppDelegate.swift
//  Friends
//
//  Created by bernard on 24/05/2018.
//  Copyright © 2018 bernard. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        demoPopulate()
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func demoPopulate() {
        
        let deleteRealm = false
        let populate = false
        
        let realm = try! Realm(configuration: Realm.Configuration(deleteRealmIfMigrationNeeded: true))
        if deleteRealm {
            realm.beginWrite()
            realm.deleteAll()
            try! realm.commitWrite()
        }
        if !populate { return }

        // création des personnes
        let df = DateFormatter()
        df.dateFormat = "dd'-'MM'-'yyyy"
        
        let sylvette = Person(prenom: "Sylvette", nom: "David")
        if let aDate = df.date(from: "08-02-1954"){
            sylvette.dateNais = aDate
        }
        
        let bernard = Person(prenom: "Bernard", nom: "David")
        if let aDate = df.date(from: "15-08-1952"){
            bernard.dateNais = aDate
        }
        
        let annette = Person(prenom: "Annette", nom: "David")
        
        let sylvie = Person(prenom: "Sylvie", nom: "Aimé")
        
        let nathalie = Person(prenom: "Nathalie", nom: "Rollier-Sigallet")
        
        let denis = Person(prenom: "Denis", nom: "Rollier-Sigallet")
        
        let clarisse = Person(prenom: "Clarisse", nom: "Rollier-Sigallet")
        
        let jacqueline = Person(prenom: "Jacqueline", nom: "David")
        
        let philippe = Person(prenom: "Philippe", nom: "David")
        
        if realm.objects(Person.self).count == 0 {
            try! realm.write {
                realm.add(sylvette)
                realm.add(bernard)
                realm.add(annette)
                realm.add(sylvie)
                realm.add(nathalie)
                realm.add(denis)
                realm.add(clarisse)
                realm.add(jacqueline)
                realm.add(philippe)
            }
        }
        
        
        
        if realm.objects(Gift.self).count == 0 {
            try! realm.write {
                //création des cadeaux
                let montreBreitling = Gift("Montre Breitling")
                sylvette.cadeauxOfferts.append(montreBreitling)
                bernard.cadeauxRecus.append(montreBreitling)
                
                let montreHermes = Gift("Montre Hermès")
                bernard.cadeauxOfferts.append(montreHermes)
                sylvette.cadeauxRecus.append(montreHermes)
                
                let moto = Gift("Moto Yamaha")
                sylvette.cadeauxOfferts.append(moto)
                bernard.cadeauxRecus.append(moto)
                
                let tomates = Gift("Tomates séchées")
                sylvette.cadeauxOfferts.append(tomates)
                bernard.cadeauxOfferts.append(tomates)
                nathalie.cadeauxRecus.append(tomates)
                jacqueline.cadeauxRecus.append(tomates)
                annette.cadeauxRecus.append(tomates)
                philippe.cadeauxRecus.append(tomates)
                
                let marcon = Gift("Stage Marcon")
                nathalie.cadeauxOfferts.append(marcon)
                jacqueline.cadeauxOfferts.append(marcon)
                philippe.cadeauxOfferts.append(marcon)
                annette.cadeauxOfferts.append(marcon)
                sylvette.cadeauxRecus.append(marcon)
                
                let angkor = Gift("Voyage à Angkor")
                sylvette.cadeauxIdees.append(angkor)           /*realm.add(montreBreitling)
                 realm.add(montreHermes)
                 realm.add(moto)
                 realm.add(tomates)
                 realm.add(marcon)
                 realm.add(angkor)*/
                
            }
        }
        
        
        
        //let persons = realm.objects(Person.self).sorted(by: ["nom", "prenom"])
        //let fullNames = persons.map { $0.fullName }.joined(separator: ", ")
        //print(persons.count)
         //print("Full names of all people are: \(fullNames)")
         // print(persons)
         
         //let results = ImportContacts.loadCNContacts()
         //print(results.count)
         /*let fullNamesIOS = results.map { "\($0.contact.givenName) \($0.contact.familyName)" }
         .joined(separator: ", ")
         print("Full names IOS of all people are: \(fullNamesIOS)")*/
         //print(persons)
         
    }
}

