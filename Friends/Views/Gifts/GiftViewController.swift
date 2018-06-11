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

    public var gifts: Results<Gift>?
    private var itemsToken: NotificationToken?
    
    @IBOutlet weak var tableViewMasterCadeaux: UITableView!
    //---------------------------------------------------------------------------
    @IBAction func addGift(_ sender: Any) {
        print("addGift")
        let editViewNav = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditGift")
        let  editView:EditGiftTableViewController = editViewNav.childViewControllers.first as! EditGiftTableViewController
        editView.gift = Gift() // personne vierge
        editView.masterView = self
        let split = self.splitViewController as? GiftsSplitViewController
        let detail = split?.detailViewController?.viewControllers.first as? GiftDetailTableViewController
        editView.detailView = detail
        
        editViewNav.modalPresentationStyle = UIModalPresentationStyle.formSheet
        editViewNav.preferredContentSize = CGSize(width: 500, height: 800)
        
        self.present(editViewNav, animated: true, completion: nil)
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
        
        let realm = RealmDB.getRealm()!
        gifts = realm.objects(Gift.self).sorted(by: ["nom"])
        
        if gifts!.count > 0 {
            let indexPath = IndexPath(row: 0, section: 0)
            tableViewMasterCadeaux.selectRow(at: indexPath, animated: true, scrollPosition: .top)
            if UIDevice().userInterfaceIdiom == .pad { // iPad
                self.performSegue(withIdentifier: "giftMasterDetail", sender: self)
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
        
        itemsToken = gifts?.observe( { change in
            //print("itemToken viewWillAppear GiftViewController")
            switch change {
            case .initial:
                print()
            default:
                self.tableViewMasterCadeaux.reloadData()
            }
        })
        
        super.viewWillAppear(animated)
        
    }
    
    //---------------------------------------------------------------------------
    override func viewWillDisappear(_ animated: Bool) {
        //print("itemsToken?.invalidate viewWillDisappear GiftViewController")
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
        return gifts?.count ?? 0

    }
    
    //---------------------------------------------------------------------------
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "giftCell", for: indexPath)
        
        let gift = gifts![indexPath.row]
        
        let labelNom = cell.viewWithTag(1001) as! UILabel
        labelNom.text = gift.nom
        
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
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        //print("commit")
        let gift = gifts![indexPath.row]
        let realm = RealmDB.getRealm()!
        try! realm.write {
            realm.delete(gift)
            //tableView.reloadData()
        }
        
        // il faut attendre un peu pour que la sélection se fasse !!!
        if UIDevice().userInterfaceIdiom == .pad { // iPad
            var newIndexPath = IndexPath(row: 0, section: 0)
            
            // il faut attendre un peu pour que la sélection se fasse !!!
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                if !self.gifts!.isEmpty {
                    newIndexPath.row = indexPath.row - 1
                    if newIndexPath.row == -1 {
                        newIndexPath.row = 0
                    }
                    tableView.selectRow(at: newIndexPath, animated: true, scrollPosition: .top)
                    
                    self.performSegue(withIdentifier: "giftMasterDetail", sender: self)
                }
            }
        }
    }
    
    //---------------------------------------------------------------------------
    /*func filterContentForSearchText(_ searchText: String, scope: String = "All") {
     if searchBarIsEmpty() {
     gifts = realm!.objects(Gift.self).sorted(by: ["name"])
        } else {
            let strSearch = searchText.lowercased()
            gifts = realm!.objects(Gift.self).filter("nom contains[c] %@ ", strSearch)
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
    //---------------------------------------------------------------------------
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "giftMasterDetail" {
            if let indexPath = tableViewMasterCadeaux.indexPathForSelectedRow {
                let controller = (segue.destination as! UINavigationController).topViewController as! GiftDetailTableViewController
                controller.gift = gifts![indexPath.row]
                
            }
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

