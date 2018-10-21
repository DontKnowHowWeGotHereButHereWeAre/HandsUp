//
//  SignUpViewController.swift
//  HandsUp
//
//  Created by Claudia Nelson on 10/17/18.
//  Copyright © 2018 NSHWAHBWAH. All rights reserved.
//

import UIKit
import Parse

class SignUpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
    @IBAction func didTapSignUp(_ sender: Any) {
        let newUser = PFUser()
        newUser.username = usernameField.text
        newUser.password = passwordField.text
        let role = segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex)
        //Use setValue instead of add for keys with single values
        newUser.setValue(role ?? "Student", forKey: "role")
        newUser.setValue(true, forKey: "anonymous")

        newUser.signUpInBackground{
            (success: Bool, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
                // TODO: account for error 202
            } else {
                print("User registered successfully")
                // TODO: add segue to home feed
                self.performSegue(withIdentifier: "signUpSegue", sender: nil)
            }
        }
        print(newUser)
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
