//
//  NewPostViewController.swift
//  HandsUp
//
//  Created by Claudia Nelson on 10/20/18.
//  Copyright © 2018 NSHWAHBWAH. All rights reserved.
//

import UIKit

class NewPostViewController: UIViewController {

    @IBOutlet weak var questionField: UITextView!
    @IBOutlet weak var titleField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTapSubmit(_ sender: Any) {
        Post.postQuestion(title: titleField.text, withQuestion: questionField.text) { (success, error) in
            if let error = error{
                print(error.localizedDescription)
            } else {
                print("post successful")
                self.performSegue(withIdentifier: "uploadedSegue", sender: nil)
            }
        }
        
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
