//
//  PersonPickerTableViewController.swift
//  Friends
//
//  Created by bernard on 11/06/2018.
//  Copyright © 2018 bernard. All rights reserved.
//

import UIKit
import RealmSwift

class PersonPickerTableViewController: UITableViewController {
    
    public var persons: Results<Person>?
    public var checkmarks = Array<Bool>()
    var realm: Realm?
    var gift: Gift?
    public var operation = ""
    public var detailView: GiftDetailTableViewController?
    
    //---------------------------------------------------------------------------
    @IBAction func donePersonPicker(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        let realm = RealmDB.getRealm()!
        try! realm.write {
            
            switch operation {
            case "addDonateurs":
                var index = 0
                for aBool in checkmarks {
                    if aBool {
                        let person = persons![index]
                        person.cadeauxOffertsAppendGift(gift!)
                        detailView!.configureViewCadeau()
                    }
                    index += 1
                }

            case "addBeneficiaires":
                var index = 0
                for aBool in checkmarks {
                    if aBool {
                        let person = persons![index]
                        person.cadeauxRecusAppendGift(gift!)
                        detailView!.configureViewCadeau()
                    }
                    index += 1
                }

            case "addIdees":
                var index = 0
                for aBool in checkmarks {
                    if aBool {
                        let person = persons![index]
                        person.cadeauxIdeesAppendGift(gift!)
                        detailView!.configureViewCadeau()
                    }
                    index += 1
                }

            default:
                print("default switch")
            }
        }
    }
    
    //---------------------------------------------------------------------------
    @IBAction func cancelPersonPicker(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //---------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        let realm = RealmDB.getRealm()!
        persons = realm.objects(Person.self).sorted(by: ["nom", "prenom"])
        for _ in persons! {
            checkmarks.append(false)
        }
    }
    
    //---------------------------------------------------------------------------
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pickPerson", for: indexPath)
        
        guard let personne = persons?[indexPath.row] else { return cell }
        // Configure the cell...
        let labelNom = cell.viewWithTag(1000) as! UILabel
        labelNom.text = personne.fullName
        let labelAdresse = cell.viewWithTag(1002) as! UILabel
        labelAdresse.text = personne.addresses
        cell.accessoryType = checkmarks[indexPath.row] ? .checkmark : .none
        
        
        //image
        var image = UIImage()
        let imageView = cell.viewWithTag(1003) as! UIImageView
        imageView.image = nil
        if personne.imageData != nil {
            image = UIImage(data: personne.imageData!)!
        } else {
            image = UIImage(named: "noImage.png")!
        }
        //affectation de l'image réduite
        imageView.backgroundColor = UIColor.white
        imageView.image = scaledImageRound(image, dim: 32, borderWidth: 2.0, borderColor: UIColor.white, imageView: imageView)
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        checkmarks[indexPath.row] = !(checkmarks[indexPath.row])
        tableView.selectRow(at: nil, animated: true, scrollPosition: .top)
        tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
