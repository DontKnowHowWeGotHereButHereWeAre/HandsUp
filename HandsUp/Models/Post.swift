//
//  Post.swift
//  HandsUp
//
//  Created by Claudia Nelson on 10/20/18.
//  Copyright © 2018 NSHWAHBWAH. All rights reserved.
//

import Foundation
import UIKit
import Parse

// I am trying to make a mdoel for our posts, but I have not finished this
// Right now, this is unused.
class Post: PFObject, PFSubclassing {
    @NSManaged var author: PFUser
    @NSManaged var title: String
    @NSManaged var question: String
    @NSManaged var likesCount: Int
    @NSManaged var commentsCount: Int
    @NSManaged var anonymity: Bool
    @NSManaged var dateCreated: String
    
    var post: PFObject?{
        didSet{
            if let post = post{
                title = post["title"] as? String ?? ""
                question = post["question"] as? String ?? ""
                likesCount = post["likesCount"] as? Int ?? 0
                commentsCount = post["commentsCount"] as? Int ?? 0
                if let author = post.object(forKey: "author") as? PFUser{
                    self.author = author
                    if let anonymity = author.value(forKey: "anonymous") as? Bool{
                        self.anonymity = anonymity
                    }
                }
                let createdAt = post.createdAt!
                dateCreated = formatTime(createdAt: createdAt)
            }
        }
    }

// MARK: date formatter returns string of formatted date
func formatTime(createdAt: Date) -> String{
    // Configure the input format to parse the date string
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    
    //Create String from created_at date
    let createdAtString = formatter.string(from: createdAt)
    
    // Convert String to Date
    let date = formatter.date(from: createdAtString)!
    // Configure output format
    formatter.dateStyle = .short
    formatter.timeStyle = .none
    // Convert Date to String
    return formatter.string(from: date)
    
}
    
    //Required Function
    class func parseClassName() -> String {
        return "Post"
    }
    
    /**
     * Other methods
     */
    
    /**
     Method to add a user post to Parse (uploading image file)
     
     - parameter title: String that represents the topic of the question
     - parameter question: Question text input by the user
     - parameter completion: Block to be executed after save operation is complete
     */
    
    
    class func postQuestion(title: String?, withQuestion question: String?, withCompletion completion: PFBooleanResultBlock?){
        
        let post = Post()
        post.author = PFUser.current()!
        if let title = title {
            post.title = title
        }
        if let question = question{
            post.question = question
        }
        post.likesCount = 0
        post.commentsCount = 0
        
        post.saveInBackground(block: completion)
    }
    
    
}
