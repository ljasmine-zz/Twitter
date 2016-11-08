//
//  User.swift
//  Twitter
//
//  Created by jasmine_lee on 10/31/16.
//  Copyright © 2016 jasmine_lee. All rights reserved.
//

import UIKit

class User: NSObject {

    var name: String?
    var screenname: String?
    var profileUrl: URL?
    var profileBackgroundUrl: URL?
    var tagline: String?
    var followersCount: Int?
    var friendsCount: Int?
    var tweetsCount: Int?

    var dictionary: NSDictionary?

    init(dictionary: NSDictionary) {

        self.dictionary = dictionary
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        let profileUrlString = dictionary["profile_image_url_https"] as? String
        let profileBackgroundUrlString = dictionary["profile_background_image_url_https"] as? String

        if let profileUrlString = profileUrlString {
            profileUrl = URL(string: profileUrlString)
            print(profileUrlString)
        }

        if let profileBackgroundUrlString = profileBackgroundUrlString {
            profileBackgroundUrl = URL(string: profileBackgroundUrlString)
            print(profileBackgroundUrlString)
        }

        tagline = dictionary["description"] as? String

        followersCount = dictionary["followers_count"] as? Int
        friendsCount = dictionary["friends_count"] as? Int
        tweetsCount = dictionary["statuses_count"] as? Int
    }


    static let userDidLogoutNotification = "UserDidLogout"
    static var _currentUser: User?

    class var currentUser: User? {

        get {
            if _currentUser == nil {
                let defaults = UserDefaults.standard
                let userData = defaults.object(forKey: "currentUserData") as? Data

                if let userData = userData {
                    let dictionary = try! JSONSerialization.jsonObject(with: userData, options: []) as! NSDictionary
                    _currentUser = User(dictionary: dictionary)
                }
            }
            return _currentUser
        }

        set(user) {

            _currentUser = user

            let defaults = UserDefaults.standard

            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                defaults.set(data, forKey: "currentUserData")
            } else {
                defaults.set(nil, forKey: "currentUserData")
            }

            defaults.synchronize()
        }
    }


    
}
