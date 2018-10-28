//
//  NewPostViewController.swift
//  HandsUp
//
//  Created by Claudia Nelson on 10/20/18.
//  Copyright © 2018 NSHWAHBWAH. All rights reserved.
//
import RSKPlaceholderTextView
import UIKit

class NewPostViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var titleField: RSKPlaceholderTextView!
    @IBOutlet weak var questionField: RSKPlaceholderTextView!
    
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
    
    
    //This dismisses the keyboard when touching out of textField
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleField.delegate = self
        titleField.layer.borderWidth = 1
        titleField.layer.borderColor = UIColor.lightGray.cgColor
        titleField.layer.cornerRadius = 15
        
        questionField.delegate = self
        questionField.layer.borderWidth = 1
        questionField.layer.borderColor = UIColor.lightGray.cgColor
        questionField.layer.cornerRadius = 15
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
