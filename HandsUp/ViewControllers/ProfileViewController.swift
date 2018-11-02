//
//  ProfileViewController.swift
//  HandsUp
//
//  Created by Claudia Nelson on 10/20/18.
//  Copyright © 2018 NSHWAHBWAH. All rights reserved.
//
import Parse
import UIKit

class ProfileViewController: UIViewController, UITableViewDataSource {
    
    var questions: [Post]?
    var responses: [Answer]?
    var questionRaises: [Post]?
    var answerRaises: [Answer]?
    
    var mode: Int = 1 //true for Post mode, false for Answer mode
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableview.dataSource = self
        fetchPosts()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTapLogout(_ sender: Any) {
        print("Trying to log out")
        NotificationCenter.default.post(name: NSNotification.Name("didLogout"), object: nil)

    }
    
    @IBAction func didTapQuestions(_ sender: Any) {
        mode = 1
    }
    @IBAction func didTapResponses(_ sender: Any) {
        mode = 2
    }
    @IBAction func didTapRaises(_ sender: Any) {
        mode = 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch mode {
        case 3:
            return questionRaises?.count ?? 0
        case 2:
            return responses?.count ?? 0
        default:
            return questions?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch mode {
        case 3:
            //case 3
            let cell = tableView.dequeueReusableCell(withIdentifier: "questionCell") as!  QuestionDetailCell
            cell.setValues(question: questionRaises?[indexPath.row])
            return cell
        case 2:
            //case 2
            let cell = tableView.dequeueReusableCell(withIdentifier: "answerCell") as!  AnswerCell
            cell.setValuesforAnswer(with: responses?[indexPath.row])
            return cell
        default:
            //case 1
            let cell = tableView.dequeueReusableCell(withIdentifier: "questionCell") as!  QuestionDetailCell
            cell.setValues(question: questions?[indexPath.row])
            return cell
        }
    }
    
    
    func fetchPosts() {
//        let query = PFQuery(className: "Questions")
//        query.
//        query.addDescendingOrder("rating")
//        query.includeKey("author")
//        query.limit = 20
//
//        //fetch stuff
//        query.findObjectsInBackground { (fetchedAnswers: [PFObject]?, error: Error?) in
//            if let fetchedAnswers = fetchedAnswers as? [Answer]{
//                self.answers.removeAll()
//                for fetchedAnswer in fetchedAnswers{
//                    fetchedAnswer.setValues(with: fetchedAnswer)
//                    self.answers.append(fetchedAnswer)
//                    print("New answer added to array: \(self.answers.count)")
//                }
//            }else{
//                if let error = error{
//                    print("There was an error fetching answers: " + error.localizedDescription)
//                }
//            }
//            self.tableView.reloadData()
//        }
        tableview.reloadData()
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
