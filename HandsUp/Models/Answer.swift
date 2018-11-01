//
//  Answer.swift
//  HandsUp
//
//  Created by Nikhil Menon on 10/20/18.
//  Copyright © 2018 NSHWAHBWAH. All rights reserved.
//

import UIKit
import Parse

class Answer: PFObject, PFSubclassing {
    @NSManaged var postID: String   // Will be the same as the postID that the answer is answering to
    @NSManaged var author: PFUser
    @NSManaged var authorName: String
    @NSManaged var response: String //This is the actual response the user typed out.
    @NSManaged var rating: Int      // Rating will start as 0 and will be a 10 point scale.
    @NSManaged var date: String
    @NSManaged var likedBy: [String]
    @NSManaged var likesCount: Int
    
    
    
    
    class func parseClassName() -> String {
        return "Answer"
    }
    
    
    func setValues(with answer: PFObject?){
        if let answer = answer{     //These should all be required fields and shouldn't be nil. That's why these are all unwrapped.
            postID = answer["postID"] as! String
            if let author = answer.object(forKey: "author") as? PFUser{
                if let anonymity = author.value(forKey: "anonymous") as? Bool{
                    if anonymity{
                        authorName = "Anonymous slice 🍕"
                    } else {
                        authorName = author.username!
                    }
                }
            }
            response = answer["response"] as! String
            rating = answer["rating"] as! Int
            likedBy = answer["likedBy"] as? [String] ?? ["0"]
            
            let createdAt = answer.createdAt!
            date = formatTime(createdAt: createdAt)
            
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
    
    
    class func postAnswer(postReference: String?, response: String?, withCompletion completion: PFBooleanResultBlock?){
        let answer = Answer()
        answer.author = PFUser.current()!       //Stores the author
        
        if let postReference = postReference{
            answer.postID = postReference       //Stores the postID
        }
        
        if let response = response{
            answer.response = response          //Stores the respoonse
        }
        
        answer.rating = 0                       //Stores rating
        answer.saveInBackground(block: completion)
    }
    
    class func raiseHand(post: Answer?, withCompletion completion: PFBooleanResultBlock?) -> Int?{
        if let post = post{
            if let currentUser = PFUser.current(){
                print("post: \(post)")
                print("user: \(currentUser)")
                if post.likedBy.contains(currentUser.objectId!) {
                    currentUser.remove(post, forKey: "answersLiked")
                    currentUser.saveInBackground()
                    
                    post.incrementKey("likesCount", byAmount: -1)
                    post.remove(currentUser.objectId!, forKey: "likedBy")
                    post.saveInBackground(block: completion)
                    
                    //Because it is already liked?
                } else {
                    currentUser.add(post, forKey: "answersLiked")
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
