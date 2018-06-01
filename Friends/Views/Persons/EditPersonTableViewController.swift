//
//  EditPersonTableViewController.swift
//  Friends
//
//  Created by bernard on 01/06/2018.
//  Copyright © 2018 bernard. All rights reserved.
//

import UIKit

class EditPersonTableViewController: UITableViewController {
    
    public var person: Person?
    public var detailView: PersonDetailTableViewController?
    public var masterView: PersonsTableViewController?
    var sections: [Section] = []
    
    
    //---------------------------------------------------------------------------
    @IBAction func SavePerson(_ sender: Any) {
        person?.save()
        dismiss(animated: true, completion: {
            self.detailView?.tableView.reloadData()
            self.masterView?.tableView.reloadData()
        })
    }
    //---------------------------------------------------------------------------
    @IBAction func cancelEditPerson(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //---------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        configureViewPersonne()
    }
    
    //---------------------------------------------------------------------------
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //---------------------------------------------------------------------------
    func clearView() {
        sections.removeAll(keepingCapacity: false)
        tableView.reloadData()
        tableView.setNeedsDisplay()
        //print("ClearView")
    }
    
    //---------------------------------------------------------------------------
    func configureViewPersonne() {
        
        //print("configureViewPersonne")
        clearView()
        
        // Update the user interface for the detail item.
        let personne = person!
        
        //section nom prénom ---------------------------------------
        let sectionNomPrenom = Section(title: "")
        let ligneNom = Ligne()
        ligneNom.cellIdentifier = "textFieldCell"
        ligneNom.sujet = "nom"
        ligneNom.objectRef = personne.nom as AnyObject
        ligneNom.placeHolder = "Nom"
        
        let lignePrenom = Ligne()
        lignePrenom.cellIdentifier = "textFieldCell"
        lignePrenom.sujet = "prenom"
        lignePrenom.objectRef = personne.prenom as AnyObject
        lignePrenom.placeHolder = "Prénom"
        
        sectionNomPrenom.lignes.append(ligneNom)
        sectionNomPrenom.lignes.append(lignePrenom)
        sections.append(sectionNomPrenom)
        
        return
        
        //section adresses ---------------------------------------
        let nbAddresses = personne.addresses.count
        if(nbAddresses > 0) {
            let sectionAdresses = Section(title: nbAddresses == 1 ? "Adresse" : "Adresses")
            let ligneAdresses = Ligne()
            ligneAdresses.sujet = "addresses"
            ligneAdresses.objectRef = personne
            ligneAdresses.cellIdentifier = "baseTextViewCell"
            
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
            lignePhone.cellIdentifier = "baseTextViewCell"
            
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
            ligneMail.cellIdentifier = "baseTextViewCell"
            
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
            ligneSocialProfiles.cellIdentifier = "baseTextViewCell"
            
            sectionSocialProfiles.lignes.append(ligneSocialProfiles)
            sections.append(sectionSocialProfiles)
        }
        
        //section note ---------------------------------------
        if(personne.note.count > 0) {
            let sectionNote = Section(title: "Note")
            let ligneNote = Ligne()
            ligneNote.sujet = "note"
            ligneNote.objectRef = personne
            ligneNote.cellIdentifier = "baseTextViewCell"
            
            sectionNote.lignes.append(ligneNote)
            sections.append(sectionNote)
        }
        
        //---------------------------------------
        
        
        tableView.reloadData()
        
    }
    //---------------------------------------------------------------------------
    
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
        if (aLigne.cellIdentifier == "textFieldCell") {
            let textField = cell.viewWithTag(1000) as! UITextField
            textField.placeholder = aLigne.placeHolder
            if aLigne.sujet == "nom" {
                textField.text = personne.nom
            } else if aLigne.sujet == "prenom" {
                textField.text = personne.prenom
            }
        }
        return cell
  }

            
            
            /*
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
             */
        //}
        /*
         if (aLigne.cellIdentifier == "baseTextViewCell") {
         let textView = cell.viewWithTag(1000) as! UITextView
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
         //textView.text = strMails
         textView.attributedText = attrStr(str: strMails)
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
         //textView.text = strSocialProfiles
         textView.attributedText = attrStr(str: strSocialProfiles)
         }
         
         //note
         if aLigne.sujet == "note" {
         textView.attributedText = attrStr(str: personne.note)
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
         
         textView.attributedText = attrStr(str: strAddreses)
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
         textView.attributedText = attrStr(str: strPhones)
         }
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
         
         
         }
         */
        
        //return cell
    
    //---------------------------------------------------------------------------
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        let strSection = sections[section].sectionTitle
        if strSection.count == 0 {
            return 0
        } else {
            return 35.0
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
    
}
