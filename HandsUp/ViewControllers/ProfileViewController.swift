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
    
    var user: PFUser?
    var questions: [Post]?
    var responses: [Answer]?
    var questionRaises: [Post] = []
    var answerRaises: [Answer]?
    
    var mode: Int = 1 //true for Post mode, false for Answer mode
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        user = PFUser.current()
        usernameLabel.text = user?.username ?? "Anonymous werewolf 🐺"
        
        tableview.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        user = PFUser.current()
    }
    
    @IBAction func didTapLogout(_ sender: Any) {
        print("Trying to log out")
        NotificationCenter.default.post(name: NSNotification.Name("didLogout"), object: nil)

    }
    
    @IBAction func didTapQuestions(_ sender: Any) {
        mode = 1
        self.fetchThisObject("Post")
    }
    @IBAction func didTapResponses(_ sender: Any) {
        mode = 2
        self.fetchThisObject("Answer")
    }
    @IBAction func didTapRaises(_ sender: Any) {
        mode = 3
        
        if(!self.questionRaises.isEmpty){   //If the array has stuff...
                                            // Remove entities before appending.
            self.questionRaises.removeAll()
        }
        
        fetchPostsRaised()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch mode {
        case 3:
            return questionRaises.count
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
            cell.setValues(question: questionRaises[indexPath.row])
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
    
    

    func fetchThisObject(_ classObject: String){
        guard let user = user else {
            print("Error 1 in fetchThisObject method")
            return
        }
        
        let query = PFQuery(className: classObject)
        query.whereKey("author", equalTo: user)
        query.addDescendingOrder("created_at")
        query.limit = 20
        
        //fetch stuff
        if(classObject == "Post"){      //If user is searching for Questions
            query.findObjectsInBackground { (fetchedObjects, error) in
                if let fetchedObjects = fetchedObjects as? [Post] {
                    self.questions = fetchedObjects
                } else if let error = error {
                    print("Error 2 in fetchThisObject: \(error.localizedDescription)")
                }
                self.tableview.reloadData()
            }
        }
        
        else if(classObject == "Answer"){       //If user is searching for his/her answers.
            query.findObjectsInBackground { (fetchedObjects, error) in
                if let fetchedObjects = fetchedObjects as? [Answer] {
                    self.responses = fetchedObjects
                } else if let error = error {
                    print("Error 2 in fetchThisObject: \(error.localizedDescription)")
                }
                self.tableview.reloadData()
            }
        }
        
        //QUERY FOR RAISES BY THE USER
        else if(classObject == "User"){
            query.findObjectsInBackground { (fetchedObjects, error) in
                if let fetchedObjects = fetchedObjects as? [Answer] {
                    self.responses = fetchedObjects
                } else if let error = error {
                    print("Error 2 in fetchThisObject: \(error.localizedDescription)")
                }
                self.tableview.reloadData()
            }
            
        }
        
        
    }
    

    func fetchPostsRaised(){ //Fetches data of what the user raised hands for.
                            // The database calls 'raises' as 'likes.'
        
        
        guard let postIDs = user?.object(forKey: "postsLiked") as? [PFObject] else{
            print("Error 1 in fetchPostsRaised Method")
            return
        }
        
        var queryCount = 0
        for post in postIDs{
            let postID = post.objectId
            let query = PFQuery(className: "Post")
            queryCount += 1
            
            //MARK: Query Fetches Raises & Appends to Array
            query.getObjectInBackground(withId: postID!) { (object, error) in
                
                self.questionRaises.append(object as! Post)
                queryCount -= 1
                if queryCount == 0 {
                    print("Reloaded TableView data")
                    self.questionRaises.sort(by: { (left, right) -> Bool in
                        guard let leftCreated = left.createdAt, let rightCreated = right.createdAt else {
                            return false
                        }
                        return leftCreated > rightCreated
                    })
                    self.tableview.reloadData()
                }
            }
        }
        
    }
}
