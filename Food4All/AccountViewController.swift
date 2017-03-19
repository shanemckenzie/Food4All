//
//  AccountViewController.swift
//  Food4All
//
//  Created by Shane Mckenzie on 2/4/17.
//  Copyright © 2017 University of Regina (Department of Computer Science). All rights reserved.
//

import UIKit
import FirebaseAuth

class AccountViewController: UIViewController {
    
    //MARK: PROPERTIES
    @IBOutlet weak var menuBtn: UIBarButtonItem!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailField: UILabel!
    
    //MARK: VARIABLES
    var user = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        //set view
        nameLabel.text = user?.buisnessName
        emailField.text = user?.email
       
        //button for slide out menu
        menuBtn.target = self.revealViewController()
        menuBtn.action = #selector(SWRevealViewController.revealToggle(_:))
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
