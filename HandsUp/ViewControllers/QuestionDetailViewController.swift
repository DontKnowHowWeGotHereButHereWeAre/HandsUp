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
            cell.setValues(question: question)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "answerCell") as!  AnswerCell
            cell.setValuesforAnswer(with: answers[indexPath.row])
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
        query.addDescendingOrder("rating")
        query.includeKey("author")
        query.limit = 20
        
        //fetch stuff
        query.findObjectsInBackground { (fetchedAnswers: [PFObject]?, error: Error?) in
            if let fetchedAnswers = fetchedAnswers as? [Answer]{
                self.answers.removeAll()
                for fetchedAnswer in fetchedAnswers{
                    fetchedAnswer.setValues(with: fetchedAnswer)
                    self.answers.append(fetchedAnswer)
                    print("New answer added to array: \(self.answers.count)")
                }
            }else{
                if let error = error{
                    print("There was an error fetching answers: " + error.localizedDescription)
                }
            }
            self.tableView.reloadData()
        }
        
        
    }
    
    func updateQuestion() {
        let query = PFQuery(className: "Post")
        query.includeKey("author")
        if let question = question{
            query.getObjectInBackground(withId: question.objectId!) { (question: PFObject?, error: Error?) in
                if let post = question as? Post{
                    post.setValue(with: question)
                    self.question = post
                } else if let error = error {
                    print(error.localizedDescription)
                }
                let indexPath = IndexPath(row: 0, section: 0)
                self.tableView.reloadRows(at: [indexPath], with: .none)
            }
        } else {
            print("there is an error updating question")
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateQuestion()
        self.fetchAnswers()
    }
    
    
    @objc func refreshQuestionDetailAction(_ refreshControl: UIRefreshControl){
        self.fetchAnswers()
        refreshControl.endRefreshing()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Refresh Control stuff
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshQuestionDetailAction(_:)), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl)
        
        
        tableView.dataSource = self
        tableView.delegate = self
        
        self.fetchAnswers()

        // Do any additional setup after loading the view.
    }

}
