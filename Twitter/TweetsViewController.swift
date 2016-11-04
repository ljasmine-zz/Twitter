//
//  TweetsViewController.swift
//  Twitter
//
//  Created by jasmine_lee on 11/1/16.
//  Copyright © 2016 jasmine_lee. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tweets: [Tweet]!
    var refreshControl: UIRefreshControl?

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120

        getTimeline()

        // Initialize a UIRefreshControl
        refreshControl = UIRefreshControl()
        refreshControl!.addTarget(self, action: #selector(refreshControlAction(refreshControl:)), for: UIControlEvents.valueChanged)

        // add refresh control to table view
        tableView.insertSubview(refreshControl!, at: 0)
    }

    private func getTimeline() {
        TwitterClient.sharedInstance?.homeTimeline(success: { (tweets: [Tweet]) in
            self.tweets = tweets
            self.tableView.reloadData()

            // Tell the refreshControl to stop spinning
            self.refreshControl!.endRefreshing()

            for tweet in tweets {
                print(tweet.text)
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

        return cell
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
