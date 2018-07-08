//
//  EditGiftTableViewController.swift
//  Friends
//
//  Created by bernard on 11/06/2018.
//  Copyright © 2018 bernard. All rights reserved.
//

import UIKit

class EditGiftTableViewController: UITableViewController, UITextFieldDelegate, UITextViewDelegate {
    
    public var gift: Gift? // reçoit un  objec détaché de realm
    public var detailView: GiftDetailTableViewController?
    public var masterView: GiftViewController?
    var sections: [Section] = []
    var dateTextField: UITextField?
    
    //---------------------------------------------------------------------------
    @IBAction func SaveGift(_ sender: Any) {
        dismiss(animated: true, completion: {
            self.gift!.save()
            //mise à jour de la vue détail (iPad)
            self.detailView?.gift = self.gift!
            self.detailView?.configureViewCadeau()
            //print(self.detailView)

            //sélection de la ligne créee ou modifiée
            
            self.masterView?.tableViewMasterCadeaux.reloadData()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if let index = self.masterView?.gifts!.index(of: self.gift!) {
                    print(index)
                    print((self.masterView?.gifts?.count)!)
                    let indexPath = IndexPath(row: index, section: 0)
                    self.masterView?.tableViewMasterCadeaux.selectRow(at: indexPath, animated: true, scrollPosition: .top)
                    self.masterView?.performSegue(withIdentifier: "giftMasterDetail", sender: self.masterView)
                }
            }
        })
    }
    //---------------------------------------------------------------------------
    @IBAction func cancelEditGift(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //---------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        configureViewCadeau()
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
   /* override func viewWillAppear(_ animated: Bool) {
        //print("viewWillAppear PersonDetailTableViewController")
        configureViewCadeau()
        super.viewWillAppear(animated)
    }*/
    
    //---------------------------------------------------------------------------
    func configureViewCadeau() {
        
        //print("configureViewCadeau")
        clearView()
        
        // Update the user interface for the detail item.
        
        //section nom prénom ---------------------------------------
        let sectionNom = Section(title: "")
        let ligneNom = Ligne()
        ligneNom.cellIdentifier = "giftTextFieldCell"
        ligneNom.sujet = "nom"
        ligneNom.placeHolder = "Nom du cadeau"
        
        let ligneDate = Ligne()
        ligneDate.cellIdentifier = "giftTextFieldCell"
        ligneDate.sujet = "date"
        ligneDate.placeHolder = "Date"
        
        sectionNom.lignes.append(ligneNom)
        sectionNom.lignes.append(ligneDate)
        
        sections.append(sectionNom)
        
        //section Magasin ---------------------------------------
        let sectionMagasin = Section(title: "Magasin")
        let ligneMagasin = Ligne()
        ligneMagasin.cellIdentifier = "giftEditTextViewCell"
        ligneMagasin.sujet = "magasin"
        
        sectionMagasin.lignes.append(ligneMagasin)
        sections.append(sectionMagasin)
        
        //section urls ---------------------------------------
        let sectionUrls = Section(title: "URL")
        let ligneUrls = Ligne()
        ligneUrls.cellIdentifier = "giftEditTextViewCell"
        ligneUrls.sujet = "urls"
        
        sectionUrls.lignes.append(ligneUrls)
        sections.append(sectionUrls)
        
        //section note ---------------------------------------
        let sectionNote = Section(title: "Note")
        let ligneNote = Ligne()
        ligneNote.cellIdentifier = "giftEditTextViewCell"
        ligneNote.sujet = "note"
        
        sectionNote.lignes.append(ligneNote)
        sections.append(sectionNote)
        
    }
    //---------------------------------------------------------------------------
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sections.count
    }
    
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
        
        //textFieldCell
        if (aLigne.cellIdentifier == "giftTextFieldCell") {
            let textField = cell.viewWithTag(1000) as! BindableUITextField
            textField.sujet = aLigne.sujet
            textField.delegate = self as UITextFieldDelegate
            textField.placeholder = aLigne.placeHolder
            switch aLigne.sujet {
            case "nom":
                textField.text = gift!.nom
            case "date":
                // textField.isEnabled = false
                textField.text = strDateFormat(gift!.date)
                dateTextField = textField
                let datePickerView:UIDatePicker = UIDatePicker()
                datePickerView.datePickerMode = UIDatePickerMode.date
                if let date = gift?.date {
                    datePickerView.date = date
                }
                textField.inputView = datePickerView
                datePickerView.addTarget(self, action: #selector(EditPersonTableViewController.datePickerValueChanged), for: UIControlEvents.valueChanged )
                
            default:
                print("switch default 02")
            }
        }
        
        
        //editTextViewCell
        if (aLigne.cellIdentifier == "giftEditTextViewCell") {
            let cell = cell as! EditableTextViewCell
            let textView = cell.viewWithTag(1001) as! BindableUITextView
            textView.addBorder()
            textView.sujet = aLigne.sujet
            textView.indexPath = indexPath
            textView.delegate = cell
            //textView.placeholder = aLigne.placeHolder
            switch aLigne.sujet {
            case "magasin":
                textView.text = gift!.magasin
            case "urls":
                textView.text = gift!.url
            case "note":
                textView.text = gift!.note
            default:
                print("switch default 03")
            }
            cell.callBack = {
                textView in
                // update data source
                switch aLigne.sujet{
                case "magasin":
                    self.gift!.magasin = textView.text!
                case "urls":
                    self.gift!.url = textView.text!
                case "note":
                    self.gift!.note = textView.text!
                    
                default:
                    print("switch default 04")
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
        gift?.date = sender.date
    }
    
    
    // MARK: - UITextField delegate
    //---------------------------------------------------------------------------
    func textFieldDidEndEditing(_ textField: UITextField) {
        //print("textFieldDidEndEditing")
        let bindableTextField = textField as! BindableUITextField
        if !bindableTextField.sujet.isEmpty {
            switch bindableTextField.sujet {
            case "nom":
                gift!.nom = textField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            case "date":
                print()
                
            default:
                print("switch default textFieldDidEndEditing EditGiftTableViewController")
            }
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
