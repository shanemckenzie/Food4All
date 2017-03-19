//
//  RegisterViewController.swift
//  Food4All
//
//  Created by bill on 3/19/17.
//  Copyright © 2017 University of Regina (Department of Computer Science). All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import os.log

class RegisterViewController: UIViewController {
    
    //MARK: PROPERTIES
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: ACTIONS
    @IBAction func regsiterAttempt(_ sender: UIButton) {
        if(nameField.text != "")
        {
            FIRAuth.auth()?.createUser(withEmail: emailField.text!, password: passwordField.text!) { (user, error) in
                if let error = error {
                
                    let showMessagePrompt = UIAlertController(title: "Registration Error", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                
                    showMessagePrompt.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                    }))
                
                    self.present(showMessagePrompt, animated: true, completion: nil)
                
                    return
                }
                else{
                    
                    //save user meta information
                    var ref: FIRDatabaseReference!
                    ref = FIRDatabase.database().reference()
                    let userRef = ref.child("userMeta")
                    //MARK: TODO ADD BUISNESS LOCATION
                    let newUserData = ["buisnessName": self.nameField.text as Any, "latitude": 50.495254, "longitude": -104.637263] as [String : Any]
                    userRef.child((user?.uid)!).setValue(newUserData)
                    
                    self.performSegue(withIdentifier: "showLogin", sender: nil)
                }
            }
        }
        else{
            // create the alert
            let alert = UIAlertController(title: "Error", message: "Not all field are filled", preferredStyle: UIAlertControllerStyle.alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
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
