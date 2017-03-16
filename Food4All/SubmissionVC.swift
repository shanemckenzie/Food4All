//
//  SubmissionVC.swift
//  Food4All
//
//  Created by Shane Mckenzie on 3/11/17.
//  Copyright © 2017 University of Regina (Department of Computer Science). All rights reserved.
//

import UIKit
import os.log


class SubmissionVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var itemImg: UIImageView!
    @IBOutlet weak var titleTxt: UITextField!
    @IBOutlet weak var descTxt: UITextField!
    @IBOutlet weak var expirationDatePicker: UIDatePicker!
    
    var donatedItem: DonatedItem?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        
        
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
