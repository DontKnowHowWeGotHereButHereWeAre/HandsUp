//
//  ResponseViewController.swift
//  HandsUp
//
//  Created by Claudia Nelson on 10/22/18.
//  Copyright © 2018 claudia. All rights reserved.
//

import UIKit
import Parse

class ResponseViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var responseTextView: UITextView!
    
    var parentQuestion: Post?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let parentQuestion = parentQuestion{
            questionLabel.text = parentQuestion.title
            detailLabel.text = parentQuestion.question
        }
        
        // Do any additional setup after loading the view.
        responseTextView.delegate = self
    }
    
    //This dismisses the keyboard when hitting the 'done' button
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    //This dismisses the keyboard when touching out of textField
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    @IBAction func didTapSubmit(_ sender: Any) {
        Answer.postAnswer(postReference: parentQuestion?.objectId, response: responseTextView.text, withCompletion: { (success, error) in
            if let error = error{
                print(error.localizedDescription)
            } else {
                print("post successful")
//                self.performSegue(withIdentifier: "uploadedSegue", sender: nil)
//                self.performSegue(withIdentifier: "questionDetailCell", sender: nil)
                self.navigationController?.popViewController(animated: true)    //Takes user back to detail view.
            }
        })
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
