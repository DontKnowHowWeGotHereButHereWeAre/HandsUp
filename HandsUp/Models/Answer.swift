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
    @NSManaged var response: String //This is the actual response the user typed out.
    @NSManaged var rating: Int      // Rating will start as 0 and will be a 10 point scale.
    
    
    
    
    class func parseClassName() -> String {
        return "Answer"
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
    
    
    
}
