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

class Post: PFObject, PFSubclassing {
    //TODO: make user private
    @NSManaged var author: PFUser
    @NSManaged var authorName: String //Stores the name anonymity
    @NSManaged var title: String
    @NSManaged var question: String
    @NSManaged var likesCount: Int
    @NSManaged var commentsCount: Int
    @NSManaged var dateCreated: String
    @NSManaged var likedBy: [String]
    
    func setValue(with post: PFObject?) {
        if let post = post{
            title = post["title"] as? String ?? "No question title"
            question = post["question"] as? String ?? ""
            likesCount = post["likesCount"] as? Int ?? 0
            commentsCount = post["commentsCount"] as? Int ?? 0
            likedBy = post["likedBy"] as? [String] ?? ["0"]
            if let author = post.object(forKey: "author") as? PFUser{
                if let anonymity = author.value(forKey: "anonymous") as? Bool{
                    if anonymity{
                        authorName = "Anonymous slice 🍕"
                    } else {
                        authorName = author.username!
                    }
                }
            }
            let createdAt = post.createdAt!
            dateCreated = formatTime(createdAt: createdAt)
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
    
    class func raiseHand(post: Post?, withCompletion completion: PFBooleanResultBlock?) -> Int?{
        if let post = post{
            if let currentUser = PFUser.current(){
                print("post: \(post)")
                print("user: \(currentUser)")
                if post.likedBy.contains(currentUser.objectId!) {
                    currentUser.remove(post, forKey: "postsLiked")
                    currentUser.saveInBackground()
                    
                    post.incrementKey("likesCount", byAmount: -1)
                    post.remove(currentUser.objectId!, forKey: "likedBy")
                    post.saveInBackground(block: completion)
                    
                    //Because it is already liked?
                } else {
                    currentUser.add(post, forKey: "postsLiked")
                    currentUser.saveInBackground()
                    
                    post.incrementKey("likesCount")
                    post.add(currentUser.objectId!, forKey: "likedBy")
                    post.saveInBackground(block: completion)
                    //Because it has not been liked yet?
                }
                return post.likesCount
            }
        }
        return nil
    }
}
