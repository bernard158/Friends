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
    
    
    //---------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
    }
    
    //---------------------------------------------------------------------------
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //---------------------------------------------------------------------------
    func configureViewPersonne() {
        
        //print("configureViewPersonne")
        clearView()
        
        // Update the user interface for the detail item.
        let personne = person!
        
        //section prenom prénom ---------------------------------------
        let sectionNomPrenom = Section(title: "")
        let ligneNomPrenom = Ligne()
        ligneNomPrenom.objectRef = personne
        ligneNomPrenom.cellIdentifier = "CellTitre"
        
        sectionNomPrenom.lignes.append(ligneNomPrenom)
        sections.append(sectionNomPrenom)
        
        //section cadeaux reçus ---------------------------------------
        if personne.cadeauxRecus.count > 0 {
            let sectioncadeauxRecus = Section(title: "Cadeaux reçus")
            for gift in personne.cadeauxRecus {
                let lignecadeauxRecus = Ligne()
                lignecadeauxRecus.sujet = "cadeauxRecus"
                lignecadeauxRecus.objectRef = gift
                lignecadeauxRecus.cellIdentifier = "baseTextCell"
                sectioncadeauxRecus.lignes.append(lignecadeauxRecus)
            }
            sections.append(sectioncadeauxRecus)
        }
        
        //section cadeaux offerts ---------------------------------------
        if personne.cadeauxOfferts.count > 0 {
            let sectioncadeauxOfferts = Section(title: "Cadeaux offerts")
            for gift in personne.cadeauxOfferts {
                let lignecadeauxOfferts = Ligne()
                lignecadeauxOfferts.sujet = "cadeauxOfferts"
                lignecadeauxOfferts.objectRef = gift
                lignecadeauxOfferts.cellIdentifier = "baseTextCell"
                sectioncadeauxOfferts.lignes.append(lignecadeauxOfferts)
            }
            sections.append(sectioncadeauxOfferts)
        }
        
         //section cadeaux idées ---------------------------------------
        if personne.cadeauxIdees.count > 0 {
            let sectioncadeauxIdees = Section(title: "Idées cadeaux")
            for gift in personne.cadeauxIdees {
                let lignecadeauxIdees = Ligne()
                lignecadeauxIdees.sujet = "cadeauxOfferts"
                lignecadeauxIdees.objectRef = gift
                lignecadeauxIdees.cellIdentifier = "baseTextCell"
                sectioncadeauxIdees.lignes.append(lignecadeauxIdees)
            }
            sections.append(sectioncadeauxIdees)
        }

      //section adresses ---------------------------------------
        let nbAddresses = personne.addresses.count
        if(nbAddresses > 0) {
            let sectionAdresses = Section(title: nbAddresses == 1 ? "Adresse" : "Adresses")
            let ligneAdresses = Ligne()
            ligneAdresses.sujet = "addresses"
            ligneAdresses.objectRef = personne
            ligneAdresses.cellIdentifier = "baseTextCell"
            
            sectionAdresses.lignes.append(ligneAdresses)
            sections.append(sectionAdresses)
        }
        
        //section phones ---------------------------------------
        let nbPhones = personne.phones.count
        if(nbPhones > 0) {
            let sectionPhone = Section(title: nbPhones == 1 ? "Téléphone" : "Téléphones")
            let lignePhone = Ligne()
            lignePhone.sujet = "phones"
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
            ligneMail.sujet = "emails"
            ligneMail.objectRef = personne
            ligneMail.cellIdentifier = "baseTextCell"
            
            sectionMail.lignes.append(ligneMail)
            sections.append(sectionMail)
        }
        
        //section social profiles ---------------------------------------
        let nbSocialProfiles = personne.socialProfiles.count
        if(nbSocialProfiles > 0) {
            let sectionSocialProfiles = Section(title: nbSocialProfiles == 1 ? "Réseau social" : "Réseaux sociaux")
            let ligneSocialProfiles = Ligne()
            ligneSocialProfiles.sujet = "socialProfiles"
            ligneSocialProfiles.objectRef = personne
            ligneSocialProfiles.cellIdentifier = "baseTextCell"
            
            sectionSocialProfiles.lignes.append(ligneSocialProfiles)
            sections.append(sectionSocialProfiles)
        }
        
        //section note ---------------------------------------
        if(personne.note.count > 0) {
            let sectionNote = Section(title: "Note")
            let ligneNote = Ligne()
            ligneNote.sujet = "note"
            ligneNote.objectRef = personne
            ligneNote.cellIdentifier = "baseTextCell"
            
            sectionNote.lignes.append(ligneNote)
            sections.append(sectionNote)
        }
        
        //---------------------------------------
        
        
        tableView.reloadData()

    }
    
    //---------------------------------------------------------------------------
    func clearView() {
        sections.removeAll(keepingCapacity: false)
        tableView.reloadData()
        tableView.setNeedsDisplay()
        //print("ClearView")
    }
    
    
    // MARK: - Table view data source
    
    //---------------------------------------------------------------------------
   override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sections.count
    }
    
    //---------------------------------------------------------------------------
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sections[section].lignes.count
    }
    
    //---------------------------------------------------------------------------
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].sectionTitle
    }
    
    
    //---------------------------------------------------------------------------
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let aLigne = sections[indexPath.section].lignes[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: aLigne.cellIdentifier, for: indexPath) as UITableViewCell
        let personne = person!

        //Titre Nom prénom, photo date nais age
        if (aLigne.cellIdentifier == "CellTitre") {
            let labelNom = cell.viewWithTag(1001) as! UILabel
            labelNom.text = personne.nom
            let labelPrenom = cell.viewWithTag(1002) as! UILabel
            labelPrenom.text = personne.prenom
            let labelJourMois = cell.viewWithTag(1003) as! UILabel
            //xxx labelJourMois.text = Date.getDayMonth(personne.dateNais)
            let labelAge = cell.viewWithTag(1004) as! UILabel
            //xxx labelAge.text = Date.calculateAge(personne.dateNais)
            let df = DateFormatter()
            df.dateFormat = "dd-MM-yyyy"
            if let dateNais = personne.dateNais {
                let strDate = df.string(from: dateNais)
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

            //Cadeaux reçus
            if aLigne.sujet == "cadeauxRecus" {
                let aGift = aLigne.objectRef as! Gift
                label.text = aGift.giftFrom
            }
            
            //Cadeaux offerts
            if aLigne.sujet == "cadeauxOfferts" {
                let aGift = aLigne.objectRef as! Gift
                label.text = aGift.giftFor
            }
            
            //Adresses
            if aLigne.sujet == "addresses" {
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
            if aLigne.sujet == "phones" {
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
            if aLigne.sujet == "emails" {
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
            if aLigne.sujet == "socialProfiles" {
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

            //note
            if aLigne.sujet == "note" {
                label.text = personne.note
            }
        }
        

        return cell
    }
    
    //---------------------------------------------------------------------------
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35.0
    }
}



//---------------------------------------------------------------------------
/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destinationViewController.
 // Pass the selected object to the new view controller.
 }
 */


//---------------------------------------------------------------------------
// MARK: - Autres classes

//---------------------------------------------------------------------------



