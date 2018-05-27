//
//  contactsTableViewController.swift
//  Friends
//
//  Created by bernard on 25/05/2018.
//  Copyright © 2018 bernard. All rights reserved.
//

import UIKit

class contactsTableViewController: UITableViewController {
    
    var contacts: [ContactIOS]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        //tableView.rowHeight = UITableViewAutomaticDimension
        //tableView.estimatedRowHeight = 44
        
        contacts = ImportContacts.loadCNContacts()
        contacts = contacts?.sorted {
            $0.lastFirstName < $1.lastFirstName
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return contacts!.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath)
        let fullNameLabelTag = 1000
        let importButtonTag = 1001
        let firstLineLabelTag = 1002
        let imageViewTag = 1003
        //cell.tag = indexPath.row
        
        let aContact = contacts![indexPath.row]
        
        let fullNameLabel = cell.viewWithTag(fullNameLabelTag) as! UILabel
        fullNameLabel.text = aContact.fullName
        
        //les adresses --------------------------------------------------
        let firstLineLabel = cell.viewWithTag(firstLineLabelTag) as! UILabel
        firstLineLabel.text = aContact.adresses()
        
        //pour éviter que la photo soit tronquée si il n'y a qu'une ligne (ex : Jean-louis)
        if (firstLineLabel.text?.count == 0) && (aContact.contact.imageData != nil) {
            firstLineLabel.text = " "
        }
        
        //le bouton import --------------------------------------------------
        let importButton = cell.viewWithTag(importButtonTag) as? UIButton
        let isAlreadyImported = aContact.isAlreadyImported
        importButton!.isEnabled = !isAlreadyImported
        if(isAlreadyImported) {
            importButton!.setTitle("imported", for: .normal)
            importButton!.removeTarget(nil, action: nil, for: .allEvents)
        } else {
            importButton!.setTitle("import", for: .normal)
            importButton!.addTarget(self, action: #selector(contactsTableViewController.importButtonClicked(_:)), for: UIControlEvents.touchUpInside)
        }
        
        //l'image' --------------------------------------------------
        let imageView = cell.viewWithTag(imageViewTag) as? UIImageView
        imageView!.contentMode = .scaleAspectFit
        if let imageData = aContact.contact.imageData {
            let image = UIImage(data: imageData as Data)
            imageView?.image = image!
        } else {
            imageView?.image = nil
        }
        return cell
    }
    
    @objc func importButtonClicked(_ sender:UIButton) {
        //print("importButtonClicked")
        
        if let superview = sender.superview, let cell = superview.superview as? UITableViewCell {
            if let indexPath = tableView.indexPath(for: cell) {
                let aContact = contacts![indexPath.row]
                //print(aContact.contact)
                aContact.isImported = true
                aContact.addToRealm()
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
