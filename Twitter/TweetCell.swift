//
//  TweetCell.swift
//  Twitter
//
//  Created by jasmine_lee on 11/2/16.
//  Copyright © 2016 jasmine_lee. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    @IBOutlet weak var profileTitleLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var tweetMessageLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!

    var tweet: Tweet! {
        didSet {
            
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
