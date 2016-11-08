//
//  TwitterClient.swift
//  Twitter
//
//  Created by jasmine_lee on 11/1/16.
//  Copyright © 2016 jasmine_lee. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {

    static let sharedInstance = TwitterClient (baseURL: NSURL(string: "https://api.twitter.com")! as URL!, consumerKey: "4AYghgly1PjU96njbjSPWDdeH", consumerSecret: "LLDhDrMKDOzYcy17KBlXThtM5mbyoAwU8UTirx2RPlmuiehbqz")

    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ())?

    func login(success: @escaping () -> (), failure: @escaping (Error) -> () ) {

        loginSuccess = success
        loginFailure = failure

        deauthorize()
        fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: NSURL(string: "twitter://oauth") as URL!, scope: nil, success: { (requestToken: BDBOAuth1Credential?) -> Void in
            print("I got a token!")

            let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken!.token!)")!
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)

            }, failure: { (error: Error?) -> () in
                print("error: \(error?.localizedDescription)")
                self.loginFailure?(error!)
        })
    }

    func logout () {
        User.currentUser = nil
        deauthorize()
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.userDidLogoutNotification), object: nil)
    }

    func getUser (username: String, success: @escaping (User) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/users/show.json", parameters: ["screen_name": username], progress: nil, success: { (task: URLSessionDataTask, response: Any?) in

            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)

            success(user)
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }

    func handleOpenUrl (url: NSURL) {

        let requestToken = BDBOAuth1Credential(queryString: url.query)

        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential?) -> Void in

            self.currentAccount(success: { (user: User) -> () in
                User.currentUser = user
                self.loginSuccess?()
            }, failure: { (error: Error) -> () in
                self.loginFailure?(error)
            })
            
        } , failure: { (error: Error?) -> () in
                self.loginFailure?(error!)
        })
    }

    func currentAccount(success: @escaping (User) -> (), failure: @escaping (Error) -> ()) {
        
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in

            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)

            success(user)

            print("name: \(user.name)")
            print("screenname: \(user.screenname)")
            print("profile url: \(user.profileUrl)")
            print("description: \(user.tagline)")

        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }

    func homeTimeline(success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {

        get("1.1/statuses/home_timeline.json", parameters: ["include_entities": true], progress: nil, success: { (_: URLSessionDataTask, response: Any?) in

                let dictionaries = response as! [NSDictionary]
                let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
                success(tweets)
            }, failure: { (task: URLSessionDataTask?, error: Error) in
                failure(error)
        })
    }

    func favorite (id: Int, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {

        post("1.1/favorites/create.json", parameters: ["id": id], progress: nil, success: {(_: URLSessionDataTask, response: Any?) in
            let tweet = Tweet(dictionary: response as! NSDictionary)
            success(tweet)
            }, failure: { (task: URLSessionDataTask?, error: Error) in
                failure(error)
        })
    }

    func undoFavorite (id: Int, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {

        post("1.1/favorites/destroy.json", parameters: ["id": id], progress: nil, success: {(_: URLSessionDataTask, response: Any?) in
            let tweet = Tweet(dictionary: response as! NSDictionary)
            success(tweet)
            }, failure: { (task: URLSessionDataTask?, error: Error) in
                failure(error)
        })
    }

    func retweet (id: Int, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {

        post("1.1/statuses/retweet/\(id).json", parameters: ["id": id], progress: nil, success: {(_: URLSessionDataTask, response: Any?) in
            let tweet = Tweet(dictionary: response as! NSDictionary)
            success(tweet)
            }, failure: { (task: URLSessionDataTask?, error: Error) in
                failure(error)
        })
    }

    func getTweet (id: Int, params: [String: Any?], success: @escaping (NSDictionary) -> (), failure: @escaping (Error) -> ()) {

        post("1.1/statuses/show/\(id).json", parameters: params, progress: nil, success: {(_: URLSessionDataTask, response: Any?) in
            let tweet = response as! NSDictionary
            success(tweet)
            }, failure: { (task: URLSessionDataTask?, error: Error) in
                failure(error)
        })
    }

    func undoRetweet (id: Int, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {

        getTweet(id: id, params: ["include_my_retweet": true], success: { (dict: NSDictionary) in
            let retweet_id = dict.value(forKeyPath: "current_user_retweet.id_str")
            self.post("1.1/statuses/unretweet/\(retweet_id).json", parameters: ["id": retweet_id], progress: nil, success: {(_: URLSessionDataTask, response: Any?) in
                let tweet = Tweet(dictionary: response as! NSDictionary)
                success(tweet)
                }, failure: { (task: URLSessionDataTask?, error: Error) in
                    failure(error)
            })

        }) { (error: Error) in
            failure(error)
        }
    }

    func postTweet (text: String, success: @escaping () -> (), failure: @escaping (Error) -> ()) {

        post("1.1/statuses/update.json", parameters: ["status": text], progress: nil, success: {(_: URLSessionDataTask, response: Any?) in
            success()
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }
}
