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
                raiseCountLabel.text? = "🤚" + (question["likesCount"] as? String ?? "0")
                answersCountLabel.text? = "💬" + (question["commentsCount"] as? String ?? "0")
            }
            print(question)
        }
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
