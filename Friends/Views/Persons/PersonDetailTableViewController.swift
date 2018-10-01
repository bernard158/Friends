//
//  PersonDetailTableViewController.swift
//  Friends
//
//  Created by bernard on 27/05/2018.
//  Copyright © 2018 bernard. All rights reserved.
//

import UIKit
import RealmSwift
import CollieGallery


class PersonDetailTableViewController: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var imagePicker: UIImagePickerController!
    
    var person: Person? {
        didSet {
            //configureViewPersonne()
        }
    }
    var sections: [Section] = []
    
    
    //---------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(PersonDetailTableViewController.personEditDetail))
        
    }
    
    //---------------------------------------------------------------------------
    override func viewWillAppear(_ animated: Bool) {
        //print("viewWillAppear PersonDetailTableViewController")
        configureViewPersonne()
        super.viewWillAppear(animated)
    }
    
    //---------------------------------------------------------------------------
    override func viewWillDisappear(_ animated: Bool) {
        //print("viewWillDisappear PersonDetailTableViewController")
        //itemsToken?.invalidate()
    }
    
    //---------------------------------------------------------------------------
    override func viewDidAppear(_ animated: Bool) {
        //print("viewDidAppear PersonDetailTableViewController")
    }
    
    //---------------------------------------------------------------------------
    override func viewDidDisappear(_ animated: Bool) {
        //print("viewDidDisappear PersonDetailTableViewController")
    }
    
    //---------------------------------------------------------------------------
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //---------------------------------------------------------------------------
    @objc func personEditDetail() {
        //print("personEditDetail")
        let editViewNav = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditPerson")
        let  editView:EditPersonTableViewController = editViewNav.children.first as! EditPersonTableViewController
        editView.person = Person(person: person!) // contructeur de copie
        editView.detailView = self
        let leftNavController = splitViewController!.viewControllers.first as! UINavigationController
        editView.masterView = (leftNavController.topViewController as? PersonsViewController)
        
        editViewNav.modalPresentationStyle = UIModalPresentationStyle.formSheet
        editViewNav.preferredContentSize = CGSize(width: 500, height: 800)
        
        self.present(editViewNav, animated: true, completion: nil)
    }
    //---------------------------------------------------------------------------
    func configureViewPersonne() {
        
        //print("configureViewPersonne")
        clearView()
        
        // Update the user interface for the detail item.
        guard let personne = person else { return }
        
        //section nom prénom ---------------------------------------
        let sectionNomPrenom = Section(title: "")
        let ligneNomPrenom = Ligne()
        ligneNomPrenom.objectRef = personne
        ligneNomPrenom.cellIdentifier = "CellTitre"
        
        sectionNomPrenom.lignes.append(ligneNomPrenom)
        sections.append(sectionNomPrenom)
        
        //section cadeaux reçus ---------------------------------------
        if !personne.cadeauxRecus.isEmpty {
            let sectioncadeauxRecus = Section(title: "Cadeaux reçus")
            // for gift in personne.cadeauxRecus {
            let lignecadeauxRecus = Ligne()
            lignecadeauxRecus.sujet = "cadeauxRecus"
            //lignecadeauxRecus.objectRef = gift
            lignecadeauxRecus.cellIdentifier = "baseTextCell"
            sectioncadeauxRecus.lignes.append(lignecadeauxRecus)
            //}
            sections.append(sectioncadeauxRecus)
        }
        
        //section cadeaux offerts ---------------------------------------
        if !personne.cadeauxOfferts.isEmpty {
            let sectioncadeauxOfferts = Section(title: "Cadeaux offerts")
            let lignecadeauxOfferts = Ligne()
            lignecadeauxOfferts.sujet = "cadeauxOfferts"
            lignecadeauxOfferts.cellIdentifier = "baseTextCell"
            sectioncadeauxOfferts.lignes.append(lignecadeauxOfferts)
            
            sections.append(sectioncadeauxOfferts)
        }
        
        //section cadeaux idées ---------------------------------------
        if !personne.cadeauxIdees.isEmpty {
            let sectioncadeauxIdees = Section(title: "Idées cadeaux")
            let lignecadeauxIdees = Ligne()
            lignecadeauxIdees.sujet = "cadeauxIdees"
            lignecadeauxIdees.cellIdentifier = "baseTextCell"
            sectioncadeauxIdees.lignes.append(lignecadeauxIdees)
            
            sections.append(sectioncadeauxIdees)
        }
        
        //section adresses ---------------------------------------
        if !personne.addresses.isEmpty {
            let sectionAdresses = Section(title: "Adresses")
            let ligneAdresses = Ligne()
            ligneAdresses.sujet = "addresses"
            ligneAdresses.objectRef = personne
            ligneAdresses.cellIdentifier = "baseTextViewCell"
            
            sectionAdresses.lignes.append(ligneAdresses)
            sections.append(sectionAdresses)
        }
        
        //section phones ---------------------------------------
        if !personne.phones.isEmpty {
            let sectionPhone = Section(title: "Téléphones")
            let lignePhone = Ligne()
            lignePhone.sujet = "phones"
            lignePhone.objectRef = personne
            lignePhone.cellIdentifier = "baseTextViewCell"
            
            sectionPhone.lignes.append(lignePhone)
            sections.append(sectionPhone)
        }
        
        //section emails ---------------------------------------
        if !personne.emails.isEmpty {
            let sectionMail = Section(title: "Emails")
            let ligneMail = Ligne()
            ligneMail.sujet = "emails"
            ligneMail.objectRef = personne
            ligneMail.cellIdentifier = "baseTextViewCell"
            
            sectionMail.lignes.append(ligneMail)
            sections.append(sectionMail)
        }
        
        //section social profiles ---------------------------------------
        if !personne.socialProfiles.isEmpty {
            let sectionSocialProfiles = Section(title: "Réseaux sociaux")
            let ligneSocialProfiles = Ligne()
            ligneSocialProfiles.sujet = "socialProfiles"
            ligneSocialProfiles.objectRef = personne
            ligneSocialProfiles.cellIdentifier = "baseTextViewCell"
            
            sectionSocialProfiles.lignes.append(ligneSocialProfiles)
            sections.append(sectionSocialProfiles)
        }
        
        //section urls ---------------------------------------
        if !personne.urls.isEmpty {
            let sectionUrls = Section(title: "URLs")
            let ligneUrls = Ligne()
            ligneUrls.sujet = "urls"
            ligneUrls.objectRef = personne
            ligneUrls.cellIdentifier = "baseTextViewCell"
            
            sectionUrls.lignes.append(ligneUrls)
            sections.append(sectionUrls)
        }
        
        //section aime ---------------------------------------
        if !personne.likeYes.isEmpty {
            let sectionAime = Section(title: "Aime")
            let ligneAime = Ligne()
            ligneAime.sujet = "likeYes"
            ligneAime.objectRef = personne
            ligneAime.cellIdentifier = "baseTextViewCell"
            
            sectionAime.lignes.append(ligneAime)
            sections.append(sectionAime)
        }
        
        //section aime pas ---------------------------------------
        if !personne.likeNo.isEmpty {
            let sectionAimePas = Section(title: "N'aime pas")
            let ligneAimePas = Ligne()
            ligneAimePas.sujet = "likeNo"
            ligneAimePas.objectRef = personne
            ligneAimePas.cellIdentifier = "baseTextViewCell"
            
            sectionAimePas.lignes.append(ligneAimePas)
            sections.append(sectionAimePas)
        }
        
        //section note ---------------------------------------
        if !personne.note.isEmpty {
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
    public func clearView() {
        sections.removeAll(keepingCapacity: false)
        // tableView.reloadData()
        //tableView.setNeedsDisplay()
        //print("ClearView")
    }
    
    
    @objc func addImageButtonClicked(_ sender:UIButton) {
        //print("addImageButtonClicked")
        imagePicker = UIImagePickerController()
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // ********
        alert.addAction(UIAlertAction(title: "Prendre une photo", style: .default) { _ in
            print("Prendre une photo")
            self.openCamera()
        })
        
        // ********
        alert.addAction(UIAlertAction(title: "Choisir une image", style: .default) { _ in
            self.openGallery()
        })
        
        // ********
        if person!.imageData != nil {
            // ********
            alert.addAction(UIAlertAction(title: "Afficher en plein écran", style: .default) { _ in
                self.fullScreen()
            })
            
            // ********
            alert.addAction(UIAlertAction(title: "Supprimer la photo", style: .destructive) { _ in
                let realm = RealmDB.getRealm()!
                try! realm.write {
                    self.person!.imageData = nil
                }
                self.tableView.reloadData()
            })
            
        }
        
        // ********
        alert.addAction(UIAlertAction(title: "Annuler", style: .cancel) { _ in
            
        })
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = sender as UIButton
        }
        present(alert, animated: true)
        
    }
    
    //---------------------------------------------------------------------------
   func openGallery() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    //---------------------------------------------------------------------------
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            imagePicker.delegate = self
            self.imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            self .present(self.imagePicker, animated: true, completion: nil)
        }
        else {
            let alert = UIAlertController(title: "Appareil photo", message: "Il n'y a pas d'appareil photo sur ce matériel", preferredStyle: .alert)
            
            // ********
            alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                alert.dismiss(animated: true, completion: nil)
            })
            present(alert, animated: true)
        }
    }
    
    //---------------------------------------------------------------------------
    func fullScreen() {
        
        
        var pictures = [CollieGalleryPicture]()
        
        var image = UIImage()
        if person!.imageData != nil {
            image = UIImage(data: person!.imageData!)!
        } else {
            image = UIImage(named: "noImage.png")!
        }
        
        let picture = CollieGalleryPicture(image: image)
        pictures.append(picture)
        
        let options = CollieGalleryOptions()
        //options.enableSave = false
        let customAction = CollieGalleryCustomAction(title: "Supprimer l'image", imageName: "") { () -> () in
            
            print("Supprimer image Action Tapped!")
            let realm = RealmDB.getRealm()!
            try! realm.write {
                self.person!.imageData = nil
            }
            self.tableView.reloadData()
            self.dismiss(animated:true, completion: nil)
        }
        
        options.customActions = [customAction]
        options.excludedActions = [UIActivity.ActivityType.assignToContact, UIActivity.ActivityType.copyToPasteboard, UIActivity.ActivityType.print, UIActivity.ActivityType.saveToCameraRoll]
        //options.enableZoom = false
        
        let gallery = CollieGallery(pictures: pictures, options: options)
        
        
        gallery.presentInViewController(self.splitViewController!)
    }
    
    //---------------------------------------------------------------------------
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        
        var image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as! UIImage
        image = resizeImage(image: image, targetSize: CGSize(width: 1536, height: 1536))
        
        if let imageData = image.jpegData(compressionQuality: 0.70) {
            
            let realm = RealmDB.getRealm()!
            try! realm.write {
                person!.imageData = imageData
            }
            dismiss(animated:true, completion: nil)
        }
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
        cell.accessoryType = .none

        guard let personne = person else { return cell }
        
        //Titre Nom prénom, photo date nais age
        if (aLigne.cellIdentifier == "CellTitre") {
            let labelNom = cell.viewWithTag(1001) as! UILabel
            labelNom.text = personne.nom
            let labelPrenom = cell.viewWithTag(1002) as! UILabel
            labelPrenom.text = personne.prenom
            let labelJourMois = cell.viewWithTag(1003) as! UILabel
            let labelAge = cell.viewWithTag(1004) as! UILabel
            labelJourMois.text = person?.strDateNais
            labelAge.text = person?.strAge
            
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
            
            
            //var imageButton = UIButton()
            let imageButton = cell.viewWithTag(1010) as! UIButton
            imageButton.addTarget(self, action: #selector(PersonDetailTableViewController.addImageButtonClicked(_:)), for: UIControl.Event.touchUpInside)
            
        }
        
        if (aLigne.cellIdentifier == "baseTextViewCell") {
            let textView = cell.viewWithTag(1000) as! UITextView
            
            switch aLigne.sujet {
            case "emails":
                textView.attributedText = attrStr(str: personne.emails)
            case "socialProfiles":
                textView.attributedText = attrStr(str: personne.socialProfiles)
            case "note":
                textView.attributedText = attrStr(str: personne.note)
            case "addresses":
                textView.attributedText = attrStr(str: personne.addresses)
            case "phones":
                textView.attributedText = attrStr(str: personne.phones)
            case "urls":
                textView.attributedText = attrStr(str: personne.urls)
            case "likeYes":
                textView.attributedText = attrStr(str: personne.likeYes)
            case "likeNo":
                textView.attributedText = attrStr(str: personne.likeNo)
                
            default:
                print("default switch")
            }
        }
        
        if (aLigne.cellIdentifier == "baseTextCell") {
            let label = cell.viewWithTag(1000) as! UILabel
            
            //Cadeaux reçus
            if aLigne.sujet == "cadeauxRecus" {
                //label.attributedText = personne.cadeauxRecusSortedByDonateur(color: (navigationController?.navigationBar.barTintColor)!)
                label.attributedText = personne.cadeauxRecusSortedByGroupesDonateurs(color: (navigationController?.navigationBar.barTintColor)!)
                cell.accessoryType = .disclosureIndicator
                
            }
            
            //Cadeaux offerts
            if aLigne.sujet == "cadeauxOfferts" {
                //let aGift = aLigne.objectRef as! Gift
                label.attributedText = personne.cadeauxOffertsSortedByGroupesBeneficiaires(color: (navigationController?.navigationBar.barTintColor)!)
                cell.accessoryType = .disclosureIndicator
            }
            
            //Cadeaux idées
            if aLigne.sujet == "cadeauxIdees" {
                //let aGift = aLigne.objectRef as! Gift
                label.attributedText = personne.ideesCadeaux()
                cell.accessoryType = .disclosureIndicator
            }
        }
        
        return cell
    }
    
    //---------------------------------------------------------------------------
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        let strSection = sections[section].sectionTitle
        if strSection.count == 0 {
            return 0
        } else {
            return 28
        }
    }
    
    //---------------------------------------------------------------------------
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = navigationController?.navigationBar.barTintColor
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        header.textLabel?.frame = header.frame
        header.textLabel?.textAlignment = .natural
    }
}


/*override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
 guard let header = view as? UITableViewHeaderFooterView else { return }
 header.textLabel?.textColor = UIColor.red
 header.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
 header.textLabel?.frame = header.frame
 header.textLabel?.textAlignment = .center
 }*/

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




// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
