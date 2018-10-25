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
    
    @IBOutlet weak var tableView: UITableView!
    var posts: [Post] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
        let post = posts[indexPath.row]
        
        cell.TitleLabel.text = post.title
        cell.TopAnswerLabel.text = "Be the first to answer this question to get a free milkshake!"
        cell.RaisesCountLabel.text = "🤚" + String(post.likesCount)
        cell.CommentsCountLabel.text = "💬" + String(post.commentsCount)
    
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell =  sender as! UITableViewCell
        if let indexPath = tableView.indexPath(for: cell){
            let questionDetailViewController = segue.destination as! QuestionDetailViewController
            questionDetailViewController.question = posts[indexPath.row] // = post
        }
    }
    
    
    //MARK: Fetch Data
    func fetchData(){
        let query = PFQuery(className: "Post")
        query.order(byDescending: "createdAt")
        query.includeKey("author")
        query.limit = 20
        
        //fetch Data
        query.findObjectsInBackground(block: { (fetchedPosts:[PFObject]?, error: Error?) in
            if let fetchedPosts = fetchedPosts as? [Post]{
                //I guess that the following for loop is not needed? this is working without it so idk.
//                for fetchedPost in fetchedPosts{
//                    let post = fetchedPost
//                    post.setValue(with: fetchedPost)
//                    self.posts.append(post)
//                }
                self.posts = fetchedPosts
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
