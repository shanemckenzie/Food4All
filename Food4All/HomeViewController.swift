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
    
    var donatedItems = [DonatedItem]()
    var ref: FIRDatabaseReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        //TODO: Load data from database
        //create object, load the data in object as array
        
        loadSampleDonation()
        
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
        return donatedItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Configure the cell...
        let cellIdentifier = "ItemCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? DonationItemCell
            else {
                fatalError("The dequeued cell is not an instance of ToDoItemCell")
        }
        
        let item = donatedItems[indexPath.row]
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
         
                let selectedDonation = donatedItems[indexPath.row]
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
                donatedItems[selectedIndexPath.row] = donatedItem
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
                tableView.reloadData()
                
            } else {
                let newIndexPath = IndexPath(row: donatedItems.count, section: 0)
                
                donatedItems.append(donatedItem)

                
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
        let title2 = "Sample Donation Request"
        let description2 = "Requesting donations of ______"
        let date = NSDate()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, h:mm a"
        
        let dateString: String = formatter.string(from: date as Date)
        let coordinates = CLLocationCoordinate2D(latitude: 50.417433, longitude: -104.594179)
        let coordinates2 = CLLocationCoordinate2D(latitude: 50.417439, longitude: -104.59417)

        
        guard let donation1 = DonatedItem(title, photo!, true, description, dateString, coordinates) else {
            fatalError("Unable to instantiate object")
        }
        
        guard let donation2 = DonatedItem(title2, photo!, false, description2, dateString, coordinates2) else {
            fatalError("Unable to instantiate object")
        }
        
        
        donatedItems += [donation1, donation2]
        
        
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
