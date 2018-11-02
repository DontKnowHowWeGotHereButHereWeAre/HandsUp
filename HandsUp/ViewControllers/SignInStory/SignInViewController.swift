//
//  LoginViewController.swift
//  HandsUp
//
//  Created by Claudia Nelson on 10/17/18.
//  Copyright © 2018 NSHWAHBWAH. All rights reserved.
//

import UIKit
import Parse

class SignInViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!

    // MARK: button tapped to sign in
    @IBAction func onSignIn(_ sender: Any) {
        let username = usernameField.text ?? ""
        let password = passwordField.text ?? ""
        
        PFUser.logInWithUsername(inBackground: username, password: password) { (user: PFUser?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
                let message = error.localizedDescription
                let alert = UIAlertController(title: "Uh oh!", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                self.present(alert, animated: true)
            } else {
                print("User login successful")
                self.performSegue(withIdentifier: "signInSegue", sender: nil)
            }
        }
    }
    
    //This dismisses the keyboard when hitting the 'done' button
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        usernameField.resignFirstResponder()
        passwordField.resignFirstResponder()
        return true
    }
    
    //This dismisses the keyboard when touching out of textField
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameField.delegate = self
        passwordField.delegate = self
        // Do any additional setup after loading the view.
    }

}
