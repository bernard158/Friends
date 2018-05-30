//
//  GiftTableViewController.swift
//  Friends
//
//  Created by bernard on 28/05/2018.
//  Copyright © 2018 bernard. All rights reserved.
//

import UIKit
import RealmSwift

class GiftTableViewController: UITableViewController {

    private var gifts: Results<Gift>?
    // private var filteredCandies: Results<Person>?
    let searchController = UISearchController(searchResultsController: nil)
    var realm: Realm?
    
    //---------------------------------------------------------------------------
    @IBAction func addGift(_ sender: Any) {
        
    }

    //---------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //self.navigationItem.rightBarButtonItem = self.editButtonItem
        realm = try! Realm()
        gifts = realm!.objects(Gift.self).sorted(by: ["name"])
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "FirstName or nom Search"
        //navigationItem.searchController = searchController
        
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            tableView.tableHeaderView = searchController.searchBar
        }
        
        /*
         definesPresentationContext = true
         
         // Setup the Scope Bar
         searchController.searchBar.scopeButtonTitles = ["All", "Chocolate", "Hard", "Other"]
         searchController.searchBar.delegate = self
         
         // Setup the search footer
         tableView.tableFooterView = searchFooter
         */
        
        searchController.searchBar.backgroundColor = UIColor.white
        
        //searchController.searchBar.frame.origin.y = searchController.searchBar.frame.origin.y + 5
        
        for subView in searchController.searchBar.subviews {
            
            for subViewOne in subView.subviews {
                if let textField = subViewOne as? UITextField {
                    //use the code below if you want to change the color of placeholder
                    let textFieldInsideUISearchBarLabel = textField.value(forKey: "placeholderLabel") as? UILabel
                    textFieldInsideUISearchBarLabel?.adjustsFontSizeToFitWidth = true
                }
            }
        }

    }
    
    //---------------------------------------------------------------------------
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
        return gifts?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        print("commit")
        let gift = gifts![indexPath.row]
        try! realm?.write {
            realm?.delete(gift)
            tableView.reloadData()
        }
    }
    
   //---------------------------------------------------------------------------
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "giftCell", for: indexPath)
        
        let gift = gifts![indexPath.row]
        
        let labelNom = cell.viewWithTag(1001) as! UILabel
        labelNom.text = gift.name
        
        //Image
        var image = UIImage()
        let imageView = cell.viewWithTag(1000) as! UIImageView
        imageView.contentMode = .scaleAspectFit
        imageView.image = nil
        if gift.imageData != nil {
            image = UIImage(data: gift.imageData!)!
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
            gifts = realm!.objects(Gift.self).sorted(by: ["name"])
        } else {
            let strSearch = searchText.lowercased()
            gifts = realm!.objects(Gift.self).filter("name contains[c] %@ ", strSearch)
        }
        tableView.reloadData()
    }
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!searchBarIsEmpty() || searchBarScopeIsFiltering)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addGift" {
            segue.destination.title = "Add Gift"
        }
    }
}

//---------------------------------------------------------------------------
extension GiftTableViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        //let searchBar = searchController.searchBar
        //let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchController.searchBar.text!, scope: "")
    }
}

