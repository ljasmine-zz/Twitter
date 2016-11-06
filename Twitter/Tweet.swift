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
    var timestampString: String?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    var profileUrl: URL?

    static let characterLimit = 140
    static let TWITTER_BLUE = UIColor(red: 29.0/255.0, green: 142.0/255.0, blue: 238.0/255.0, alpha: 1.0)


    init(dictionary: NSDictionary) {

        super.init()
        
        text = dictionary["text"] as? String
        retweetCount = ((dictionary["retweet_count"] as? Int) ?? 0)!
        favoritesCount = ((dictionary["favorite_count"] as? Int) ?? 0)!
        username = dictionary.value(forKeyPath: "user.screen_name") as? String
        profileName = dictionary.value(forKeyPath: "user.name") as? String

        let urlString = dictionary.value(forKeyPath: "user.profile_image_url") as? String
        if let url = urlString {
            profileUrl = URL(string: url)
        }

        let timeStr = dictionary["created_at"] as? String

        if let timeStr = timeStr {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            let timestamp = formatter.date(from: timeStr)

            timestampString = formatTimestamp(date: timestamp!)
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

    private func formatTimestamp (date: Date) -> String {

        let calendar = NSCalendar.current

        let currentTime = Date()

        let components = calendar.dateComponents([.second, .minute, .hour, .day], from: date, to: currentTime)

        let days = components.day!
        let hours = components.hour!
        let minutes = components.minute!
        let seconds = components.second!

        var formattedTimestamp = "just now"

        if days >= 7 {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            formattedTimestamp = formatter.string(from: date)
        } else if days >= 1 {
            formattedTimestamp = "\(days)d"
        } else if hours >= 1 {
            formattedTimestamp = "\(hours)h"
        } else if minutes >= 1 {
            formattedTimestamp = "\(minutes)m"
        } else if seconds >= 1 {
            formattedTimestamp = "\(seconds)s"
        }

        return formattedTimestamp
    }
}
