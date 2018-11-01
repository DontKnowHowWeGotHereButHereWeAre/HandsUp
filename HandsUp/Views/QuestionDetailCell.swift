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
    
    var author: PFUser?
    private var question: Post?{
        didSet{
            if let question = question{
                questionLabel.text? = question.title
                detailLabel.text? = question.question
                raiseCountLabel.text? = String(question.likesCount)
                answersCountLabel.text? = "💬" + String(question.commentsCount)
                
                // MARK: checking the anonimity of a post
                authorLabel.text = question.authorName
                
                // MARK: formated date label
                dateLabel.text = " · " + question.dateCreated
                print(question)
            }
        }
    }
    func setValues(question: Post?){
        self.question = question
    }
    
    @IBAction func didTapRaise(_ sender: Any) {
        let raises = Post.raiseHand(post: question) { (success, error) in
            if success {
                print("successfully like")
            }
            else if let error =  error {
                print(error.localizedDescription)
            }
        }
        if let raises = raises{
            self.raiseCountLabel.text = String(raises)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
