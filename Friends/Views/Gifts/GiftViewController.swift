//
//  GiftTableViewController.swift
//  Friends
//
//  Created by bernard on 28/05/2018.
//  Copyright © 2018 bernard. All rights reserved.
//

import UIKit
import RealmSwift

class GiftViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    public var gifts: Results<Gift>?
    private var itemsToken: NotificationToken?
    
    //---------------------------------------------------------------------------
    @IBOutlet weak var tableViewMasterCadeaux: UITableView!
    @IBOutlet weak var searchField: UITextField!
    
    //---------------------------------------------------------------------------
    @IBAction func showAll(_ sender: Any) {
        searchField.text = ""
        searchField.resignFirstResponder()
        nomEditChange(searchField)
    }
    
    //---------------------------------------------------------------------------
    @IBAction func addGift(_ sender: Any) {
        print("addGift")
        let editViewNav = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditGift")
        let  editView:EditGiftTableViewController = editViewNav.children.first as! EditGiftTableViewController
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
        let strSearch = sender.text!
        if (strSearch.count >= 2) || (strSearch.count == 0){
            //print("nomEditchange")
            filterContentForSearchText(strSearch)
        }
    }
    //---------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let realm = RealmDB.getRealm()!
        gifts = realm.objects(Gift.self).sorted(by: ["nomUCD"])
        
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
                print()
                //self.tableViewMasterCadeaux.reloadData()
            }
        })
        
        self.tableViewMasterCadeaux.reloadData()
        super.viewWillAppear(animated)
    }
    
    //---------------------------------------------------------------------------
    override func viewWillDisappear(_ animated: Bool) {
        //print("itemsToken?.invalidate viewWillDisappear GiftViewController")
        itemsToken?.invalidate()
    }
    
    //---------------------------------------------------------------------------
    func filterContentForSearchText(_ searchText: String) {
        let realm = RealmDB.getRealm()!
        if (searchText.count == 0) {
            gifts = realm.objects(Gift.self).sorted(by: ["nomUCD"])
        } else {
            let strSearch = searchText.lowercased()
            gifts = realm.objects(Gift.self).filter("nom contains[c] %@", strSearch).sorted(byKeyPath: "nomUCD")
        }
        tableViewMasterCadeaux.reloadData()
        
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
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //print("commit")
        let alert = UIAlertController(title: "Suppression", message: "Voulez-vous réellement supprimer ce cadeau ?", preferredStyle: .alert)
        
        // ********
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            let gift = self.gifts![indexPath.row]
            let realm = RealmDB.getRealm()!
            try! realm.write {
                realm.delete(gift)
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
                if !self.gifts!.isEmpty {
                    newIndexPath.row = indexPath.row - 1
                    if newIndexPath.row == -1 {
                        newIndexPath.row = 0
                    }
                    tableView.selectRow(at: newIndexPath, animated: true, scrollPosition: .top)
                    
                    self.performSegue(withIdentifier: "giftMasterDetail", sender: self)
                }
            }
        } else {
            tableView.reloadData()
        }
    }
    
    //---------------------------------------------------------------------------
    // MARK: - Navigation
    //---------------------------------------------------------------------------
    // In a storyboard-based application, you will often want to do a little preparation before navigation
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
    //---------------------------------------------------------------------------
    // MARK: - UITextField
    //---------------------------------------------------------------------------
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    /*   func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
     // figure out what the new string will be after the pending edit
     let updatedString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
     
     // Do whatever you want here
     if ((updatedString?.count)! > 2) || (updatedString?.count == 0) {
     filterContentForSearchText(updatedString!)
     }
     
     // Return true so that the change happens
     return true
     }
     */
    /*    @objc func textFieldDidChange(_ textField: UITextField) {
     print("textFieldDidChange")
     let strSearch = textField.text!
     if (strSearch.count > 2) || (strSearch.count == 0) {
     filterContentForSearchText(strSearch)
     }
     }*/
}



