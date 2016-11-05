//
//  TweetCell.swift
//  Twitter
//
//  Created by jasmine_lee on 11/2/16.
//  Copyright © 2016 jasmine_lee. All rights reserved.
//

import UIKit
import AFNetworking

class TweetCell: UITableViewCell {

    @IBOutlet weak var profileTitleLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var tweetMessageLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!

    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!

    var tweet: Tweet! {
        didSet {
            profileTitleLabel.text = tweet.profileName
            usernameLabel.text = "@\(tweet.username!) ·"
            timestampLabel.text = "3h"
            tweetMessageLabel.text = tweet.text
            favoriteCountLabel.text = "\(tweet.favoritesCount)"
            retweetCountLabel.text = "\(tweet.retweetCount)"

            if let url = tweet.profileUrl {
                print(url.absoluteString)
                profileImageView.setImageWith(url)
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        setUp()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    private func setUp(){

        profileImageView.layer.cornerRadius = 3
        profileImageView.clipsToBounds = true

        let replyImage = UIImage(named: "reply")?.withRenderingMode(.alwaysTemplate)
        replyButton.setImage(replyImage, for: .normal)
        replyButton.tintColor = UIColor.lightGray

        let retweetImage = UIImage(named: "retweet")?.withRenderingMode(.alwaysTemplate)
        retweetButton.setImage(retweetImage, for: .normal)
        retweetButton.tintColor = UIColor.lightGray

        let favoriteImage = UIImage(named: "favorite")?.withRenderingMode(.alwaysTemplate)
        favoriteButton.setImage(favoriteImage, for: .normal)
        favoriteButton.tintColor = UIColor.lightGray
    }

}
