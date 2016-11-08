//
//  TweetsViewController.swift
//  Twitter
//
//  Created by jasmine_lee on 11/1/16.
//  Copyright © 2016 jasmine_lee. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TweetCellDelegate {

    var tweets: [Tweet]!
    var refreshControl: UIRefreshControl?

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120

        let twitterLogo = UIImage(named: "Twitter_Logo_Blue")
        navigationItem.titleView = UIImageView(image: twitterLogo)

        // Initialize a UIRefreshControl
        refreshControl = UIRefreshControl()
        refreshControl!.addTarget(self, action: #selector(refreshControlAction(refreshControl:)), for: UIControlEvents.valueChanged)

        // add refresh control to table view
        tableView.insertSubview(refreshControl!, at: 0)

    }

    override func viewWillAppear(_ animated: Bool) {
        getTimeline()
    }

    private func getTimeline() {
        TwitterClient.sharedInstance?.homeTimeline(success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()

            // Tell the refreshControl to stop spinning
            self.refreshControl!.endRefreshing()

            for tweet in tweets {
                print(tweet.text!)
            }

            }, failure: { (error: Error) in
                print(error.localizedDescription)
        })
    }

    private dynamic func refreshControlAction(refreshControl: UIRefreshControl) {
        getTimeline()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        tableView.contentInset.top = topLayoutGuide.length
        tableView.contentInset.bottom = bottomLayoutGuide.length
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onLogoutButton(_ sender: AnyObject) {
        TwitterClient.sharedInstance?.logout()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tweets != nil {
            return tweets.count
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell") as! TweetCell
        cell.tweet = tweets[indexPath.row]
        cell.delegate = self
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }

    @IBAction func replyAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: "replySegue", sender: nil)
    }

    @IBAction func onProfileTap(_ sender: UITapGestureRecognizer) {
        self.performSegue(withIdentifier: "profileSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let segueID = segue.identifier
        if segueID == "detailsSegue" {
            let cell = sender as! UITableViewCell
            let indexPath = self.tableView.indexPath(for: cell)!
            let tweet = tweets![indexPath.row]

            let detailViewController = segue.destination as! TweetDetailsViewController
            detailViewController.tweet = tweet

            print("prepare for segue called")
        } else if segueID == "replySegue" {
            print ("reply segue")
        } else if segueID == "profileSegue" {
            print ("profile segue")
//            let cell = sender as! UITableViewCell
//            let indexPath = self.tableView.indexPath(for: cell)!
//            let tweet = tweets![indexPath.row]
//
//            let detailViewController = segue.destination as! ProfileViewViewController
////            detailViewController.tweet = tweet
        }
    }

    func tweetCellChanged(_ cell: UITableViewCell, tweet: Tweet, action: String) {
        let path = tableView.indexPath(for: cell)

        if let indexPath = path {
            switch action {
            case TweetActionIdentifier.Retweet.rawValue:
                tweets![indexPath.row].retweeted = true
            case TweetActionIdentifier.UndoRetweet.rawValue:
                tweets![indexPath.row].retweeted = false
            case TweetActionIdentifier.Favorite.rawValue:
                tweets![indexPath.row].favorited = true
            case TweetActionIdentifier.UndoFavorite.rawValue:
                tweets![indexPath.row].favorited = false
            default: break
            }
        }
    }
}
