//
//  InitialViewController.swift
//  Food4All
//
//  Created by bill on 3/7/17.
//  Copyright © 2017 University of Regina (Department of Computer Science). All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import os.log


class InitialViewController: UIViewController {

    //MARK: PROPERTIES
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    //MARK: ACTIONS
    
    @IBAction func userLogInAction(_ sender: UIButton) {
        //Authenticate user with firebase
        FIRAuth.auth()?.signIn(withEmail: emailField.text!, password: passwordField.text!) { (user, error) in
            if let error = error {
               
                let showMessagePrompt = UIAlertController(title: "Log In Error", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                
                showMessagePrompt.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                }))
                
                self.present(showMessagePrompt, animated: true, completion: nil)
                
                return
            }
            else{
                print("USER HAS BEEN AUTHENTICATED")
                self.performSegue(withIdentifier: "logInSegue", sender: nil)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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

}
