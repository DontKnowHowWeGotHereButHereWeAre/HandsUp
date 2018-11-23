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
        cell.authorLabel.text = post.authorName
        cell.dateLabel.text = " · " + post.dateCreated
        cell.questionDetailLabel.text = String(post.question)
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
                //The following loop is needed to update the anonymity and date labels of the posts
                for fetchedPost in fetchedPosts{
                    let post = fetchedPost
                    post.setValue(with: fetchedPost)
                    self.posts.append(post)
                }
                self.posts = fetchedPosts
            }else{
                if let error = error{
                    print(error.localizedDescription)
                }
            }
            self.tableView.reloadData()
        })
        
    
    }
    
    @objc func refreshHomeAction(_ refreshControl: UIRefreshControl){
        self.fetchData()
        refreshControl.endRefreshing()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.fetchData()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Refresh control stuff
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshHomeAction(_:)), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl)
        
        

        //tableView Defaults
        tableView.dataSource = self;
        tableView.delegate = self;
        
        self.fetchData()
    }

}
