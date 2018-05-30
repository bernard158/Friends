//
//  PersonsTableViewController.swift
//  Friends
//
//  Created by bernard on 24/05/2018.
//  Copyright © 2018 bernard. All rights reserved.
//

import UIKit
import RealmSwift

class PersonsTableViewController: UITableViewController {
    
    private var persons: Results<Person>?
    // private var filteredCandies: Results<Person>?
    let searchController = UISearchController(searchResultsController: nil)
    var realm: Realm?
    var okForReload = true
    
    @IBAction func addPerson(_ sender: Any) {
        print("add person")
    }
    //---------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //self.navigationItem.rightBarButtonItem = self.editButtonItem
        realm = try! Realm()
        persons = realm!.objects(Person.self).sorted(by: ["nom", "prenom"])
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "First Name or Last Name Search"
        //navigationItem.searchController = searchController
        
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            tableView.tableHeaderView = searchController.searchBar
        }
        
        searchController.searchBar.setValue("Annuler", forKey: "cancelButtonText")
        
        
        /*
         definesPresentationContext = true
         
         // Setup the Scope Bar
         searchController.searchBar.scopeButtonTitles = ["All", "Chocolate", "Hard", "Other"]
         searchController.searchBar.delegate = self
         
         // Setup the search footer
         tableView.tableFooterView = searchFooter
         */
        
        
        //searchController.searchBar.frame.origin.y = searchController.searchBar.frame.origin.y + 5
        
        //searchController.searchBar.isHidden = false
        
    }
    
    //---------------------------------------------------------------------------
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //---------------------------------------------------------------------------
    override func viewWillAppear(_ animated: Bool) {
        if splitViewController!.isCollapsed {
            if let selectionIndexPath = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: selectionIndexPath, animated: animated)
            }
        }
        okForReload = true
        //print("view will appear okForReload = \(okForReload)")
        tableView.reloadData()
        
        let searchBar = searchController.searchBar
        //navigationController?.isNavigationBarHidden = true
        //searchController.searchBar.isHidden = true
        //searchController.searchBar.backgroundColor = UIColor.white
        
        if UIDevice().userInterfaceIdiom == .phone { // iPhone
            // SearchBar text
            
            searchBar.barStyle = .blackTranslucent
            let textFieldInsideUISearchBar = searchBar.value(forKey: "searchField") as? UITextField
            //textFieldInsideUISearchBar?.textColor = UIColor.red
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
        }
        //searchController.searchBar.isHidden = false
        
        
        super.viewWillAppear(animated)
    }
    
    //---------------------------------------------------------------------------
    override func viewDidAppear(_ animated: Bool) {
        //searchController.searchBar.isHidden = false
        //navigationController?.isNavigationBarHidden = false
    }
    
    //---------------------------------------------------------------------------
    // MARK: - Table view data source
    
    //---------------------------------------------------------------------------
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    //---------------------------------------------------------------------------
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return persons?.count ?? 0
    }
    
    //---------------------------------------------------------------------------
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        print("commit")
        let person = persons![indexPath.row]
        try! realm?.write {
            realm?.delete(person)
            tableView.reloadData()
        }
    }
    
    //---------------------------------------------------------------------------
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
        if searchBarIsEmpty() {
            persons = realm!.objects(Person.self).sorted(by: ["nom", "prenom"])
        } else {
            let strSearch = searchText.lowercased()
            persons = realm!.objects(Person.self).filter("nom contains[c] %@ OR prenom contains[c] %@", strSearch, strSearch)
        }
        if okForReload {
            tableView.reloadData()
        }
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!searchBarIsEmpty() || searchBarScopeIsFiltering)
    }
    
    //---------------------------------------------------------------------------
    // MARK: - Navigation
    
    //---------------------------------------------------------------------------
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "personMasterDetail" {
            
            //print("segue personMasterDetail")
            if let indexPath = tableView.indexPathForSelectedRow {
                let controller = (segue.destination as! UINavigationController).topViewController as! PersonDetailTableViewController
                controller.person = persons![indexPath.row]
                
                //Sur un iphone, l'app recharge la liste complète avant de basculer sur l'écran Détail.
                // Pour éviter le clignotement d'écran occasionné, on bloque le reloadData
                if UIDevice().userInterfaceIdiom == .phone { // iPhone
                    okForReload = false
                    //print("prepare segue okForReload = \(okForReload)")
                    searchController.isActive = false
                } else { //iPad
                    //on masque le clavier
                    searchController.searchBar.resignFirstResponder()
                    
                }
                
            }
        }
    }
    
}

//---------------------------------------------------------------------------
extension PersonsTableViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        //let searchBar = searchController.searchBar
        //let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchController.searchBar.text!, scope: "")
    }
}

