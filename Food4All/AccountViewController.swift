//
//  AccountViewController.swift
//  Food4All
//
//  Created by Shane Mckenzie on 2/4/17.
//  Copyright © 2017 University of Regina (Department of Computer Science). All rights reserved.
//

import UIKit
import FirebaseAuth

class AccountViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: PROPERTIES
    @IBOutlet weak var menuBtn: UIBarButtonItem!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailField: UILabel!
    
    @IBOutlet weak var nameTxt: UILabel!
    @IBOutlet weak var emailTxt: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK: VARIABLES
    var user = User()
    let donatedItems = DonatedItems();
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        self.tableView.allowsMultipleSelectionDuringEditing = false
        
        //loading wheel
        let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Loading"
        
        //setup table view
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DonationItemCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        //load items
        donatedItems.loadUsersItems()
        
        //set view
        nameTxt.text = user?.businessName
        emailTxt.text = user?.email
        
        
       
        //button for slide out menu
        menuBtn.target = self.revealViewController()
        menuBtn.action = #selector(SWRevealViewController.revealToggle(_:))
        
        //Update table cells every 5 seconds
        var timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(AccountViewController.repeatingMethod), userInfo: nil, repeats: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    
    func repeatingMethod(){
        
        //dismiss loading wheel
        if(donatedItems.getCount() > 0){
            MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
        }
        
        self.tableView.reloadData()
        
        //sort any added items
        donatedItems.sortByDate()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedItem = donatedItems.getItem(index: indexPath.row)
        
                    if selectedItem.reservedBy == user?.userID {

                        self.performSegue(withIdentifier: "ReservedView", sender: selectedItem)
                        
                        
                    } else {
                        
                        self.performSegue(withIdentifier: "OwnedView", sender: selectedItem)
                        
                        //itemVC.donatedItem = selectedItem
                    }
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
//        guard let selectedItemCell = sender as? DonationItemCell else {
//            fatalError("Unexpected sender: \(sender)")
//        }
//        
//        guard let indexPath = tableView.indexPath(for: selectedItemCell) else {
//            fatalError("The selected cell is not being displayed by the table")
//        }
//        
//        let selectedItem = donatedItems.getItem(index: indexPath.row)
        
        
        switch(segue.identifier ?? "") {
            
        case "AddItem":
            print("Adding a new donation.")
            
        case "ReservedView":
            let selectedItem = sender as! DonatedItem

            guard let itemVC = segue.destination as? ItemViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            itemVC.donatedItem = selectedItem

        case "OwnedView":
            let selectedItem = sender as! DonatedItem

            //let selectedItem = donatedItems.getItem(index: indexPath.row)
            guard let itemVC = segue.destination as? SubmissionVC else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            itemVC.donatedItem = selectedItem
            
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier)")
        }
    }
    
    
    //MARK: TABLE SECTION
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return donatedItems.getCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
        cell.cellAddress.text = item.address
        
        
        if item.reserved! {
            cell.layer.backgroundColor = UIColor(red: 181/255, green: 36/255, blue: 48/255, alpha: 0.7).cgColor //red
        }
        else if(item.donated == true){
            cell.layer.backgroundColor = UIColor(red: 6/255, green: 201/255, blue: 133/255, alpha: 0.7).cgColor
        }
        else {
            cell.layer.backgroundColor = UIColor(red: 255/255, green: 103/255, blue: 0/255, alpha: 0.7).cgColor
        }
        
        let formatter = DateFormatter()
        //formatter.dateFormat = "MMMM dd, h:mm a"
        
        //convert the date string back to a date object
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        let expDate = formatter.date(from: item.expiration)
        
        //convert the date to an easy to read format
        formatter.dateFormat = "MMMM dd, YYYY, h:mm a"
        cell.cellExpiryDate.text = "Post Expires: \(formatter.string(from: expDate!))"
        
        return cell
    }
    
    //MARK: Item Deletion
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            //remove from DB
            let item = donatedItems.getItem(index: indexPath.row)
            //tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            donatedItems.deleteFromDb(itemToRemove: item.itemID)
            print("Deleted")

            tableView.deleteRows(at: [indexPath], with: .left)
            
        }
    }

}
