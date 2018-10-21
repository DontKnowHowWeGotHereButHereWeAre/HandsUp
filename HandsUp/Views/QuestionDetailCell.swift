//
//  QuestionDetailCell.swift
//  HandsUp
//
//  Created by Claudia Nelson on 10/20/18.
//  Copyright © 2018 NSHWAHBWAH. All rights reserved.
//

import UIKit
import Parse

class QuestionDetailCell: UITableViewCell {

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var raiseCountLabel: UILabel!
    @IBOutlet weak var answersCountLabel: UILabel!
    
    var question: PFObject?{
        didSet{
            if let question = question{
                questionLabel.text? = question["title"] as? String ?? ""
                detailLabel.text? = question["question"] as? String ?? ""
                raiseCountLabel.text? = "🤚" + (question["likesCount"] as? String ?? "0")
                answersCountLabel.text? = "💬" + (question["commentsCount"] as? String ?? "0")
                
                // MARK: checking the anonimity of a post
                if question.object(forKey: "author") != nil{
                    let author = question.object(forKey: "author") as! PFUser
                    print(author)
                    if let anonymous = author.value(forKey: "anonymous") as? Bool{
                        print(anonymous)
                        if anonymous{
                            authorLabel.text = "Anonymous werewolf 🐺"
                        }
                        else{
                            authorLabel.text = author.username
                        }
                    }
                }
                
                // MARK: formated date label
                let createdAt = question.createdAt!
                dateLabel.text = " · " + formatTime(createdAt: createdAt)
                
                print(question)
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
