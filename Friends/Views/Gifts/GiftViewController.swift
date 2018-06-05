//
//  GiftTableViewController.swift
//  Friends
//
//  Created by bernard on 28/05/2018.
//  Copyright © 2018 bernard. All rights reserved.
//

import UIKit
import RealmSwift

class GiftViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private var gifts: Results<Gift>?
    // private var filteredCandies: Results<Person>?
    let searchController = UISearchController(searchResultsController: nil)
    var realm: Realm?
    
    @IBOutlet weak var tableViewMasterCadeaux: UITableView!
    //---------------------------------------------------------------------------
    @IBAction func addGift(_ sender: Any) {
        print("addGift")
    }

    //---------------------------------------------------------------------------
    @IBAction func nomEditChange(_ sender: UITextField) {
        if sender.text!.count >= 2 {
            print("nomEditchange")
        }
  }
    //---------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        realm = try! Realm()
        gifts = realm!.objects(Gift.self).sorted(by: ["name"])
        
    }
    
    //---------------------------------------------------------------------------
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gifts?.count ?? 0

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        print("commit")
        let gift = gifts![indexPath.row]
        try! realm?.write {
            realm?.delete(gift)
            tableView.reloadData()
        }

    }

    //---------------------------------------------------------------------------
    /*func filterContentForSearchText(_ searchText: String, scope: String = "All") {
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
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addGift" {
            segue.destination.title = "Ajout cadeau"
        }
    }
}

//---------------------------------------------------------------------------
/*extension GiftTableViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        //let searchBar = searchController.searchBar
        //let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchController.searchBar.text!, scope: "")
    }
}*/

