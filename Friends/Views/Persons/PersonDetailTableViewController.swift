//
//  PersonDetailTableViewController.swift
//  Friends
//
//  Created by bernard on 27/05/2018.
//  Copyright © 2018 bernard. All rights reserved.
//

import UIKit

class PersonDetailTableViewController: UITableViewController {
    
    var person: Person? {
        didSet {
            // Update the view.
            configureViewPersonne()
        }

    }
    var sections: [Section] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureViewPersonne() {
        
        print("configureViewPersonne")
        clearView()
        
        // Update the user interface for the detail item.
        let personne = person!
        
        //section nom prénom ---------------------------------------
        let sectionNomPrenom = Section(title: "")
        let ligneNomPrenom = Ligne()
        ligneNomPrenom.objectRef = personne
        ligneNomPrenom.cellIdentifier = "CellTitre"
        
        sectionNomPrenom.lignes.append(ligneNomPrenom)
        sections.append(sectionNomPrenom)
        
        //section adresses ---------------------------------------
        let nbAddresses = personne.addresses.count
        if(nbAddresses > 0) {
            let sectionAdresses = Section(title: nbAddresses == 1 ? "Address" : "Addresses")
            let ligneAdresses = Ligne()
            ligneAdresses.title = "addresses"
            ligneAdresses.objectRef = personne
            ligneAdresses.cellIdentifier = "baseTextCell"
            
            sectionAdresses.lignes.append(ligneAdresses)
            sections.append(sectionAdresses)
        }
        
        //section phones ---------------------------------------
        let nbPhones = personne.phones.count
        if(nbPhones > 0) {
            let sectionPhone = Section(title: nbPhones == 1 ? "Phone Number" : "Phone Numbers")
            let lignePhone = Ligne()
            lignePhone.title = "phones"
            lignePhone.objectRef = personne
            lignePhone.cellIdentifier = "baseTextCell"
            
            sectionPhone.lignes.append(lignePhone)
            sections.append(sectionPhone)
        }
        
        //section emails ---------------------------------------
        let nbMails = personne.emails.count
        if(nbMails > 0) {
            let sectionMail = Section(title: nbMails == 1 ? "Email" : "Emails")
            let ligneMail = Ligne()
            ligneMail.title = "emails"
            ligneMail.objectRef = personne
            ligneMail.cellIdentifier = "baseTextCell"
            
            sectionMail.lignes.append(ligneMail)
            sections.append(sectionMail)
        }
        
        //section social profiles ---------------------------------------
        let nbSocialProfiles = personne.socialProfiles.count
        if(nbSocialProfiles > 0) {
            let sectionSocialProfiles = Section(title: nbSocialProfiles == 1 ? "Social Profile" : "Social Profiles")
            let ligneSocialProfiles = Ligne()
            ligneSocialProfiles.title = "socialProfiles"
            ligneSocialProfiles.objectRef = personne
            ligneSocialProfiles.cellIdentifier = "baseTextCell"
            
            sectionSocialProfiles.lignes.append(ligneSocialProfiles)
            sections.append(sectionSocialProfiles)
        }
        
        //---------------------------------------
        tableView.reloadData()

    }
    
    func clearView() {
        sections.removeAll(keepingCapacity: false)
        tableView.reloadData()
        tableView.setNeedsDisplay()
        //print("ClearView")
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sections[section].lignes.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].sectionTitle
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let aLigne = sections[indexPath.section].lignes[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: aLigne.cellIdentifier, for: indexPath) as UITableViewCell
        let personne = person!

        //Titre Nom prénom, photo date nais age
        if (aLigne.cellIdentifier == "CellTitre") {
            let labelNom = cell.viewWithTag(1001) as! UILabel
            labelNom.text = personne.lastName
            let labelPrenom = cell.viewWithTag(1002) as! UILabel
            labelPrenom.text = personne.firstName
            let labelJourMois = cell.viewWithTag(1003) as! UILabel
            //xxx labelJourMois.text = Date.getDayMonth(personne.dateNais)
            let labelAge = cell.viewWithTag(1004) as! UILabel
            //xxx labelAge.text = Date.calculateAge(personne.dateNais)
            let df = DateFormatter()
            df.dateFormat = "dd-MM-yyyy"
            if let born = personne.born {
                let strDate = df.string(from: born)
                labelJourMois.text = strDate
                labelAge.text = String(personne.age()!)
         } else {
                labelJourMois.text = ""
                labelAge.text = ""
            }
            //image
            var image = UIImage()
            let imageView = cell.viewWithTag(1000) as! UIImageView
            imageView.image = nil
            if personne.imageData != nil {
                image = UIImage(data: personne.imageData!)!
            } else {
                image = UIImage(named: "noImage.png")!
            }
            //affectation de l'image réduite
            imageView.backgroundColor = UIColor.white
            imageView.image = scaledImageRound(image, dim: 90, borderWidth: 3.0, borderColor: UIColor.white, imageView: imageView)
            
            
        }
        if (aLigne.cellIdentifier == "baseTextCell") {
            let label = cell.viewWithTag(1000) as! UILabel

            //Adresses
           if aLigne.title == "addresses" {
                let nbAddresses = personne.addresses.count
                var cpt = 1
                var strAddreses = ""
                for strAddress in personne.addresses {
                    strAddreses += strAddress
                    if cpt < nbAddresses {
                        strAddreses += "\n"
                    }
                    cpt += 1
                }
                label.text = strAddreses
            }
            
            //Phone numbers
            if aLigne.title == "phones" {
                let nbPhones = personne.phones.count
                var cpt = 1
                var strPhones = ""
                for strPhone in personne.phones {
                    strPhones += strPhone
                    if cpt < nbPhones {
                        strPhones += "\n"
                    }
                    cpt += 1
                }
                label.text = strPhones
            }

            //emails
            if aLigne.title == "emails" {
                let nbMails = personne.emails.count
                var cpt = 1
                var strMails = ""
                for strMail in personne.emails {
                    strMails += strMail
                    if cpt < nbMails {
                        strMails += "\n"
                    }
                    cpt += 1
                }
                label.text = strMails
            }

            //social profiles
            if aLigne.title == "socialProfiles" {
                let nbSocialProfiles = personne.socialProfiles.count
                var cpt = 1
                var strSocialProfiles = ""
                for strSocialProfile in personne.socialProfiles {
                    strSocialProfiles += strSocialProfile
                    if cpt < nbSocialProfiles {
                        strSocialProfiles += "\n"
                    }
                    cpt += 1
                }
                label.text = strSocialProfiles
            }
        }
        

        return cell
    }
}

/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destinationViewController.
 // Pass the selected object to the new view controller.
 }
 */

// MARK: - Autres classes

class Ligne {
    var table: String
    var objectRef: AnyObject?
    var title: String
    var label: String
    var cellIdentifier: String
    var photoData: Data
    var accessoryType:UITableViewCellAccessoryType
    
    init() {
        self.table = ""
        self.objectRef = nil as AnyObject?
        self.title = ""
        self.label = ""
        self.cellIdentifier = ""
        self.photoData = Data()
        accessoryType = UITableViewCellAccessoryType.none
    }
    
}

class Section {
    let sectionTitle: String
    var lignes: [Ligne]
    
    init(title: String) {
        self.sectionTitle = title
        self.lignes = []
    }
}



