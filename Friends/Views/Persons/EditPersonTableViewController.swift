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
    var dateTextField: UITextField?
    
    
    //---------------------------------------------------------------------------
    @IBAction func SavePerson(_ sender: Any) {
        dismiss(animated: true, completion: {
            self.person!.save()
            //mise à jour de la vue détail (iPad)
            self.detailView?.person = self.person!
            self.detailView?.configureViewPersonne()
            
            //sélection de la ligne créee ou modifiée
            
            self.masterView?.tableView.reloadData()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if let index = self.masterView?.persons?.index(of: self.person!) {
                    print(index)
                    print((self.masterView?.persons?.count)!)
                    let indexPath = IndexPath(row: index, section: 0)
                    self.masterView?.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .top)
                }
            }
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
        
        let ligneDate = Ligne()
        ligneDate.cellIdentifier = "textFieldCell"
        ligneDate.sujet = "dateNais"
        ligneDate.placeHolder = "Date de naissance"
        
        sectionNomPrenom.lignes.append(ligneNom)
        sectionNomPrenom.lignes.append(lignePrenom)
        sectionNomPrenom.lignes.append(ligneDate)
        
        sections.append(sectionNomPrenom)
        
        //section adresses ---------------------------------------
        let sectionAdresses = Section(title: "Adresse")
        let ligneAdresses = Ligne()
        ligneAdresses.cellIdentifier = "editTextViewCell"
        ligneAdresses.sujet = "addresses"
        
        sectionAdresses.lignes.append(ligneAdresses)
        sections.append(sectionAdresses)
        
        //section phones ---------------------------------------
        let sectionPhones = Section(title: "Téléphones")
        let lignePhones = Ligne()
        lignePhones.cellIdentifier = "editTextViewCell"
        lignePhones.sujet = "phones"
        
        sectionPhones.lignes.append(lignePhones)
        sections.append(sectionPhones)
        
        //section emails ---------------------------------------
        let sectionEmails = Section(title: "Emails")
        let ligneEmails = Ligne()
        ligneEmails.cellIdentifier = "editTextViewCell"
        ligneEmails.sujet = "emails"
        
        sectionEmails.lignes.append(ligneEmails)
        sections.append(sectionEmails)
        
        //section socialProfiles ---------------------------------------
        let sectionSocialProfiles = Section(title: "Réseaux sociaux")
        let ligneSocialProfiles = Ligne()
        ligneSocialProfiles.cellIdentifier = "editTextViewCell"
        ligneSocialProfiles.sujet = "socialProfiles"
        
        sectionSocialProfiles.lignes.append(ligneSocialProfiles)
        sections.append(sectionSocialProfiles)
        
        //section urls ---------------------------------------
        let sectionUrls = Section(title: "URLs")
        let ligneUrls = Ligne()
        ligneUrls.cellIdentifier = "editTextViewCell"
        ligneUrls.sujet = "urls"
        
        sectionUrls.lignes.append(ligneUrls)
        sections.append(sectionUrls)
        
        //section Aime ---------------------------------------
        let sectionAime = Section(title: "Aime")
        let ligneAime = Ligne()
        ligneAime.cellIdentifier = "editTextViewCell"
        ligneAime.sujet = "likeYes"
        
        sectionAime.lignes.append(ligneAime)
        sections.append(sectionAime)
        
        //section AimePas ---------------------------------------
        let sectionAimePas = Section(title: "N'aime pas")
        let ligneAimePas = Ligne()
        ligneAimePas.cellIdentifier = "editTextViewCell"
        ligneAimePas.sujet = "likeNo"
        
        sectionAimePas.lignes.append(ligneAimePas)
        sections.append(sectionAimePas)
        
        //section note ---------------------------------------
        let sectionNote = Section(title: "Note")
        let ligneNote = Ligne()
        ligneNote.cellIdentifier = "editTextViewCell"
        ligneNote.sujet = "note"
        
        sectionNote.lignes.append(ligneNote)
        sections.append(sectionNote)
        
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
        
        //textFieldCell
        if (aLigne.cellIdentifier == "textFieldCell") {
            let textField = cell.viewWithTag(1000) as! BindableUITextField
            textField.sujet = aLigne.sujet
            textField.delegate = self as UITextFieldDelegate
            textField.placeholder = aLigne.placeHolder
            switch aLigne.sujet {
            case "nom":
                textField.text = person!.nom
            case "prenom":
                textField.text = person!.prenom
            case "dateNais":
               // textField.isEnabled = false
                textField.text = strDateFormat(person!.dateNais)
                dateTextField = textField
                let datePickerView:UIDatePicker = UIDatePicker()
                datePickerView.datePickerMode = UIDatePickerMode.date
                if let date = person?.dateNais {
                    datePickerView.date = date
                }
                textField.inputView = datePickerView
                datePickerView.addTarget(self, action: #selector(EditPersonTableViewController.datePickerValueChanged), for: UIControlEvents.valueChanged )
                
                    
                    
          default:
                print("switch default")
            }
        }
        
        
        //editTextViewCell
        if (aLigne.cellIdentifier == "editTextViewCell") {
            let cell = cell as! EditableTextViewCell
            let textView = cell.viewWithTag(1001) as! BindableUITextView
            textView.addBorder()
            textView.sujet = aLigne.sujet
            textView.indexPath = indexPath
            textView.delegate = cell
            //textView.placeholder = aLigne.placeHolder
            switch aLigne.sujet {
            case "addresses":
                textView.text = person!.addresses
            case "phones":
                textView.text = person!.phones
            case "emails":
                textView.text = person!.emails
            case "socialProfiles":
                textView.text = person!.socialProfiles
            case "urls":
                textView.text = person!.urls
            case "likeYes":
                textView.text = person!.likeYes
            case "likeNo":
                textView.text = person!.likeNo
            case "note":
                textView.text = person!.note
            default:
                print("switch default")
            }
            if aLigne.sujet == "addresses" {
                textView.text = person!.addresses
            }
            cell.callBack = {
                textView in
                // update data source
                switch aLigne.sujet{
                case "addresses":
                    self.person!.addresses = textView.text!
                case "phones":
                    self.person!.phones = textView.text!
                case "emails":
                    self.person!.emails = textView.text!
                case "socialProfiles":
                    self.person!.socialProfiles = textView.text!
                case "urls":
                    self.person!.urls = textView.text!
                case "likeYes":
                    self.person!.likeYes = textView.text!
                case "likeNo":
                    self.person!.likeNo = textView.text!
                case "note":
                    self.person!.note = textView.text!

                default:
                    print("switch default")
                }
                // tell table view we're starting layout updates
                tableView.beginUpdates()
                // get current content offset
                var scOffset = tableView.contentOffset
                // get current text view height
                let tvHeight = textView.frame.size.height
                // telll text view to size itself
                textView.sizeToFit()
                // get the difference between previous height and new height (if word-wrap or newline change)
                let yDiff = textView.frame.size.height - tvHeight
                // adjust content offset
                scOffset.y += yDiff
                // update table content offset so edit caret is not covered by keyboard
                tableView.contentOffset = scOffset
                // tell table view to apply layout updates
                tableView.endUpdates()
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
            return 35.0
        }
    }
    
    // MARK: - UIDatePicker
   //---------------------------------------------------------------------------
   // Make a dateFormatter in which format you would like to display the selected date in the textfield.
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        
        dateTextField!.text = dateFormatter.string(from: sender.date)
        person?.dateNais = sender.date
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
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
