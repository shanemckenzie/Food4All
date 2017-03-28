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
        var timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(HomeViewController.repeatingMethod), userInfo: nil, repeats: true)
    }
    
    func repeatingMethod(){
        print("REPEATING")
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //TODO: Sorting by distance and date
    
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
        
        if item.donated == true {
            cell.layer.backgroundColor = UIColor(red: 6/255, green: 201/255, blue: 133/255, alpha: 0.3).cgColor
        } else {
            cell.layer.backgroundColor = UIColor(red: 245/255, green: 159/255, blue: 22/255, alpha: 0.3).cgColor
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, h:mm a"
        
        os_log("Due date changed ", log: OSLog.default, type: .debug)
        
        //        if toDo.enteredDate != nil {
        //            cell.toDoDateEntered.text = "Date Entered: \(formatter.string(from: toDo.enteredDate as! Date))"
        //        }
        
        //cell.toDoDateDue.text = toDo.dueDate
        
        //        if toDo.notes != "" {
        //            cell.toDoNotes.text = "Notes: \(toDo.notes!)"
        //        } else {
        //            cell.toDoNotes.text = "Notes:"
        //        }
        //        print("Priority: \(toDo.priority)")
        //
        //        if toDo.priority! == 1 {
        //            cell.layer.backgroundColor = UIColor(red: 255/255, green: 51/255, blue: 17/255, alpha: 0.4).cgColor
        //        } else if toDo.priority! == 2 {
        //            cell.layer.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 102/255, alpha: 0.4).cgColor
        //        } else if toDo.priority! == 3 {
        //            cell.layer.backgroundColor = UIColor(red: 94/255, green: 255/255, blue: 151/255, alpha: 0.4).cgColor
        //        }
        
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
    
    /*
     
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
     super.prepare(for: segue, sender: sender)
     
     switch(segue.identifier ?? "") {
     
     case "AddItem":
     os_log("Adding a new to-do item.", log: OSLog.default, type: .debug)
     
     case "ShowDetail":
     guard let itemDetailViewController = segue.destination as? ViewController else {
     fatalError("Unexpected destination: \(segue.destination)")
     }
     
     guard let selectedItemCell = sender as? itemTableViewCell else {
     fatalError("Unexpected sender: \(sender)")
     }
     
     guard let indexPath = tableView.indexPath(for: selectedItemCell) else {
     fatalError("The selected cell is not being displayed by the table")
     }
     
     let selectedItem = itemsList.getItem(index: indexPath.row)
     itemDetailViewController.item = selectedItem
     
     default:
     fatalError("Unexpected Segue Identifier; \(segue.identifier)")
     }
     }
     
     @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
     if let sourceViewController = sender.source as? ViewController, let item = sourceViewController.item {
     
     if let selectedIndexPath = tableView.indexPathForSelectedRow {
     // Update an existing item.
     itemsList.updateItem(item: item, index: selectedIndexPath.row)
     //update all rows since we don't know where the sorted item ends up
     tableView.reloadData()
     }
     else {
     // Add a new item.
     
     itemsList.addItem(item: item)
     let newIndexPath = IndexPath(row: itemsList.getIndex(item: item), section: 0)
     
     tableView.insertRows(at: [newIndexPath], with: .automatic)
     }
     // Save the items.
     itemsList.saveItems()
     }
     
     
     */
    
    
    //MARK: Actions
    @IBAction func unwindToToDoList(sender: UIStoryboardSegue) {
        
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
    
    
    //    private func loadSampleToDo() {
    //
    //        let photo = UIImage(named: "defaultPhoto")
    //
    //        guard let toDo1 = ToDoItem("Get milk", photo, "go to store get milk", "Due Immediately", NSDate() , NSDate(), 1) else {
    //            fatalError("Unable to instantiate todoitem1")
    //        }
    //
    //        toDoItems += [toDo1]
    //        sortedList = TableSort(toSort: toDoItems)
    //        toDoItems = (sortedList?.sortedList)!
    //
    //    }
    
    //    private func saveDonation() {
    //        //let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(toDoItems, toFile: ToDoItem.ArchiveURL.path)
    //
    //        ref = FIRDatabase.database().reference()
    //
    //        let newDonationItemRef = self.ref!.child("DonationItem").childByAutoId()
    //
    //        let newDonationItemId = newDonationItemRef.key
    //
    //        let newDonationItemData: [String : Any] = ["itemID": newDonationItemId,
    //            "title": title as NSString,
    //            "description": description as NSString,
    //             "expiration": date as NSString
    //            //user
    //            //image
    //            //location
    //        ]
    //
    //        newDonationItemRef.setValue(newDonationItemData)
    
    //        if isSuccessfulSave {
    //            os_log("toDoItems saved.", log: OSLog.default, type: .debug)
    //
    //        } else {
    //            os_log("failed to save toDoItems", log: OSLog.default, type: .error)
    //        }
    
    //    }
    //
    //    private func loadToDo() -> [ToDoItem]? {
    //        return NSKeyedUnarchiver.unarchiveObject(withFile: ToDoItem.ArchiveURL.path) as? [ToDoItem]
    //        
    //    }
    
    
}
