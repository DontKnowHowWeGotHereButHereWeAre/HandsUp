//
//  LoginViewController.swift
//  HandsUp
//
//  Created by Claudia Nelson on 10/17/18.
//  Copyright © 2018 NSHWAHBWAH. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    
    @IBAction func didTapNewUser(_ sender: Any) {
    }
    
    //MARK: ButtonTapped to Sign Up
    @IBAction func onSignUp(_sender: Any){
        let newUser = PFUser();
        
        newUser.username = usernameField.text
        newUser.password = passwordField.text
        
        newUser.signUpInBackground { (success: Bool, error: Error?) in
            if success{
                print("User Signed Up Successfully!");
                
                //TODO: Segue into the HomeView
                
            }else{
                print("error signing up: \(error!.localizedDescription)")
                
                if error?._code == 202{
                    print("Username is taken")
                }
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

}
