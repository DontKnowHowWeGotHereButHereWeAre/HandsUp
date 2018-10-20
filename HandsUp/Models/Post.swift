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
    @NSManaged var author: PFUser
    @NSManaged var title: String
    @NSManaged var question: String
    @NSManaged var likesCount: Int
    @NSManaged var commentsCount: Int
    
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
