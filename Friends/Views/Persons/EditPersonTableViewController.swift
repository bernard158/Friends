//
//  EditPersonTableViewController.swift
//  Friends
//
//  Created by bernard on 01/06/2018.
//  Copyright © 2018 bernard. All rights reserved.
//

import UIKit

class EditPersonTableViewController: UITableViewController, UITextFieldDelegate, UITextViewDelegate {
    
    public var person: Person? // reçoit un  objec détaché de realm
    public var detailView: PersonDetailTableViewController?
    public var masterView: PersonsTableViewController?
    var sections: [Section] = []
    var previousPosition:CGRect = CGRect()
    
    
    //---------------------------------------------------------------------------
    @IBAction func SavePerson(_ sender: Any) {
        dismiss(animated: true, completion: {
            self.person!.save()
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
        
        //section nom prénom ---------------------------------------
        let sectionNomPrenom = Section(title: "")
        let ligneNom = Ligne()
        ligneNom.cellIdentifier = "textFieldCell"
        ligneNom.sujet = "nom"
        ligneNom.placeHolder = "Nom"
        
        let lignePrenom = Ligne()
        lignePrenom.cellIdentifier = "textFieldCell"
        lignePrenom.sujet = "prenom"
        lignePrenom.placeHolder = "Prénom"
        
        sectionNomPrenom.lignes.append(ligneNom)
        sectionNomPrenom.lignes.append(lignePrenom)
        sections.append(sectionNomPrenom)
        
        
        //section adresses ---------------------------------------
        let sectionAdresses = Section(title: "Adresse")
        let ligneAdresses = Ligne()
        ligneAdresses.cellIdentifier = "textViewCell"
        ligneAdresses.sujet = "addresses"
        ligneAdresses.placeHolder = "Adresse"
        
        sectionAdresses.lignes.append(ligneAdresses)
        sections.append(sectionAdresses)
        
        return

        //section phones ---------------------------------------
        let nbPhones = person!.phones.count
        if(nbPhones > 0) {
            let sectionPhone = Section(title: nbPhones == 1 ? "Téléphone" : "Téléphones")
            let lignePhone = Ligne()
            lignePhone.sujet = "phones"
            lignePhone.objectRef = person
            lignePhone.cellIdentifier = "baseTextViewCell"
            
            sectionPhone.lignes.append(lignePhone)
            sections.append(sectionPhone)
        }
        
        //section emails ---------------------------------------
        let nbMails = person!.emails.count
        if(nbMails > 0) {
            let sectionMail = Section(title: nbMails == 1 ? "Email" : "Emails")
            let ligneMail = Ligne()
            ligneMail.sujet = "emails"
            ligneMail.objectRef = person
            ligneMail.cellIdentifier = "baseTextViewCell"
            
            sectionMail.lignes.append(ligneMail)
            sections.append(sectionMail)
        }
        
        //section social profiles ---------------------------------------
        let nbSocialProfiles = person!.socialProfiles.count
        if(nbSocialProfiles > 0) {
            let sectionSocialProfiles = Section(title: nbSocialProfiles == 1 ? "Réseau social" : "Réseaux sociaux")
            let ligneSocialProfiles = Ligne()
            ligneSocialProfiles.sujet = "socialProfiles"
            ligneSocialProfiles.objectRef = person
            ligneSocialProfiles.cellIdentifier = "baseTextViewCell"
            
            sectionSocialProfiles.lignes.append(ligneSocialProfiles)
            sections.append(sectionSocialProfiles)
        }
        
        //section note ---------------------------------------
        if(person!.note.count > 0) {
            let sectionNote = Section(title: "Note")
            let ligneNote = Ligne()
            ligneNote.sujet = "note"
            ligneNote.objectRef = person
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
        //let person = person!
        
        //Titre Nom prénom, photo date nais age
        if (aLigne.cellIdentifier == "textFieldCell") {
            let textField = cell.viewWithTag(1000) as! BindableUITextField
            textField.sujet = aLigne.sujet
            textField.delegate = self as UITextFieldDelegate
            textField.placeholder = aLigne.placeHolder
            if aLigne.sujet == "nom" {
                textField.text = person!.nom
            } else if aLigne.sujet == "prenom" {
                textField.text = person!.prenom
            }
        }

        //Adresses
        if (aLigne.cellIdentifier == "textViewCell") {
            let textView = cell.viewWithTag(1001) as! BindableUITextView
            textView.sujet = aLigne.sujet
            textView.indexPath = indexPath
            textView.delegate = self as UITextViewDelegate
            //textView.placeholder = aLigne.placeHolder
            if aLigne.sujet == "addresses" {
                textView.text = person!.addresses
            }
        }

        return cell
    }
    
    
    
    /*
     let labelJourMois = cell.viewWithTag(1003) as! UILabel
     //xxx labelJourMois.text = Date.getDayMonth(person.dateNais)
     let labelAge = cell.viewWithTag(1004) as! UILabel
     //xxx labelAge.text = Date.calculateAge(person.dateNais)
     let df = DateFormatter()
     df.dateFormat = "dd-MM-yyyy"
     if let dateNais = person.dateNais {
     let strDate = df.string(from: dateNais)
     labelJourMois.text = strDate
     labelAge.text = String(person.age()!)
     } else {
     labelJourMois.text = ""
     labelAge.text = ""
     }
     //image
     var image = UIImage()
     let imageView = cell.viewWithTag(1000) as! UIImageView
     imageView.image = nil
     if person.imageData != nil {
     image = UIImage(data: person.imageData!)!
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
     let nbMails = person.emails.count
     var cpt = 1
     var strMails = ""
     for strMail in person.emails {
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
     let nbSocialProfiles = person.socialProfiles.count
     var cpt = 1
     var strSocialProfiles = ""
     for strSocialProfile in person.socialProfiles {
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
     textView.attributedText = attrStr(str: person.note)
     }
     
     //Adresses
     if aLigne.sujet == "addresses" {
     let nbAddresses = person.addresses.count
     var cpt = 1
     var strAddreses = ""
     for strAddress in person.addresses {
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
     let nbPhones = person.phones.count
     var cpt = 1
     var strPhones = ""
     for strPhone in person.phones {
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
    
    // MARK: - UITextField delegate
    //---------------------------------------------------------------------------
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("textFieldDidEndEditing")
        let bindableTextField = textField as! BindableUITextField
        switch bindableTextField.sujet {
        case "nom":
            person!.nom = textField.text!
        case "prenom":
            person!.prenom = textField.text!
            
        default:
            print("switch default")
        }
    }


    // MARK: - UITextView delegate
    //---------------------------------------------------------------------------
    func textViewDidEndEditing(_ textView: UITextView) {
        print("textViewDidEndEditing")
        let bindableTextField = textView as! BindableUITextView
        switch bindableTextField.sujet {
        case "addresses":
            person!.addresses = textView.text!
            
        default:
            print("switch default")
        }
    }

    //---------------------------------------------------------------------------
   /* func textViewDidChange(_ textView: UITextView) {
        let textView = textView as! BindableUITextView
        let indexPaths = [textView.indexPath]
        //let endPosition: UITextPosition = textView.endOfDocument
        
        if let selectedRange = textView.selectedTextRange {
            
            tableView.reloadRows(at: indexPaths, with: .none)
            textView.becomeFirstResponder()
            
            if let newPosition = textView.position(from: selectedRange.start, offset: +1) {
                
                // set the new position
                textView.selectedTextRange = textView.textRange(from: newPosition, to: newPosition)
            }
        }
        //textView.selectedTextRange = textView.textRange(from: newPosition, to: newPosition)
    }*/
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
