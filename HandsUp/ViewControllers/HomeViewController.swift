//
//  HomeViewController.swift
//  HandsUp
//
//  Created by Claudia Nelson on 10/20/18.
//  Copyright © 2018 NSHWAHBWAH. All rights reserved.
//

import UIKit
import Parse



class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var posts: [PFObject] = []
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
        let post = posts[indexPath.row]
        
        cell.TitleLabel.text = post["title"] as? String
        cell.TopAnswerLabel.text = "My milkshake brings all the cows to the yard"
        cell.RaisesCountLabel.text = "🤚" + (post["likesCount"] as? String ?? "0")
        cell.CommentsCountLabel.text = "💬" + (post["commentsCount"] as? String ?? "0")

        return cell
        
        
        
    }
    // TODO: Fix this 
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let cell =  sender as! UITableViewCell
//        if let indexPath = tableView.indexPath(for: cell){
//            let post = posts[indexPath.row]
//            let questionDetailViewController = segue.destination as! QuestionDetailViewController
//            questionDetailViewController.question = post
//        }
//    }
//
    func fetchData(){
        let query = PFQuery(className: "Post")
        
        query.order(byDescending: "createdAt")
        query.includeKey("author")
        query.limit = 20
        
        //fetch Data
        query.findObjectsInBackground(block: { (fetchedPosts:[PFObject]?, error: Error?) in
            if let fetchedPosts = fetchedPosts{
                self.posts = fetchedPosts as! [Post]
            }else{
                
                if let error = error{
                    print(error.localizedDescription)
                }
            }
            self.tableView.reloadData()
        })
        
    
    }
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        //tableView Defaults
        tableView.dataSource = self;
        tableView.delegate = self;
        
//        tableView.rowHeight = UITableView.automaticDimension
//        tableView.estimatedRowHeight = 120
        
        self.fetchData()
        
        
        
    }

}
