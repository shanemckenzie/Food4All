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
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK: VARIABLES
    var user = User()
    let donatedItems = DonatedItems();
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
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
        var timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: Selector("repeatingMethod"), userInfo: nil, repeats: true)
    }
    
    func repeatingMethod(){
        print("REPEATING")
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
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
        
        if item.donated == true {
            cell.layer.backgroundColor = UIColor(red: 6/255, green: 201/255, blue: 133/255, alpha: 0.3).cgColor
        } else {
            cell.layer.backgroundColor = UIColor(red: 245/255, green: 159/255, blue: 22/255, alpha: 0.3).cgColor
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, h:mm a"
        
        
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


}
