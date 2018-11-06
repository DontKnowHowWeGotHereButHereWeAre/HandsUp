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
        fetchCurrentUserInfo()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        user = PFUser.current()
        fetchCurrentUserInfo()
    }
    
    @IBAction func didTapLogout(_ sender: Any) {
        print("Trying to log out")
        NotificationCenter.default.post(name: NSNotification.Name("didLogout"), object: nil)

    }
    
    @IBAction func didTapQuestions(_ sender: Any) {
        mode = 1
        tableview.reloadData()
    }
    @IBAction func didTapResponses(_ sender: Any) {
        mode = 2
        tableview.reloadData()
    }
    @IBAction func didTapRaises(_ sender: Any) {
        mode = 3
        fetchCurrentUserInfo()
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
//            cell.setValues(question: questionRaises?[indexPath.row])
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
    
    
//    func fetchUser() {
//        let query = PFQuery(className: "Post")
//        query.whereKey("author", equalTo: PFUser.current())
//        query.addDescendingOrder("rating")
//        query.limit = 20
//
//        //fetch stuff
//        query.findObjectsInBackground { (fetchedPosts: [PFObject]?, error: Error?) in
//            if let fetchedPosts = fetchedPosts as? [Post]{
//                self.answers.removeAll()
//                for fetchedPost in fetchedPosts{
//                    fetchedPost.setValues(with: fetchedPost)
//                    self.posts.append(fetchedAnswer)
//                }
//            }else{
//                if let error = error{
//                    print("There was an error fetching posts: " + error.localizedDescription)
//                }
//            }
//            self.tableview.reloadData()
//            } as! PFQueryArrayResultBlock
//    }
    

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
        
        query.findObjectsInBackground { (fetchedObjects, error) in
            if let fetchedObjects = fetchedObjects as? [Post] {
                self.questions = fetchedObjects
            } else if let error = error {
                print("Error 2 in fetchThisObject: \(error.localizedDescription)")
            }
            self.tableview.reloadData()
        }
    }
    
    func fetchCurrentUserInfo(){
        
        print(user?.username ?? "no username")
        print (user?["postsLiked"] ?? "no postsLiked")
        
        if let posts = user?.object(forKey: "postsLiked") as? [PFObject]{
            for post in posts{
//                post.setValue(with: post)
//                if let title = post.value(forKey: "title") as? String{
//                    print(title)
//                }
                print(post)
            }
//            questionRaises = posts
            print(posts)
        }
        
        tableview.reloadData()
        
    }
    
}
