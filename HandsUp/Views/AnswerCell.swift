//
//  AnswerCell.swift
//  HandsUp
//
//  Created by Claudia Nelson on 10/20/18.
//  Copyright © 2018 NSHWAHBWAH. All rights reserved.
//

//TODO:
// Be able to raise a hand to responses.


import UIKit

class AnswerCell: UITableViewCell {

    @IBOutlet weak var handCountLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    
    
    //TODO: This needs to do something.
    // Needs to up the raise count (labelled rating in JSON)
    @IBAction func raiseYourHand(_ sender: Any) {
        
        
    }
    
    
    
    
    func setValuesforAnswer(with answer: Answer?) -> Void{
        
            if let answer = answer{
                
                
                self.usernameLabel.text = answer.authorName
                self.dateLabel.text = answer.date
                self.answerLabel.text = answer.response
                
                
                self.handCountLabel.text = "\(answer.rating)"

                print("🤚 + \(answer.rating)")
                
            }else{
                print("No proper answer attribute given")
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
