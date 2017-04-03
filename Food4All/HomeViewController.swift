//
//  HomeViewController.swift
//  Food4All
//
//  Created by Shane Mckenzie on 2/4/17.
//  Copyright © 2017 University of Regina (Department of Computer Science). All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import CoreLocation
import os.log

class HomeViewController: UITableViewController {
    
    @IBOutlet weak var sortingController: UISegmentedControl!
    
    let donatedItems = DonatedItems();
    var ref: FIRDatabaseReference!
    
    @IBOutlet weak var menuBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //load sample data
        donatedItems.initItems()
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        
        //button for slide out menu
        menuBtn.target = self.revealViewController()
        menuBtn.action = #selector(SWRevealViewController.revealToggle(_:))
        
        //Update table cells every 5 seconds
        var timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.repeatingMethod), userInfo: nil, repeats: true)
    }
    
    @objc func repeatingMethod(){
        //sort any added items
        //donatedItems.sortByDate()
        
        //donatedItems.sortByDistance()
        
        switch sortingController.selectedSegmentIndex {
        case 0:
            print("Sorting by distance")
            donatedItems.sortByDistance()
        case 1:
            donatedItems.sortByDate()
            print("Sorting by date")
        default:
            donatedItems.sortByDistance()
        }
        
        
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return donatedItems.getCount()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Configure the cell...
        let cellIdentifier = "ItemCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? DonationItemCell
            else {
                fatalError("The dequeued cell is not an instance of ToDoItemCell")
        }
        
        let item = donatedItems.getItem(index: indexPath.row)
        print("Loading cells")
        
        //TODO: DO assign values to cell
        cell.cellTitle.text = item.name
        cell.cellImg.image = item.image
        cell.cellDesc.text = item.description
        cell.cellAddress.text = "Address: \(item.address!)"
        
        let formatter = DateFormatter()
        
        //convert the date string back to a date object
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        let expDate = formatter.date(from: item.expiration)
        
        //convert the date to an easy to read format
        formatter.dateFormat = "MMMM dd, YYYY, h:mm a"
        cell.cellExpiryDate.text = "Post Expires: \(formatter.string(from: expDate!))"
        
        if item.donated == true {
            cell.layer.backgroundColor = UIColor(red: 6/255, green: 201/255, blue: 133/255, alpha: 0.6).cgColor
        } else {
            cell.layer.backgroundColor = UIColor(red: 245/255, green: 159/255, blue: 22/255, alpha: 0.6).cgColor
        }
        
        os_log("Due date changed ", log: OSLog.default, type: .debug)
        
        return cell
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        super.prepare(for: segue,sender: sender)
        
        switch(segue.identifier ?? "") {
        //the add item button is pressed
        case "AddItem":
            os_log("Adding a new donation.", log: OSLog.default, type: .debug)
            
        //an existing item is pressed
        case "ShowItem":
            
            guard let itemViewController = segue.destination as? ItemViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            //let itemViewController = segue.destination as? ItemViewController
 
            guard let selectedDonationItemCell = sender as? DonationItemCell else {
                fatalError("Unexpected sender: \(sender)")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedDonationItemCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
 
            let selectedDonation = donatedItems.getItem(index: indexPath.row)
            
            itemViewController.donatedItem = selectedDonation
            
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier)")
        }
        
    }
    

    
    
    //MARK: Actions
    @IBAction func unwindToHome(sender: UIStoryboardSegue) {
        
        if let sourceViewController = sender.source as? SubmissionVC, let donatedItem = sourceViewController.donatedItem {
            //add new item
            
            os_log("saving edited or new item", log: OSLog.default, type: .debug)
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                donatedItems.updateItem(item: donatedItem, index: selectedIndexPath.row)
                
                //donatedItems[selectedIndexPath.row] = donatedItem
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
                tableView.reloadData()
                
            } else {
                let newIndexPath = IndexPath(row: donatedItems.getCount(), section: 0)
                
                donatedItems.addItem(item: donatedItem)
                
                
                tableView.insertRows(at: [newIndexPath], with: .automatic)
                tableView.reloadData()
                
            }
            
            os_log("Trying to save.", log: OSLog.default, type: .debug)
            //saveDonation()
        }
    }
    
    

    
}
