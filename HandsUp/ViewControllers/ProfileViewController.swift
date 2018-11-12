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
    var questionRaises: [Post]?
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
        fetchPostsLiked()
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
    
    //TODO: FINISH RAISE TABLE
    /*
     WHY THIS DOES NOT WORK:
     The guard let statement does in fact fetch the right posts,
     but does not fetch the entire post. It only fetched the postID's.
     
     In order to get the entire post, we need to query for each of those ID's.
     This will take O(n) time, and this feels like a sin to be okay with.
 */
    
    func fetchPostsLiked(){
        let query = PFQuery(className: "Post")
        
        guard let postIDs = user?.object(forKey: "postsLiked") as? [PFObject] else{
            print("Error 1 in fetchPostsLiked Method")
            return
        }
        let postID = postIDs[4] //Testing if the dictionary has correct ID's
        print(postID.objectId!)
        query.whereKeyExists(postID.objectId!)
        
        //This query only finds one object, so we only need to append the one that was found
        //to the questionRaises array
        
        //NOTE: Some IDs that were being queried did not exist in the database.
        //postIDs[4] for Nikhil shows in PostDB but nothing was fetched.
        query.findObjectsInBackground { (raised_posts: [PFObject]?, error: Error?) in
            if let raised_posts = raised_posts{
                self.questionRaises = raised_posts as? [Post]
            }
            else{
                if let error = error{
                    print("Error 2 occurred in fetchPostsLiked Method: \(error.localizedDescription)")
                }
            }
            print(self.questionRaises?.isEmpty)
            self.tableview.reloadData()
        }
        
        
        
//        for postID in postIDs{ //Queries for each postID that the user has liked.
//
//            query.whereKeyExists(postID.objectId!)
//
//            //This query only finds one object, so we only need to append the one that was found
//            //to the questionRaises array
//            query.findObjectsInBackground { (raised_posts: [PFObject]?, error: Error?) in
//                if let raised_posts = raised_posts{
//                    self.questionRaises = raised_posts as? [Post]
//                }
//                else{
//                    if let error = error{
//                        print("Error 2 occurred in fetchPostsLiked Method: \(error.localizedDescription)")
//                    }
//                }
//                self.tableview.reloadData()
//            }
//
//        }
        
    }
    
}
