//
//  GiftDetailTableViewController.swift
//  Friends
//
//  Created by bernard on 28/05/2018.
//  Copyright © 2018 bernard. All rights reserved.
//

import UIKit
import RealmSwift
import CollieGallery

class GiftDetailTableViewController: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var sections: [Section] = []
    var gift: Gift? {
        didSet {
            //configureViewCadeau()
        }
    }
    var imagePicker: UIImagePickerController!

    @IBAction func addImageButtonClicked(_ sender: UIButton) {
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
        if gift!.imageData != nil {
            // ********
            alert.addAction(UIAlertAction(title: "Afficher en plein écran", style: .default) { _ in
                self.fullScreen()
            })
            
            // ********
            alert.addAction(UIAlertAction(title: "Supprimer la photo", style: .destructive) { _ in
                let realm = RealmDB.getRealm()!
                try! realm.write {
                    self.gift!.imageData = nil
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
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    //---------------------------------------------------------------------------
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            imagePicker.delegate = self
            self.imagePicker.sourceType = UIImagePickerControllerSourceType.camera
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
        
        if gift!.imageData != nil {
            image = UIImage(data: gift!.imageData!)!
        } else {
            image = UIImage(named: "noImage.png")!
        }
        
        let picture = CollieGalleryPicture(image: image)
        pictures.append(picture)
        
        let options = CollieGalleryOptions()
        //options.enableSave = false
        let customAction = CollieGalleryCustomAction(title: "Supprimer l'image", imageName: "") { () -> () in
            
            print("Supprimer image CollieGalleryCustomAction Tapped!")
            let realm = RealmDB.getRealm()!
            try! realm.write {
                self.gift!.imageData = nil
            }
            self.tableView.reloadData()
            self.dismiss(animated:true, completion: nil)
        }
        
        options.customActions = [customAction]
        options.excludedActions = [UIActivityType.assignToContact, UIActivityType.copyToPasteboard, UIActivityType.print, UIActivityType.saveToCameraRoll]
        //options.enableZoom = false
        
        let gallery = CollieGallery(pictures: pictures, options: options)
        
        
        gallery.presentInViewController(self.splitViewController!)
    }
    
    //---------------------------------------------------------------------------
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var image = info[UIImagePickerControllerEditedImage] as! UIImage
        image = resizeImage(image: image, targetSize: CGSize(width: 1536, height: 1536))
        
        if let imageData = UIImageJPEGRepresentation(image, 0.70) {
            
            let realm = RealmDB.getRealm()!
            try! realm.write {
                gift!.imageData = imageData
            }
            //tableView.reloadData()
            dismiss(animated:true, completion: nil)
        }
    }
    
    //---------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(GiftDetailTableViewController.giftEditDetail))
    }
    
    //---------------------------------------------------------------------------
    override func viewWillAppear(_ animated: Bool) {
       // print("viewWillAppear GiftDetailTableViewController")
        configureViewCadeau()
        super.viewWillAppear(animated)
    }
    
   //---------------------------------------------------------------------------
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //---------------------------------------------------------------------------
    @objc func giftEditDetail() {
        //print("giftEditDetail")
        let editViewNav = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditGift")
        let  editView:EditGiftTableViewController = editViewNav.childViewControllers.first as! EditGiftTableViewController
        editView.gift = Gift(gift!) // contructeur de copie
        editView.detailView = self
        let leftNavController = splitViewController!.viewControllers.first as! UINavigationController
        editView.masterView = (leftNavController.topViewController as? GiftViewController)
        
        editViewNav.modalPresentationStyle = UIModalPresentationStyle.formSheet
        editViewNav.preferredContentSize = CGSize(width: 500, height: 800)
        
        self.present(editViewNav, animated: true, completion: nil)
    }

    //---------------------------------------------------------------------------
    func configureViewCadeau() {
        
        //print("configureViewCadeau")
        clearView()
        
        // Update the user interface for the detail item.
        guard let cadeau = gift else { return }
        
        //section nom  ---------------------------------------
        let sectionNom = Section(title: "")
        let ligneNom = Ligne()
        ligneNom.objectRef = cadeau
        ligneNom.cellIdentifier = "CellTitre"
        
        sectionNom.lignes.append(ligneNom)
        sections.append(sectionNom)
        
        //section Offert par ---------------------------------------
        //if !cadeau.donateurs.isEmpty {
        let sectionDonateurs = Section(title: cadeau.donateurs.isEmpty ? "Offert par" : "Offert par")
        for person in cadeau.donateurs.sorted(by: ["nom", "prenom"]) {
            let ligneDonateurs = Ligne()
            ligneDonateurs.sujet = "donateurs"
            ligneDonateurs.objectRef = person
            ligneDonateurs.cellIdentifier = "baseTextCell"
            ligneDonateurs.deletable = true
            sectionDonateurs.lignes.append(ligneDonateurs)
        }
        let ligneAjoutDonateur = Ligne()
        ligneAjoutDonateur.cellIdentifier = "addPersonCell"
        ligneAjoutDonateur.sujet = "addDonateur"
        sectionDonateurs.lignes.append(ligneAjoutDonateur)
        
        sections.append(sectionDonateurs)
        //}
        
        //section Offert à ---------------------------------------
        //if !cadeau.beneficiaires.isEmpty {
        let sectionBeneficiaire = Section(title: cadeau.beneficiaires.isEmpty ? "Offert à" : "Offert à")
        for person in cadeau.beneficiaires.sorted(by: ["nom", "prenom"]) {
            let ligneBeneficiaire = Ligne()
            ligneBeneficiaire.sujet = "beneficiaires"
            ligneBeneficiaire.objectRef = person
            ligneBeneficiaire.cellIdentifier = "baseTextCell"
            ligneBeneficiaire.deletable = true
            sectionBeneficiaire.lignes.append(ligneBeneficiaire)
        }
        let ligneAjoutBeneficiaire = Ligne()
        ligneAjoutBeneficiaire.cellIdentifier = "addPersonCell"
        ligneAjoutBeneficiaire.sujet = "addBeneficiaire"
        sectionBeneficiaire.lignes.append(ligneAjoutBeneficiaire)
        
        sections.append(sectionBeneficiaire)
        //}
        
        //section Idée pour ---------------------------------------
        //if !cadeau.personnesIdee.isEmpty {
        let sectionIdees = Section(title: cadeau.personnesIdee.isEmpty ? "Idée pour" : "Idée pour")
        for person in cadeau.personnesIdee.sorted(by: ["nom", "prenom"]) {
            let ligneIdee = Ligne()
            ligneIdee.sujet = "personneIdee"
            ligneIdee.objectRef = person
            ligneIdee.cellIdentifier = "baseTextCell"
            ligneIdee.deletable = true
            sectionIdees.lignes.append(ligneIdee)
        }
        let ligneAjoutIdee = Ligne()
        ligneAjoutIdee.cellIdentifier = "addPersonCell"
        ligneAjoutIdee.sujet = "addPersonneIdee"
        sectionIdees.lignes.append(ligneAjoutIdee)
        
        sections.append(sectionIdees)
        //}
        
        //section magasin ---------------------------------------
        if !cadeau.magasin.isEmpty {
            let sectionMagasin = Section(title: "Magasin")
            let ligneMagasin = Ligne()
            ligneMagasin.sujet = "magasin"
            ligneMagasin.objectRef = cadeau
            ligneMagasin.cellIdentifier = "baseTextViewCell"
            
            sectionMagasin.lignes.append(ligneMagasin)
            sections.append(sectionMagasin)
        }
        
        //section url ---------------------------------------
        if !cadeau.url.isEmpty {
            let sectionURL = Section(title: "URL")
            let ligneURL = Ligne()
            ligneURL.sujet = "url"
            ligneURL.objectRef = cadeau
            ligneURL.cellIdentifier = "baseTextViewCell"
            
            sectionURL.lignes.append(ligneURL)
            sections.append(sectionURL)
        }
        
        //section prix ---------------------------------------
        if cadeau.prix > 0.0 {
            let sectionPrix = Section(title: "Prix")
            let lignePrix = Ligne()
            lignePrix.sujet = "prix"
            lignePrix.objectRef = cadeau
            lignePrix.cellIdentifier = "baseTextViewCell"
            
            sectionPrix.lignes.append(lignePrix)
            sections.append(sectionPrix)
        }
        
        //section note ---------------------------------------
        if !cadeau.note.isEmpty {
            let sectionNote = Section(title: "Note")
            let ligneNote = Ligne()
            ligneNote.sujet = "note"
            ligneNote.objectRef = cadeau
            ligneNote.cellIdentifier = "baseTextViewCell"
            
            sectionNote.lignes.append(ligneNote)
            sections.append(sectionNote)
        }
        
        tableView.reloadData()
    }
    
    //---------------------------------------------------------------------------
    public func clearView() {
        sections.removeAll(keepingCapacity: false)
        // tableView.reloadData()
        //tableView.setNeedsDisplay()
        //print("ClearView")
    }
    
    //---------------------------------------------------------------------------
    @objc func addDonateurButtonClicked(_ sender:UIButton) {
        //print("addDonateurButtonClicked")
        
        let viewNav = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "personPicker")
        let  personPicker:PersonPickerTableViewController = viewNav.childViewControllers.first as! PersonPickerTableViewController
        personPicker.gift = gift
        personPicker.operation = "addDonateurs"
        personPicker.detailView = self
        personPicker.title = "Ajout donateurs"
        
        viewNav.modalPresentationStyle = UIModalPresentationStyle.formSheet
        viewNav.preferredContentSize = CGSize(width: 500, height: 800)
        
        self.present(viewNav, animated: true, completion: nil)
    }
    
    //---------------------------------------------------------------------------
    @objc func addBeneficiaireButtonClicked(_ sender:UIButton) {
        //print("addBeneficiaireButtonClicked")
        let viewNav = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "personPicker")
        let  personPicker:PersonPickerTableViewController = viewNav.childViewControllers.first as! PersonPickerTableViewController
        personPicker.gift = gift
        personPicker.operation = "addBeneficiaires"
        personPicker.detailView = self
        personPicker.title = "Ajout bénéficiaires"

        viewNav.modalPresentationStyle = UIModalPresentationStyle.formSheet
        viewNav.preferredContentSize = CGSize(width: 500, height: 800)
        
        self.present(viewNav, animated: true, completion: nil)
    }
    
    //---------------------------------------------------------------------------
    @objc func addIdeeButtonClicked(_ sender:UIButton) {
        //print("addIdeeButtonClicked")
        
        let viewNav = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "personPicker")
        let  personPicker:PersonPickerTableViewController = viewNav.childViewControllers.first as! PersonPickerTableViewController
        personPicker.gift = gift
        personPicker.operation = "addIdees"
        personPicker.detailView = self
        personPicker.title = "Ajout idée pour"

        viewNav.modalPresentationStyle = UIModalPresentationStyle.formSheet
        viewNav.preferredContentSize = CGSize(width: 500, height: 800)
        
        self.present(viewNav, animated: true, completion: nil)
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
        
        guard let cadeau = gift else { return cell }
        
        //Titre  photo date
        if (aLigne.cellIdentifier == "CellTitre") {
            let labelNom = cell.viewWithTag(1001) as! UILabel
            labelNom.text = cadeau.nom
            let labelJourMois = cell.viewWithTag(1003) as! UILabel
            labelJourMois.text = strDateFormat(cadeau.getDate())

            
            //image
            var image = UIImage()
            let imageView = cell.viewWithTag(1000) as! UIImageView
            imageView.image = nil
            if cadeau.imageData != nil {
                image = UIImage(data: cadeau.imageData!)!
            } else {
                image = UIImage(named: "noImage.png")!
            }
            //affectation de l'image réduite
            imageView.backgroundColor = UIColor.white
            imageView.image = scaledImageRound(image, dim: 90, borderWidth: 3.0, borderColor: UIColor.white, imageView: imageView)
        }
        
        if (aLigne.cellIdentifier == "baseTextViewCell") {
            let textView = cell.viewWithTag(1000) as! UITextView
            
            switch aLigne.sujet {
            case "magasin":
                textView.attributedText = attrStr(str: cadeau.magasin)
            case "url":
                textView.attributedText = attrStr(str: cadeau.url)
            case "prix":
                textView.attributedText = attrStr(str: "\(String(cadeau.prix)) €")
            case "note":
                textView.attributedText = attrStr(str: cadeau.note)
                
            default:
                print("default switch")
            }
        }
        
        if (aLigne.cellIdentifier == "baseTextCell") {
            let label = cell.viewWithTag(1000) as! UILabel
            
            //Donateurs
            if aLigne.sujet == "donateurs" {
                let aDonateur = aLigne.objectRef as! Person
                label.text = aDonateur.fullName
            }
            
            //Bénéficiaires
            if aLigne.sujet == "beneficiaires" {
                let aBeneficiaire = aLigne.objectRef as! Person
                label.text = aBeneficiaire.fullName
            }
            
            //Idée pour
            if aLigne.sujet == "personneIdee" {
                let aPersonneIdee = aLigne.objectRef as! Person
                label.text = aPersonneIdee.fullName
            }
        }
        
        if (aLigne.cellIdentifier == "addPersonCell") {
            let label = cell.viewWithTag(1000) as! UILabel
            let addButton = cell.viewWithTag(1100) as? UIButton
            
            //Donateurs
            if aLigne.sujet == "addDonateur" {
                label.text = "Ajouter un donateur"
                //le bouton add --------------------------------------------------
                addButton!.addTarget(self, action: #selector(GiftDetailTableViewController.addDonateurButtonClicked(_:)), for: UIControlEvents.touchUpInside)
                
            }
            
            //Bénéficiaires
            if aLigne.sujet == "addBeneficiaire" {
                label.text = "Ajouter un bénéficiaire"
                addButton!.addTarget(self, action: #selector(GiftDetailTableViewController.addBeneficiaireButtonClicked(_:)), for: UIControlEvents.touchUpInside)
          }
            
            //Idée pour
            if aLigne.sujet == "addPersonneIdee" {
                label.text = "Ajouter comme idée pour"
                addButton!.addTarget(self, action: #selector(GiftDetailTableViewController.addIdeeButtonClicked(_:)), for: UIControlEvents.touchUpInside)
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
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let aLigne = sections[indexPath.section].lignes[indexPath.row]
        if aLigne.sujet == "addDonateur" {
            addDonateurButtonClicked(UIButton())
        }
        else if aLigne.sujet == "addBeneficiaire" {
            addBeneficiaireButtonClicked(UIButton())
        }
        else if aLigne.sujet == "addPersonneIdee" {
            addIdeeButtonClicked(UIButton())
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
    
    //---------------------------------------------------------------------------
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        //print("commit")
        let aLigne = sections[indexPath.section].lignes[indexPath.row]
        let aPerson = aLigne.objectRef as! Person
        let realm = RealmDB.getRealm()!

        try! realm.write {
            switch aLigne.sujet {
            case "donateurs":
                aPerson.cadeauxOfferts.remove(at: aPerson.cadeauxOfferts.index(of: gift!)!)
            case "beneficiaires":
                aPerson.cadeauxRecus.remove(at: aPerson.cadeauxRecus.index(of: gift!)!)
            case "personneIdee":
                aPerson.cadeauxIdees.remove(at: aPerson.cadeauxIdees.index(of: gift!)!)
            default:
                print("switch default commit GiftDetailTableViewController")
            }
        }
        
        configureViewCadeau()
    }
    
    //---------------------------------------------------------------------------
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let aLigne = sections[indexPath.section].lignes[indexPath.row]
        // Seules les personnes liées peuvent être supprimées par glissement
        return aLigne.deletable
    }
    
    
    //---------------------------------------------------------------------------
   // MARK: - Navigation
    //---------------------------------------------------------------------------

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    //---------------------------------------------------------------------------
    
    //---------------------------------------------------------------------------
    
    
}
