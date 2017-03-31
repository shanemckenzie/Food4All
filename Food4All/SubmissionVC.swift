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
import Contacts

class SubmissionVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, CLLocationManagerDelegate{

    //MARK: PROPERTIES
    @IBOutlet weak var itemImg: UIImageView!
    @IBOutlet weak var titleTxt: UITextField!
    @IBOutlet weak var descTxt: UITextField!
    @IBOutlet weak var expirationDatePicker: UIDatePicker!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var donateSwitch: UISegmentedControl!
    @IBOutlet weak var addressTxt: UITextField!
    
    let locationManager = CLLocationManager()
    var donatedItem: DonatedItem?
    var donated = true
    var editingExistingItem = false //so we know whether to save new or update existing item
    var coordinates2D: CLLocationCoordinate2D?
    var coordinates: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleTxt.delegate = self
        
        // Enable the Save button only if valid fields
        saveButton.isEnabled = false
        updateSaveButtonState()
        
        //Get user's address
        if CLLocationManager.locationServicesEnabled() {
            print("Location services enabled")
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            self.locationManager.requestAlwaysAuthorization()
            self.locationManager.startUpdatingLocation()
        }
        
        // Set up views if editing an existing Item
        if let donatedItem = donatedItem {
            editingExistingItem = true
            
            titleTxt.text = donatedItem.name
            descTxt.text = donatedItem.description
            itemImg.image = donatedItem.image
            //TODO
            //addressTxt.text = donatedItem.address
            
            //expirationDatePicker.date = donatedItem.expireDate as! Date
            
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM dd, h:mm a"
            let expirationDate = formatter.date(from: donatedItem.expiration)
            expirationDatePicker.date = expirationDate!
            
            if(donatedItem.donated == true){
                donateSwitch.selectedSegmentIndex = 0
            }
            else{
                donateSwitch.selectedSegmentIndex = 1
            }
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //geocode address
        setAddress(location: coordinates!) {
            (originPlacemark, error) in
            if let err = error {
                print(err)
            } else if let placemark = originPlacemark {
                // Do something with the placemark
                let placemarkAddress = placemark.addressDictionary
                
                //let thoroughfare = placemarkAddress?["Thoroughfare"] as! String?
                //let city = placemarkAddress?["City"] as! String?
                let address = self.postalAddressFromAddressDictionary(placemarkAddress as! Dictionary<NSObject, AnyObject>)
                
                //self.addressTxt.text = "\(thoroughfare!), \(city!)"
                self.addressTxt.text = address.street
                print("Address \(self.addressTxt.text)")
                
                self.locationManager.stopUpdatingLocation()
            }
        }
        
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
        
        //TODO: deal with coordinates
        let tempCoord = CLLocationCoordinate2D(latitude: 50.495254, longitude: -104.637263)
        
        let user = FIRAuth.auth()?.currentUser
        
        switch donateSwitch.selectedSegmentIndex {
        case 0:
            donated = true
        case 1:
            donated = false
        default:
            donated = true
        }
        
        //TODO: SET UP DONATED BUTTON + COORDINATES
        
        if(!editingExistingItem){
            donatedItem = DonatedItem(titleTxt.text!, itemImg.image!, donated, descTxt.text!, expirationDate, tempCoord, (user?.uid)!, "TEMP", addressTxt.text!)
            donatedItem?.saveToDB()
        }
        else{
            donatedItem = DonatedItem(titleTxt.text!, itemImg.image!, donated, descTxt.text!, expirationDate, tempCoord, (user?.uid)!, (donatedItem?.itemID)!, addressTxt.text!)
            donatedItem?.updateItem()
        }
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
    
    //MARK: Location
    // Convert to the newer CNPostalAddress
    func postalAddressFromAddressDictionary(_ addressdictionary: Dictionary<NSObject,AnyObject>) -> CNMutablePostalAddress {
        let address = CNMutablePostalAddress()
        
        address.street = addressdictionary["Street" as NSObject] as? String ?? ""
        address.state = addressdictionary["State" as NSObject] as? String ?? ""
        address.city = addressdictionary["City" as NSObject] as? String ?? ""
        address.country = addressdictionary["Country" as NSObject] as? String ?? ""
        address.postalCode = addressdictionary["ZIP" as NSObject] as? String ?? ""
        
        return address
    }
    
    // Create a localized address string from an Address Dictionary
    func localizedStringForAddressDictionary(addressDictionary: Dictionary<NSObject,AnyObject>) -> String {
        return CNPostalAddressFormatter.string(from: postalAddressFromAddressDictionary(addressDictionary), style: .mailingAddress)
    }
    
    //get users location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print("Getting address")
        let userLocation:CLLocation = locations[0]
        let long = userLocation.coordinate.longitude;
        let lat = userLocation.coordinate.latitude;
        //Do What ever you want with it
        coordinates2D?.latitude = lat
        coordinates2D?.longitude = long
        coordinates = CLLocation(latitude: lat, longitude: long)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while updating location " + error.localizedDescription)
    }
    
    
    //set address using the user's GPS coordinates
    func setAddress(location: CLLocation, completionHandler: @escaping (CLPlacemark?, String?) -> ()) {
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(location, completionHandler: {
            placemarks, error in
            if let err = error {
                
                completionHandler(nil, err.localizedDescription)
                
            } else if let placemarkArray = placemarks {
                
                if let placemark = placemarkArray.first {
                    
                    completionHandler(placemark, nil)
                    
                } else {
                    
                    completionHandler(nil, "Placemark was nil")
                    
                }
            } else {
                completionHandler(nil, "Unkown Error")
            }
        })
        
    }

    
}
