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
        
        //demoPopulate(deleteRealm: false, populate: true)
        //demoPopulate(deleteRealm: false, populate: false)
        demoPopulate(deleteRealm: true, populate: true)
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
    
    func demoPopulate(deleteRealm:Bool, populate: Bool) {
        
        let realm = try! Realm(configuration: Realm.Configuration(deleteRealmIfMigrationNeeded: true))
        if deleteRealm {
            realm.beginWrite()
            realm.deleteAll()
            try! realm.commitWrite()
        }
        if !populate { return }
        
        if !realm.isEmpty { return }
        
        // création des personnes
        let df = DateFormatter()
        df.dateFormat = "dd'-'MM'-'yyyy"
        
        let sylvette = Person(prenom: "Sylvette", nom: "David")
        sylvette.dateNais = df.date(from: "08-02-1954")
        sylvette.addresses = "4 rue de la Voûte - 07290 Quintenas"
        sylvette.urls = "FDQ : familles-de-quintenas.com"
        
        let bernard = Person(prenom: "Bernard", nom: "David")
        bernard.dateNais = df.date(from: "15-08-1952")
        bernard.addresses = "4 rue de la Voûte - 07290 Quintenas"
        
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
                montreBreitling.date = df.date(from: "15-08-2010")
                montreBreitling.note = "Offert à Bernard le jour de son anniversaire à Arles, avec Annette et Fabien"
                sylvette.cadeauxOfferts.append(montreBreitling)
                bernard.cadeauxRecus.append(montreBreitling)
                
                let montreHermes = Gift("Montre Hermès")
                montreHermes.date = df.date(from: "08-02-2008")
                montreHermes.note = "Offert à Sylvette lors d'une ballade à Nice"
                bernard.cadeauxOfferts.append(montreHermes)
                sylvette.cadeauxRecus.append(montreHermes)
                
                let moto = Gift("Moto Yamaha")
                moto.date = df.date(from: "15-08-1998")
                moto.note = "Quel cadeau de rêve !!!"
                moto.url = "http://www.yam34.com"
                moto.magasin = "YAM34 - 250 Rue de la Jasse, 34130 Mauguio"
                moto.prix = 5000.0
                sylvette.cadeauxOfferts.append(moto)
                bernard.cadeauxRecus.append(moto)
                
                let tomates = Gift("Tomates séchées")
                tomates.date = df.date(from: "25-12-2013")
                sylvette.cadeauxOfferts.append(tomates)
                bernard.cadeauxOfferts.append(tomates)
                nathalie.cadeauxRecus.append(tomates)
                jacqueline.cadeauxRecus.append(tomates)
                annette.cadeauxRecus.append(tomates)
                philippe.cadeauxRecus.append(tomates)
                
                let marcon = Gift("Stage Marcon")
                marcon.date = df.date(from: "05-07-2014")
                marcon.magasin = "Régis Marcon - Saint-Bonnet-le-Froid"
                marcon.url = "http://www.regismarcon.fr/stages.php"
                nathalie.cadeauxOfferts.append(marcon)
                jacqueline.cadeauxOfferts.append(marcon)
                philippe.cadeauxOfferts.append(marcon)
                annette.cadeauxOfferts.append(marcon)
                sylvette.cadeauxRecus.append(marcon)
                
                let robeChambre = Gift("Robe de chambre")
                robeChambre.date = df.date(from: "08-02-2018")
                bernard.cadeauxOfferts.append(robeChambre)
                sylvette.cadeauxRecus.append(robeChambre)
                
                let ficus = Gift("Ficus")
                ficus.date = df.date(from: "08-02-2013")
                bernard.cadeauxOfferts.append(ficus)
                sylvette.cadeauxRecus.append(ficus)
                
                let sicile = Gift("Sicile")
                sicile.date = df.date(from: "30-05-2014")
                bernard.cadeauxOfferts.append(sicile)
                sylvette.cadeauxRecus.append(sicile)
                
                let montreCK = Gift("Montre Calvin Klein")
                montreCK.date = df.date(from: "04-02-2007")
                bernard.cadeauxOfferts.append(montreCK)
                sylvette.cadeauxRecus.append(montreCK)
                
                let theiere = Gift("Théière Mariage")
                theiere.date = df.date(from: "24-12-2011")
                sylvette.cadeauxOfferts.append(theiere)
                jacqueline.cadeauxRecus.append(theiere)
                
                let jars = Gift("Plat Jars rouge")
                jars.date = df.date(from: "24-12-2011")
                sylvette.cadeauxOfferts.append(jars)
                nathalie.cadeauxRecus.append(jars)
                
                let sexCity = Gift("Sex and the city")
                sexCity.date = df.date(from: "24-12-2004")
                bernard.cadeauxOfferts.append(sexCity)
                sylvette.cadeauxRecus.append(sexCity)
                
                let chaussons = Gift("Chaussons Isotoner")
                chaussons.date = df.date(from: "24-12-2004")
                sylvette.cadeauxOfferts.append(chaussons)
                nathalie.cadeauxRecus.append(chaussons)
                
                let gourmiBox = Gift("GourmiBox")
                gourmiBox.date = df.date(from: "24-12-2017")
                philippe.cadeauxOfferts.append(gourmiBox)
                sylvette.cadeauxRecus.append(gourmiBox)
                jacqueline.cadeauxRecus.append(gourmiBox)
                annette.cadeauxRecus.append(gourmiBox)
                bernard.cadeauxRecus.append(gourmiBox)
                
                let sets = Gift("Sets de table")
                sets.date = df.date(from: "24-12-2016")
                philippe.cadeauxOfferts.append(sets)
                sylvette.cadeauxRecus.append(sets)
                jacqueline.cadeauxRecus.append(sets)
                annette.cadeauxRecus.append(sets)
                bernard.cadeauxRecus.append(sets)
                
                let angkor = Gift("Voyage à Angkor")
                sylvette.cadeauxIdees.append(angkor)
                let stPeter = Gift("Voyage à Saint-Pétersbourg")
                sylvette.cadeauxIdees.append(stPeter)
                let rmn = Gift("Objet RMN")
                sylvette.cadeauxIdees.append(rmn)
                let soins = Gift("Soins de beauté")
                sylvette.cadeauxIdees.append(soins)
                
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

