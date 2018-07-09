//
//  PersonsTableViewController.swift
//  Friends
//
//  Created by bernard on 24/05/2018.
//  Copyright © 2018 bernard. All rights reserved.
//

import UIKit
import RealmSwift

class PersonsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    public var persons: Results<Person>?
    private var itemsToken: NotificationToken?
    
    @IBOutlet weak var tableViewMasterPersons: UITableView!
    @IBOutlet weak var searchField: UITextField!
    
    @IBAction func showAll(_ sender: Any) {
        searchField.text = ""
        searchField.resignFirstResponder()
        nomEditChange(searchField)
    }
    //---------------------------------------------------------------------------
    @IBAction func nomEditChange(_ sender: UITextField) {
        let strSearch = sender.text!
        if (strSearch.count >= 2) || (strSearch.count == 0){
            //print("nomEditchange")
            filterContentForSearchText(strSearch)
        }
   }
    //---------------------------------------------------------------------------
    @IBAction func addPerson(_ sender: Any) {
        print("add person")
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // ********
        alert.addAction(UIAlertAction(title: "Créer une nouvelle personne", style: .default) { _ in
            print("new person")
            let editViewNav = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditPerson")
            let  editView:EditPersonTableViewController = editViewNav.childViewControllers.first as! EditPersonTableViewController
            editView.person = Person() // personne vierge
            editView.masterView = self
            let split = self.splitViewController as? PersonsSplitViewController
            let detail = split?.detailViewController?.viewControllers.first as? PersonDetailTableViewController
            editView.detailView = detail
            
            editViewNav.modalPresentationStyle = UIModalPresentationStyle.formSheet
            editViewNav.preferredContentSize = CGSize(width: 500, height: 800)
            
            self.present(editViewNav, animated: true, completion: nil)
            
        })
        
        // ********
        alert.addAction(UIAlertAction(title: "Importer des contacts", style: .default) { _ in
            let importContacts = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ContactsModal")
            //let  importContacts:contactsTableViewController = importContacts.childViewControllers.first as! contactsTableViewController
            //let leftNavController = splitViewController!.viewControllers.first as! UINavigationController
            //editView.masterView = (leftNavController.topViewController as? PersonsTableViewController)
            
            importContacts.modalPresentationStyle = UIModalPresentationStyle.formSheet
            importContacts.preferredContentSize = CGSize(width: 500, height: 800)
            
            self.present(importContacts, animated: true, completion: nil)
            
        })
        
        // ********
        alert.addAction(UIAlertAction(title: "Annuler", style: .cancel) { _ in
            
        })
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.barButtonItem = sender as? UIBarButtonItem
        }
        present(alert, animated: true)
    }
    //---------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let realm = RealmDB.getRealm()!
        persons = realm.objects(Person.self).sorted(byKeyPath: "nomPrenomUCD")
        if persons!.count > 0 {
            let indexPath = IndexPath(row: 0, section: 0)
            tableViewMasterPersons.selectRow(at: indexPath, animated: true, scrollPosition: .top)
            if UIDevice().userInterfaceIdiom == .pad { // iPad
                self.performSegue(withIdentifier: "personMasterDetail", sender: self)
            }
        }
    }
    
    //---------------------------------------------------------------------------
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //---------------------------------------------------------------------------
    override func viewWillAppear(_ animated: Bool) {
        // print("viewWillAppear PersonsTableViewController")
        /* if splitViewController!.isCollapsed {
         if let selectionIndexPath = tableView.indexPathForSelectedRow {
         tableView.deselectRow(at: selectionIndexPath, animated: animated)
         }
         }*/
        /*let searchBar = searchController.searchBar
         //searchController.isActive = true
         searchBar.text = currentSearchbarText
         updateSearchResults(for: searchController)
         tableView.reloadData()
         
         if UIDevice().userInterfaceIdiom == .phone { // iPhone
         // SearchBar text
         searchBar.barStyle = .blackTranslucent
         let textFieldInsideUISearchBar = searchBar.value(forKey: "searchField") as? UITextField
         textFieldInsideUISearchBar?.font = textFieldInsideUISearchBar?.font?.withSize(15)
         
         // SearchBar placeholder
         let textFieldInsideUISearchBarLabel = textFieldInsideUISearchBar!.value(forKey: "placeholderLabel") as? UILabel
         textFieldInsideUISearchBarLabel?.textColor = UIColor.gray
         
         } else { // iPad
         searchController.searchBar.backgroundColor = UIColor.white
         }
         for subView in searchController.searchBar.subviews {
         for subViewOne in subView.subviews {
         if let textField = subViewOne as? UITextField {
         //textField.textColor = UIColor.white
         //use the code below if you want to change placeholder
         let textFieldInsideUISearchBarLabel = textField.value(forKey: "placeholderLabel") as? UILabel
         textFieldInsideUISearchBarLabel?.adjustsFontSizeToFitWidth = true
         }
         }
         }*/
        itemsToken = persons?.observe( { change in
            //print("itemToken")
            switch change {
            case .initial:
                print()
            default:
                print()
                //self.tableViewMasterPersons.reloadData()
            }
        })
        
        self.tableViewMasterPersons.reloadData()
        super.viewWillAppear(animated)
    }
    
    //---------------------------------------------------------------------------
    override func viewWillDisappear(_ animated: Bool) {
        //print("viewWillDisappear PersonsTableViewController")
        itemsToken?.invalidate()
    }
    //---------------------------------------------------------------------------
    // MARK: - Table view data source
    
    //---------------------------------------------------------------------------
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    //---------------------------------------------------------------------------
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return persons?.count ?? 0
    }
    
    //---------------------------------------------------------------------------
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        //print("commit")
        let alert = UIAlertController(title: "Suppression", message: "Voulez-vous réellement supprimer cette personne ?", preferredStyle: .alert)
        
        // ********
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            let person = self.persons![indexPath.row]
            let realm = RealmDB.getRealm()!
            try! realm.write {
                realm.delete(person)
            }
            tableView.reloadData()
            alert.dismiss(animated: true, completion: nil)
        })
        alert.addAction(UIAlertAction(title: "Annuler", style: .default) { _ in
            alert.dismiss(animated: true, completion: nil)
            return
        })
        present(alert, animated: true)
        
        if UIDevice().userInterfaceIdiom == .pad { // iPad
            var newIndexPath = IndexPath(row: 0, section: 0)
            
            // il faut attendre un peu pour que la sélection se fasse !!!
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                if !self.persons!.isEmpty {
                    newIndexPath.row = indexPath.row - 1
                    if newIndexPath.row == -1 {
                        newIndexPath.row = 0
                    }
                    tableView.selectRow(at: newIndexPath, animated: true, scrollPosition: .top)
                    
                    self.performSegue(withIdentifier: "personMasterDetail", sender: self)
                }
            }
        } else {
            tableView.reloadData()
        }
    }
    
    //---------------------------------------------------------------------------
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "personCell", for: indexPath)
        
        let person = persons![indexPath.row]
        
        let labelNom = cell.viewWithTag(1001) as! UILabel
        labelNom.text = person.fullName
        
        //Image
        var image = UIImage()
        let imageView = cell.viewWithTag(1000) as! UIImageView
        imageView.contentMode = .scaleAspectFit
        imageView.image = nil
        if person.imageData != nil {
            image = UIImage(data: person.imageData!)!
        } else {
            image = UIImage(named: "noImage.png")!
        }
        //affectation de l'image réduite
        imageView.backgroundColor = UIColor.white
        //imageView.image = scaledImageRound(image, dim: 44, borderWidth: 2.0, borderColor: UIColor.white, imageView: imageView)
        imageView.image = image
        
        
        return cell
    }
    
    //---------------------------------------------------------------------------
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        let realm = RealmDB.getRealm()!
        if (searchText.count == 0) {
            persons = realm.objects(Person.self).sorted(byKeyPath: "nomPrenomUCD")
        } else {
            let strSearch = searchText.lowercased()
            persons = realm.objects(Person.self).filter("nom contains[c] %@ OR prenom contains[c] %@", strSearch, strSearch).sorted(byKeyPath: "nomPrenomUCD")
        }
        tableViewMasterPersons.reloadData()
        
    }
    
    //---------------------------------------------------------------------------
    // MARK: - Navigation
    //---------------------------------------------------------------------------
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "personMasterDetail" {
            if let indexPath = tableViewMasterPersons.indexPathForSelectedRow {
                let controller = (segue.destination as! UINavigationController).topViewController as! PersonDetailTableViewController
                controller.person = persons![indexPath.row]
            }
        }
    }
    
}

//---------------------------------------------------------------------------

