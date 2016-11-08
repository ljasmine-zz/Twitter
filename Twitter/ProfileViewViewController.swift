//
//  ProfileViewViewController.swift
//  Twitter
//
//  Created by jasmine_lee on 11/7/16.
//  Copyright © 2016 jasmine_lee. All rights reserved.
//

import UIKit

class ProfileViewViewController: UIViewController {

    @IBOutlet weak var profileView: ProfileView!

//    var tweet: Tweet! {
//        didSet {
//            profileTitleLabel.text = tweet.profileName
//            usernameLabel.text = "@\(tweet.username!) ·"
//            timestampLabel.text = "\(tweet.timestampString!)"
//            tweetMessageLabel.text = tweet.text
//            favoriteCountLabel.text = "\(tweet.favoritesCount)"
//            retweetCountLabel.text = "\(tweet.retweetCount)"
//            isFavorited = tweet.favorited
//            isRetweeted = tweet.retweeted
//            tweetId = tweet.id
//
//            toggleRetweetButton(turnOn: isRetweeted, isRefresh: false)
//            toggleFavoriteButton(turnOn: isFavorited, isRefresh: false)
//
//            if let url = tweet.profileUrl {
//                print(url.absoluteString)
//                profileImageView.setImageWith(url)
//            }
//        }
//    }


    override func viewDidLoad() {
        super.viewDidLoad()

        profileView.bannerImage = UIImage(named: "Twitter_Logo_Blue")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
