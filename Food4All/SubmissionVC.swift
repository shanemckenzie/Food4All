//
//  SubmissionVC.swift
//  Food4All
//
//  Created by Shane Mckenzie on 3/11/17.
//  Copyright © 2017 University of Regina (Department of Computer Science). All rights reserved.
//

import UIKit
import os.log
import MapKit
import CoreLocation
import Firebase
import FirebaseAuth


class SubmissionVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, CLLocationManagerDelegate {

    //MARK: PROPERTIES
    @IBOutlet weak var itemImg: UIImageView!
    @IBOutlet weak var titleTxt: UITextField!
    @IBOutlet weak var descTxt: UITextField!
    @IBOutlet weak var expirationDatePicker: UIDatePicker!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var donatedItem: DonatedItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleTxt.delegate = self
        
        // Enable the Save button only if valid ffields
        saveButton.isEnabled = false
        updateSaveButtonState()
    }

    //MARK: Save Button
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.isEnabled = false
    }
    
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let text = titleTxt.text ?? ""
        if(!text.isEmpty)
        {
            saveButton.isEnabled = true
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /* REMOVE
     lazy var expireDateString: String = {
     let formatter = DateFormatter()
     formatter.dateFormat = "MMMM dd, h:mm a"
     
     return formatter.string(from: self.expireDate as! Date)
     }()
     */

    
    // MARK: - Navigation
    
    // This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        //save item to db
        
        //format the date to a string
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, h:mm a"
        let expirationDate = formatter.string(from: expirationDatePicker.date)
        
        //deal with coordinates
        let tempCoord = CLLocationCoordinate2D(latitude: 50.417433, longitude: -104.594179)
        
        let user = FIRAuth.auth()?.currentUser
        
        //TODO SET UP DONATED BUTTON + COORDINATES
        donatedItem = DonatedItem(titleTxt.text!, itemImg.image!, true, descTxt.text!, expirationDate, tempCoord, (user?.uid)!)
        
        donatedItem?.saveToDB()
    }
    
    //MARK: UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //dismiss picker if user cancels
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        //info dict may contain multiple representations of the image
        guard let selectedImage = info[UIImagePickerControllerEditedImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        //set photoImageView to display selected image
        itemImg.image = selectedImage
        //dismiss the picker
        dismiss(animated: true, completion: nil)
    }
    //MARK: Actions
    
    @IBAction func imgFromLibrary(_ sender: AnyObject) {
        os_log("Picking image from library", log: OSLog.default, type: .debug)
        //hide keyboard
        
        //toDoTitle.resignFirstResponder()
        
        //UIImagePickerController lets users pick media from photo library
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        //allow photos to be picked, not taken
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = true
        
        //notify ViewController when user picks image
        imagePickerController.delegate = self
        
        //display the image in the image field
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func imgFromCamera(_ sender: AnyObject) {
        os_log("Picking image from camera", log: OSLog.default, type: .debug)
        
        //hide keyboard
        //toDoTitle.resignFirstResponder()
        
        //UIImagePickerController lets users pick media from photo library
        let imagePickerController = UIImagePickerController()
        
        //notify ViewController when user picks image
        imagePickerController.delegate = self
        
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)) {
            imagePickerController.sourceType = UIImagePickerControllerSourceType.camera
            imagePickerController.allowsEditing = true
            
            present(imagePickerController, animated: true, completion: nil)
        }
        else {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    

    
}
