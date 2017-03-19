//
//  ItemViewController.swift
//  Food4All
//
//  Created by bill on 3/16/17.
//  Copyright © 2017 University of Regina (Department of Computer Science). All rights reserved.
//

import UIKit

class ItemViewController: UIViewController {
    
    //MARK: PROPERTIES
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var donaterNameField: UILabel!
    @IBOutlet weak var reserveSwitch: UISwitch!
    @IBOutlet weak var descriptionField: UILabel!
    
    //Variables
    var donatedItem: DonatedItem?
    

    override func viewDidLoad() {
        super.viewDidLoad()
      
        //delegates
        /*
        if let donatedItem = donatedItem {
            titleLabel.text = donatedItem.name
            image.image = donatedItem.image!
            donaterNameField.text = donatedItem.name
            descriptionField.text = donatedItem.description
        }
        else{
            print("ERROR: DATA NOT LOADING")
        }
        */
    }
    
    // This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        //guard let button = sender as? UIBarButtonItem, button === saveButton else {
          //  os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            //return
        //}
        
        //let name = nameTextField.text ?? "" //uses nil opeartor
        //let notes = notesField.text ?? ""
        //let photo = imageField.image
        //let dateEntered = Date()
        //let selectedPriority = priority[pickerView.selectedRow(inComponent: 0)]
        
        // Set the meal to be passed to MealTableViewController after the unwind segue.
       // item = Item(name: name, notes: notes, photo: photo, dateEntered: dateEntered, priority: selectedPriority, dueDate: myDueDate)
    }
    
    /*
     // Set up view
     if let donatedItem = donatedItem {
     navigationItem.title = item.name
     nameTextField.text   = item.name
     notesField.text = item.notes
     imageField.image = item.photo
     if(item.priority == "High"){
     pickerView.selectRow(3, inComponent:0, animated:true)
     }
     else if(item.priority == "Medium"){
     pickerView.selectRow(1, inComponent:0, animated:true)
     }
     else{
     pickerView.selectRow(2, inComponent:0, animated:true)
     }
     
     }
    */

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

}
