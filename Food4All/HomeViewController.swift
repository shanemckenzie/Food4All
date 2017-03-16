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
    
    var donatedItems: [DonatedItem]?
    var ref: FIRDatabaseReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
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
        if donatedItems == nil {
            return 0
        } else {
            return donatedItems!.count
        }
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
        case "ShowDetail":
            guard let SubmissionVC = segue.destination as? SubmissionVC else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
     
            guard let selectedDonationItemCell = sender as? DonationItemCell else {
                fatalError("Unexpected sender: \(sender)")
            }
     
            guard let indexPath = tableView.indexPath(for: selectedDonationItemCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
     
            let selectedDonation = donatedItems?[indexPath.row]
            //toDoDetailViewController.toDoItem = selectedToDo
        
            //TODO: load this to SubmissionVC
            SubmissionVC.donatedItem = selectedDonation
     
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier)")
        }
     
     }
    
    //MARK: Actions
    @IBAction func unwindToToDoList(sender: UIStoryboardSegue) {
        
        if let sourceViewController = sender.source as? SubmissionVC, let donatedItem = sourceViewController.donatedItem {
            //add new item
            
            os_log("saving edited or new item", log: OSLog.default, type: .debug)
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                donatedItems![selectedIndexPath.row] = donatedItem
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
                tableView.reloadData()
                
            } else {
                let newIndexPath = IndexPath(row: donatedItems!.count, section: 0)
                
                donatedItems!.append(donatedItem)

                
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

    
    //MARK: Private Methods
    private func loadSampleDonation() {
        
        let photo = UIImage(named: "defaultPhoto")
        let title = "Sample Donation"
        let description = "Sample donation description"
        let date = NSDate()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, h:mm a"
        
        var dateString: String = formatter.string(from: date as Date)
        
        
        
        
        
        guard let donation1 = DonatedItem() else {
            fatalError("Unable to instantiate object")
        }
        
        donatedItems! += [donation1]
        
    }

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
