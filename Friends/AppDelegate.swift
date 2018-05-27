//
//  AppDelegate.swift
//  Friends
//
//  Created by bernard on 24/05/2018.
//  Copyright © 2018 bernard. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //demoPopulate()
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
        let realm = try! Realm(configuration: Realm.Configuration(deleteRealmIfMigrationNeeded: true))
        try! realm.write {
            //realm.deleteAll()
        }
        
        
        let df = DateFormatter()
        df.dateFormat = "dd'-'MM'-'yyyy"
        
        
        let p1 = Person()
        p1.firstName = "Sylvette"
        p1.lastName = "David"
        if let aDate = df.date(from: "08-02-1954"){
            p1.born = aDate
        }
        
        let p2 = Person()
        p2.firstName = "Bernard"
        p2.lastName = "David"
        if let aDate = df.date(from: "15-08-1952"){
            p2.born = aDate
        }
        
        let p3 = Person()
        p3.firstName = "Annette"
        p3.lastName = "David"
        
        let p4 = Person()
        p4.firstName = "Sylvie"
        p4.lastName = "Aimé"
        
        let p5 = Person()
        p5.firstName = "Nathalie"
        p5.lastName = "Rollier-Sigallet"
        
        let p6 = Person()
        p6.firstName = "Denis"
        p6.lastName = "Rollier-Sigallet"
        
        let p7 = Person()
        p7.firstName = "Clarisse"
        p7.lastName = "Rollier-Sigallet"
        
        let p8 = Person()
        p8.firstName = "Jacqueline"
        p8.lastName = "David"
        
        let p9 = Person()
        p9.firstName = "Philippe"
        p9.lastName = "David"
        
        if realm.objects(Person.self).count == 0 {
            try! realm.write {
                realm.add(p1)
                realm.add(p2)
                realm.add(p3)
                realm.add(p4)
                realm.add(p5)
                realm.add(p6)
                realm.add(p7)
                realm.add(p8)
                realm.add(p9)
            }
        }
        
         let persons = realm.objects(Person.self).sorted(by: ["lastName", "firstName"])
         //let fullNames = persons.map { $0.fullName }.joined(separator: ", ")
         print(persons.count)
         //print("Full names of all people are: \(fullNames)")
         // print(persons)
         
         let results = ImportContacts.loadCNContacts()
         print(results.count)
         /*let fullNamesIOS = results.map { "\($0.contact.givenName) \($0.contact.familyName)" }
         .joined(separator: ", ")
         print("Full names IOS of all people are: \(fullNamesIOS)")*/
         //print(persons)
         
    }
}

