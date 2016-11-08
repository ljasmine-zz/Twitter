//
//  TweetCell.swift
//  Twitter
//
//  Created by jasmine_lee on 11/2/16.
//  Copyright © 2016 jasmine_lee. All rights reserved.
//

import UIKit
import AFNetworking

@objc protocol TweetCellDelegate {
    @objc optional func tweetCellChanged(_ cell: UITableViewCell, tweet: Tweet, action: String)
}

enum TweetActionIdentifier : String {
    case Retweet = "retweet"
    case UndoRetweet = "undoRetweet"
    case Favorite = "favorite"
    case UndoFavorite = "undoFavorite"
}


class TweetCell: UITableViewCell {

    weak var delegate: TweetCellDelegate?

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

    var isFavorited : Bool!
    var isRetweeted : Bool!
    var tweetId : Int!

    var tweet: Tweet! {
        didSet {
            profileTitleLabel.text = tweet.profileName
            usernameLabel.text = "@\(tweet.username!) ·"
            timestampLabel.text = "\(tweet.timestampString!)"
            tweetMessageLabel.text = tweet.text
            favoriteCountLabel.text = "\(tweet.favoritesCount)"
            retweetCountLabel.text = "\(tweet.retweetCount)"
            isFavorited = tweet.favorited
            isRetweeted = tweet.retweeted
            tweetId = tweet.id

            toggleRetweetButton(turnOn: isRetweeted, isRefresh: false)
            toggleFavoriteButton(turnOn: isFavorited, isRefresh: false)

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
    }

    @IBAction func retweetAction(_ sender: UIButton) {

        if isRetweeted == true
        {
            if tweet.retweetedStatus == nil {
                // original tweet
                TwitterClient.sharedInstance?.undoRetweet(id: tweetId!, success: { (updatedTweet: Tweet) in
                    self.delegate?.tweetCellChanged!(self, tweet: updatedTweet, action: TweetActionIdentifier.UndoRetweet.rawValue)
                    self.toggleRetweetButton(turnOn: false, isRefresh: true)
                    }, failure: { (error: Error) in
                        print(error.localizedDescription)
                })
            } else {
                let originalIdString = tweet.retweetedStatus!["id_str"] as! String
                let originalId = Int(originalIdString)

                TwitterClient.sharedInstance?.undoRetweet(id: originalId!, success: { (updatedTweet: Tweet) in
                    self.delegate?.tweetCellChanged!(self, tweet: updatedTweet, action: TweetActionIdentifier.UndoRetweet.rawValue)
                    self.toggleRetweetButton(turnOn: false, isRefresh: true)
                    }, failure: { (error: Error) in
                        print(error.localizedDescription)
                })
            }

        } else {

            TwitterClient.sharedInstance?.retweet(id: tweetId!, success: { (updatedTweet: Tweet) in
                self.delegate?.tweetCellChanged!(self, tweet: updatedTweet, action: TweetActionIdentifier.Retweet.rawValue)
                self.toggleRetweetButton(turnOn: true, isRefresh: true)
            }, failure: { (error: Error) in
                    print(error.localizedDescription)
            })
        }
    }

    @IBAction func favoriteAction(_ sender: UIButton) {
        if isFavorited == true
        {
            TwitterClient.sharedInstance?.undoFavorite(id: tweetId!, success: { (updatedTweet: Tweet) in
                self.delegate?.tweetCellChanged!(self, tweet: updatedTweet, action: TweetActionIdentifier.UndoFavorite.rawValue)
                self.toggleFavoriteButton(turnOn: false, isRefresh: true)
            }, failure: { (error: Error) in
                    print(error.localizedDescription)
            })
        } else {
            TwitterClient.sharedInstance?.favorite(id: tweetId!, success: { (updatedTweet: Tweet) in
                self.delegate?.tweetCellChanged!(self, tweet: updatedTweet, action: TweetActionIdentifier.Favorite.rawValue)
                self.toggleFavoriteButton(turnOn: true, isRefresh: true)
            }, failure: { (error: Error) in
                    print(error.localizedDescription)
            })
        }
    }


    private func toggleRetweetButton (turnOn: Bool, isRefresh: Bool){

        let retweetImage = UIImage(named: "retweet")?.withRenderingMode(.alwaysTemplate)
        retweetButton.setImage(retweetImage, for: .normal)

        if turnOn {
            retweetButton.tintColor = UIColor.green
            isRetweeted = true
        } else {
            retweetButton.tintColor = UIColor.lightGray
            isRetweeted = false
        }

    }

    private func toggleFavoriteButton (turnOn: Bool, isRefresh: Bool){
        let favoriteImage = UIImage(named: "favorite")?.withRenderingMode(.alwaysTemplate)
        favoriteButton.setImage(favoriteImage, for: .normal)

        if turnOn {
            favoriteButton.tintColor = UIColor.red
            isFavorited = true
        } else {
            favoriteButton.tintColor = UIColor.lightGray
            isFavorited = false
        }

    }

}
