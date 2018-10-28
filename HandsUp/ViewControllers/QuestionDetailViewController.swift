//
//  QuestionDetailViewController.swift
//  HandsUp
//
//  Created by Claudia Nelson on 10/20/18.
//  Copyright © 2018 NSHWAHBWAH. All rights reserved.
//

import UIKit
import Parse





class QuestionDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var answers: [Answer] = []

    @IBOutlet weak var tableView: UITableView!
    var question: Post?
    var answer: Answer?
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }
        return answers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "questionDetailCell", for: indexPath) as! QuestionDetailCell
            cell.question = question
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "answerCell") as!  AnswerCell
            cell.answer = answers[indexPath.row]
            return cell
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "responseSegue" {
            let responseViewController = segue.destination as! ResponseViewController
            responseViewController.parentQuestion = question
        }
    }
    
    
    
    func fetchAnswers(){
        let questionID = question?.objectId ?? "question does not exist"
        print("QuestionID: \(questionID)")
        
        let query = PFQuery(className: "Answer")
        query.whereKey("postID", matchesText: questionID)
        query.whereKey("postID", equalTo: questionID)      //MARK: THIS LINE IS NOT WORKING
        query.addDescendingOrder("rating")
        query.includeKey("author")
        query.limit = 20
        
        //fetch stuff
        query.findObjectsInBackground { (fetchedAnswers: [PFObject]?, error: Error?) in
            if let fetchedAnswers = fetchedAnswers as? [Answer]{
            
                for fetchedAnswer in fetchedAnswers{
                    fetchedAnswer.setValues(with: fetchedAnswer)
                    self.answers.append(fetchedAnswer)
                }
                    
                    //                self.answers = fetchedAnswers as! [Answer]
            }else{
                
                if let error = error{
                    print("There was an error fetching answers: " + error.localizedDescription)
                }
            }
            self.tableView.reloadData()
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self

        self.fetchAnswers()
        // Do any additional setup after loading the view.
    }

}
