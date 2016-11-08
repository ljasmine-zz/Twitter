//
//  TweetDetailsViewController.swift
//  Twitter
//
//  Created by jasmine_lee on 11/6/16.
//  Copyright © 2016 jasmine_lee. All rights reserved.
//

import UIKit

@objc protocol TweetDetailsDelegate {
    @objc optional func refreshData()
}


class TweetDetailsViewController: UIViewController {

    weak var delegate: TweetDetailsDelegate?

    var tweet : Tweet!
    var isFavorited = false
    var isRetweeted = false

    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var tweetContentLabel: UILabel!
    @IBOutlet weak var retweetsCountLabel: UILabel!
    @IBOutlet weak var favoritesCountLabel: UILabel!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!

    @IBOutlet weak var favoriteButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        profileNameLabel.text = tweet.profileName!
        usernameLabel.text = "@\(tweet.username!) ·"
        timestampLabel.text = "\(tweet.timestampString!)"
        tweetContentLabel.text = tweet.text
        favoritesCountLabel.text = "\(tweet.favoritesCount)"
        retweetsCountLabel.text = "\(tweet.retweetCount)"

        if let url = tweet.profileUrl {
            print(url.absoluteString)
            profileImageView.setImageWith(url)
        }

        profileImageView.layer.cornerRadius = 3
        profileImageView.clipsToBounds = true

        let replyImage = UIImage(named: "reply")?.withRenderingMode(.alwaysTemplate)
        replyButton.setImage(replyImage, for: .normal)
        replyButton.tintColor = UIColor.lightGray

        toggleRetweetButton(turnOn: tweet.retweeted!)
        toggleFavoriteButton(turnOn: tweet.favorited!)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func retweetAction(_ sender: AnyObject) {

        if isRetweeted
        {
            TwitterClient.sharedInstance?.undoRetweet(id: tweet.id!, success: { (NSDictionary) in

                }, failure: { (error: Error) in
                    print(error.localizedDescription)
            })
            toggleRetweetButton(turnOn: false)
        } else {
            TwitterClient.sharedInstance?.retweet(id: tweet.id!, success: { (NSDictionary) in

                }, failure: { (error: Error) in
                    print(error.localizedDescription)
            })
            toggleRetweetButton(turnOn: true)
        }
    }

    @IBAction func favoriteAction(_ sender: AnyObject) {
        if isFavorited
        {
            TwitterClient.sharedInstance?.undoFavorite(id: tweet.id!, success: { (NSDictionary) in
                
                }, failure: { (error: Error) in
                    print(error.localizedDescription)
            })
            toggleFavoriteButton(turnOn: false)
        } else {
            TwitterClient.sharedInstance?.favorite(id: tweet.id!, success: { (NSDictionary) in
                }, failure: { (error: Error) in
                    print(error.localizedDescription)
            })
            toggleFavoriteButton(turnOn: true)
        }
    }

    

    private func toggleRetweetButton (turnOn: Bool){

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

    private func toggleFavoriteButton (turnOn: Bool){
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
