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

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
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
        responseTextView.layer.borderWidth = 1
        responseTextView.layer.borderColor = UIColor.lightGray.cgColor
        responseTextView.layer.cornerRadius = 15
    }
    
    
    
    @IBAction func didTap(_ sender: UITapGestureRecognizer) {
        self.responseTextView.resignFirstResponder()
    }
    
    @IBAction func didTapSubmit(_ sender: Any) {
        if responseTextView.text.isEmpty{
            let alert = UIAlertController(title: "Uh oh!", message: "Please enter a response", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true)
        } else {
            Answer.postAnswer(postReference: parentQuestion?.objectId, response: responseTextView.text, withCompletion: { (success, error) in
                if let error = error{
                    print(error.localizedDescription)
                } else {
                    self.navigationController?.popViewController(animated: true)
                    print("post successful")
                    self.parentQuestion?.incrementKey("commentsCount")
                    self.parentQuestion?.saveInBackground()
                }
            })
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
