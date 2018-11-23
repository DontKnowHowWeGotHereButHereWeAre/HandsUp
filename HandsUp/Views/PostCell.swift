//
//  PostCell.swift
//  HandsUp
//
//  Created by Nikhil Menon on 10/20/18.
//  Copyright © 2018 NSHWAHBWAH. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {

    
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var questionDetailLabel: UILabel!
    @IBOutlet weak var RaisesCountLabel: UILabel!
    @IBOutlet weak var CommentsCountLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
