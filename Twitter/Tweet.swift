//
//  Tweet.swift
//  Twitter
//
//  Created by jasmine_lee on 10/31/16.
//  Copyright © 2016 jasmine_lee. All rights reserved.
//

import UIKit

class Tweet: NSObject {

    var profileName: String?
    var username: String?
    var text: String?
    var timestamp: Date?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    var profileUrl: URL?

    init(dictionary: NSDictionary) {
        
        text = dictionary["text"] as? String
        retweetCount = ((dictionary["retweet_count"] as? Int) ?? 0)!
        favoritesCount = ((dictionary["favorite_count"] as? Int) ?? 0)!
        username = dictionary.value(forKeyPath: "user.screen_name") as? String
        profileName = dictionary.value(forKeyPath: "user.name") as? String

        let urlString = dictionary.value(forKeyPath: "user.profile_image_url") as? String
        if let url = urlString {
            profileUrl = URL(string: url)
        }

        let timestampString = dictionary["created_at"] as? String

        if let timestampString = timestampString {
            let formatter = DateFormatter()
            formatter.date(from: "EEE MMM d HH:mm::ss Z y")
            timestamp = formatter.date(from: timestampString as String) as Date?
        }

    }

    class func tweetsWithArray (dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()

        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }

        return tweets
    }
}
