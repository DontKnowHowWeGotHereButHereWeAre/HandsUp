//
//  SignUpViewController.swift
//  HandsUp
//
//  Created by Claudia Nelson on 10/17/18.
//  Copyright © 2018 NSHWAHBWAH. All rights reserved.
//

import UIKit
import Parse

class SignUpViewController: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTapSignUp(_ sender: Any) {
        let newUser = PFUser()
        newUser.username = usernameField.text
        newUser.password = passwordField.text
        let role = segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex)
        newUser.add(role ?? "student", forKey: "role")

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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
