//
//  Tweet.swift
//  Twitter
//
//  Created by jasmine_lee on 10/31/16.
//  Copyright © 2016 jasmine_lee. All rights reserved.
//

import UIKit

class Tweet: NSObject {

    var text: NSString?
    var timestamp: NSDate?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0

    init(dictionary: NSDictionary) {
        text = dictionary["text"] as? NSString
        retweetCount = ((dictionary["retweet_count"] as? Int) ?? 0)!
        favoritesCount = ((dictionary["favourites_count"] as? Int) ?? 0)!

        let timestampString = dictionary["created_at"] as? NSString

        if let timestampString = timestampString {
            let formatter = DateFormatter()
            formatter.date(from: "EEE MMM d HH:mm::ss Z y")
            timestamp = formatter.date(from: timestampString as String) as NSDate?
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
